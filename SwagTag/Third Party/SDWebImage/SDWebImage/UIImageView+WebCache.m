/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#include <sys/utsname.h>

//
// For anybody trying to copy 'n paste:
//

@implementation NSRegularExpression (Dwellable)

+ (NSRegularExpression *)re:(NSString *)s
{
    return[NSRegularExpression regularExpressionWithPattern:s options:0 error:nil];
}

- (BOOL)matches:(NSString *)s
{
    return [self numberOfMatchesInString:s options:0 range:NSMakeRange(0, s.length)];
}

@end


@implementation NSString (Dwellable)

- (BOOL)matches:(NSRegularExpression *)re
{
    return [re matches:self];
}

@end


@implementation UIImage (Dwellable)


- (UIImage *)crop:(CGRect)rect
{
    return [self copyFromRect:rect toSize:rect.size];
}

- (UIImage *)copyToSize:(CGSize)dstSize
{
    return [self copyFromRect:CGRectMake(0, 0, self.size.width, self.size.height)
                       toSize:dstSize];
}

- (UIImage *)copyFromRect:(CGRect)srcRect toSize:(CGSize)dstSize
{
    //
    // gModel and friends
    //
    // iphone
    // 1:   412mhz 128mb iPhone1,1
    // 3g:  412mhz 128mb iPhone1,2
    // 3gs: 600mhz 256mb iPhone2,1
    // 4:   800mhz 512mb iPhone3,1-3
    // 4s:  2x1ghz 512mb iPhone4,1
    //
    // ipad
    // 1:   1ghz 256mb iPad1,1-2
    // 2: 2x1ghz 512mb iPad2,1-2
    // 3: 2x1ghz 1gb   iPad3
    //
    // ipod
    // 1: 412mhz 128mb iPod1,1
    // 2: 533mhz 128mb iPod2,1
    // 3: 600mhz 256mb iPod3,1
    // 4: 800mhz 256mb iPod4,1
    //
    
    struct utsname u;
    uname(&u);
    NSString *gModel = [NSString stringWithCString:u.machine encoding:NSASCIIStringEncoding];
    
    // < 600mhz
    BOOL gIsLowCPU = [gModel matches:[NSRegularExpression re:@"^(iPhone1|iPod[12])"]];
    // old iphones/ipod/ipads
    BOOL gIsLowRam = [gModel matches:[NSRegularExpression re:@"^(iPhone1|iPod[12]|iPad1)"]];
    
    
    //
    // apply scale if necessary
    //
    
    int scale = self.scale;
    if (scale > 1) {
        srcRect = CGRectMake(srcRect.origin.x   * scale, srcRect.origin.y    * scale,
                             srcRect.size.width * scale, srcRect.size.height * scale);
        dstSize = CGSizeMake(dstSize.width * scale, dstSize.height * scale);
    }
    
    //
    // create the context
    //
    
    int bpc = 8;
    CGBitmapInfo bmi = kCGImageAlphaPremultipliedFirst;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (gIsLowRam) {
        // 16bit if we don't have an alpha channel (this saves a ton of memory)
        CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
        if (alpha == kCGImageAlphaNone || alpha == kCGImageAlphaNoneSkipLast ||
            alpha == kCGImageAlphaNoneSkipFirst) {
            bpc = 5;
            bmi = kCGImageAlphaNoneSkipFirst;
        }
    }
    CGContextRef context = CGBitmapContextCreate(NULL, dstSize.width, dstSize.height,
                                                 bpc, 0, colorSpace, bmi);
    CGColorSpaceRelease(colorSpace);
    
    //
    // interpolation quality set to high on everything but old iphones
    //
    
    CGInterpolationQuality quality = kCGInterpolationHigh;
    if (gIsLowCPU) {
        quality = kCGInterpolationDefault;
    }
    CGContextSetInterpolationQuality(context, quality);
    
    //
    // choose srcImage
    //
    
    CGImageRef srcImage;
    if (!CGRectEqualToRect(srcRect, CGRectMake(0, 0, self.size.width * scale,
                                               self.size.height * scale))) {
        srcImage = CGImageCreateWithImageInRect(self.CGImage, srcRect);
    } else {
        srcImage = CGImageRetain(self.CGImage);
    }
    
    //
    // copy
    //
    
    CGContextDrawImage(context, CGRectMake(0, 0, dstSize.width, dstSize.height),
                       srcImage);
    CGImageRelease(srcImage);
    CGImageRef dst = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *result = [UIImage imageWithCGImage:dst scale:scale
                                    orientation:UIImageOrientationUp];
    CGImageRelease(dst);
    return result;
}
@end



@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = [placeholder copyToSize:placeholder.size];

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = [placeholder copyToSize:placeholder.size];

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = [image copyToSize:image.size];
    [self setNeedsLayout];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = [image copyToSize:image.size];
    [self setNeedsLayout];
}

@end

