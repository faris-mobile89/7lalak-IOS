//
//  FruitDetailViewController.h
//  BuyFruit
//
//  Created by Michael Beyer on 19.09.13.
//  Copyright (c) 2013 Michael Beyer. All rights reserved.
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
