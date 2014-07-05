//
//  FruitIAPHelper.m
//  BuyFruit
//
//  Created by Michael Beyer on 16.09.13.
//  Copyright (c) 2013 Michael Beyer. All rights reserved.
//

#import "InAppAPHelper.h"

static NSString *kIdentifier1  = @"77aalleekk_package1";
static NSString *kIdentifier2  = @"77aalleekk_package2";

@implementation InAppAPHelper

// Obj-C Singleton pattern
+ (InAppAPHelper *)sharedInstance {
    static InAppAPHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     kIdentifier1,
                                     kIdentifier2,
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
    return @"ic_defualt_image.png";
}

- (NSString *)descriptionForProduct:(SKProduct *)product
{
    
    if ([product.productIdentifier isEqualToString:kIdentifier1]) {
        return product.localizedDescription;
    }
    return nil;
}

@end
