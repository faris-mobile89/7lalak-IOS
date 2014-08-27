//
//  RegisterVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "InAppAPHelper.h"

static NSString *kIdentifier1  = @"com.7lalek.hlalek.product1_FN";
static NSString *kIdentifier2  = @"com.7lalek.hlalek.product2_FN";
static NSString *kIdentifier3  = @"com.7lalek.hlalek.product3_FN";
static NSString *kIdentifier4  = @"com.7lalek.hlalek.product4_FN";
static NSString *kIdentifier5  = @"com.7lalek.hlalek.product5_FN";
static NSString *kIdentifier6  = @"com.7lalek.hlalek.product6_FN";
static NSString *kIdentifier7  = @"com.7lalek.hlalek.product7_FN";


@implementation InAppAPHelper

// Obj-C Singleton pattern
+ (InAppAPHelper *)sharedInstance {
    static InAppAPHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     kIdentifier1,
                                     kIdentifier2,
                                     kIdentifier3,
                                     kIdentifier4,
                                     kIdentifier5,
                                     kIdentifier6,
                                     kIdentifier7,
                                     nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (NSString *)imageNameForProduct:(SKProduct *)product
{
    /*if ([product.productIdentifier isEqualToString:kIdentifier1]) {
        return @"image_apple";
    }*/
    return @"Icon-60.png";
}

- (NSString *)descriptionForProduct:(SKProduct *)product
{
    
    if ([product.productIdentifier isEqualToString:kIdentifier1]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifier2]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifier3]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifier4]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifier5]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifier6]) {
        return product.localizedDescription;
    }
    if ([product.productIdentifier isEqualToString:kIdentifier7]) {
        return product.localizedDescription;
    }
    return nil;
}

@end
