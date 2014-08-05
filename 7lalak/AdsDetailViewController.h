//
//  RegisterVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//


@import UIKit;
@import StoreKit;

@interface AdsDetailViewController : UIViewController

@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, strong) UIImageView *packageImageView;
@property (nonatomic, strong) UILabel *packageLable;
@property (nonatomic, strong) UITextView *productDescription;
@property (nonatomic, strong) UIButton *button;

@end
