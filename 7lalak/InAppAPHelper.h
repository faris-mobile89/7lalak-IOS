//
//  RegisterVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//


#import "IAPHelper.h"

@interface InAppAPHelper : IAPHelper

+ (InAppAPHelper *)sharedInstance;

- (NSString *)imageNameForProduct:(SKProduct *)product;
- (NSString *)descriptionForProduct:(SKProduct *)product;

@end
