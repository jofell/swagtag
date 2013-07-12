//
//  STCoreCalls.h
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import <Foundation/Foundation.h>

NSUInteger random_below(NSUInteger n);

@interface STCoreCalls : NSObject
+ (void) setUserEmail:(NSString *)email;
+ (NSString *) userEmail;


@end

@interface NSMutableArray (ArchUtils_Shuffle)
- (NSArray *)shuffle;
@end
