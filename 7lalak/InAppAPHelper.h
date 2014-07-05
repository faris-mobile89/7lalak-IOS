//
//  FruitIAPHelper.h
//  BuyFruit
//
//  Created by Michael Beyer on 16.09.13.
//  Copyright (c) 2013 Michael Beyer. All rights reserved.
//

#import "IAPHelper.h"

@interface InAppAPHelper : IAPHelper

+ (InAppAPHelper *)sharedInstance;

- (NSString *)imageNameForProduct:(SKProduct *)product;
- (NSString *)descriptionForProduct:(SKProduct *)product;

@end
