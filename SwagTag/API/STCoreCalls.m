//
//  STCoreCalls.m
//  SwagTag
//
//  Created by Jofell Gallardo on 9/29/12.
//  Copyright (c) 2012 Jofell Gallardo. All rights reserved.
//

#import "STCoreCalls.h"



@implementation STCoreCalls

+ (void) setUserEmail:(NSString *)email {
    NSUserDefaults *udef = [NSUserDefaults standardUserDefaults];
    [udef setObject:email forKey:@"user_email"];
    [udef synchronize];
}

+ (NSString *) userEmail {
    NSUserDefaults *udef = [NSUserDefaults standardUserDefaults];
    return [udef objectForKey:@"user_email"];
}

@end

// Chooses a random integer below n without bias.
// Computes m, a power of two slightly above n, and takes random() modulo m,
// then throws away the random number if it's between n and m.
// (More naive techniques, like taking random() modulo n, introduce a bias
// towards smaller numbers in the range.)
NSUInteger random_below(NSUInteger n) {
    NSUInteger m = 1;
    
    // Compute smallest power of two greater than n.
    // There's probably a faster solution than this loop, but bit-twiddling
    // isn't my specialty.
    do {
        m <<= 1;
    } while(m < n);
    
    NSUInteger ret;
    
    do {
        ret = random() % m;
    } while(ret >= n);
    
    return ret;
}

@implementation NSMutableArray (ArchUtils_Shuffle)

- (NSArray *)shuffle {
    // http://en.wikipedia.org/wiki/Knuth_shuffle
    
    for(NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = random_below(i);
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
    
    return self.copy;
}

@end