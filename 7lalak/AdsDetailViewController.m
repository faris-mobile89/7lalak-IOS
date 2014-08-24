//
//  RegisterVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "AdsDetailViewController.h"
#import "InAppAPHelper.h"
#include "UIColor_hex.h"
#import "LocalizeHelper.h"

@interface AdsDetailViewController ()

@end

@implementation AdsDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    self.title = LocalizedString(@"TITLE_MORE_BUY_Ads");
    CGRect frame = self.view.frame;
    frame.size.height -= 100;
    self.view.frame = frame;
    
    [super viewWillAppear:animated];
    self.title = self.product.localizedTitle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    /*
    if (self.product != nil) {
        // Check if chosen product has been bought yet
        if ([[NSUserDefaults standardUserDefaults] boolForKey:self.product.productIdentifier]){
            NSLog(@"Product purchased");
            
            NSString *imageName = [[InAppAPHelper sharedInstance] imageNameForProduct:self.product];
            self.packageImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
            self.packageImageView.frame = CGRectMake((self.view.frame.size.width / 2) - (self.packageImageView.frame.size.width / 2), (self.view.frame.size.height / 2) - (self.packageImageView.frame.size.height / 2), self.packageImageView.frame.size.width, self.packageImageView.frame.size.height);
            [self.view addSubview:self.packageImageView];
            
            self.packageLable = [[UILabel alloc] initWithFrame:CGRectMake(40, (self.view.frame.size.height - 70), 240, 50)];
            self.packageLable.text = @"hlalek";
            self.packageLable.numberOfLines = 0;
            self.packageLable.textColor = [UIColor darkGrayColor];
            self.packageLable.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.packageLable];
        }
    }
     */ // NSLog(@"Product not purchased");
    
            self.packageLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 10, 80)];
            self.packageLable.text = @"";
            self.packageLable.numberOfLines = 0;
            self.packageLable.textColor = [UIColor darkGrayColor];
            self.packageLable.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.packageLable];
            
            self.productDescription = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, (self.view.frame.size.width - 40), self.view.frame.size.height)];
            NSString *fruitDescription = [[InAppAPHelper sharedInstance] descriptionForProduct:self.product];
            self.productDescription.text = fruitDescription;
            self.productDescription.editable = NO;
            self.productDescription.textColor = [UIColor darkGrayColor];
            self.productDescription.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.productDescription];
    
           UIImageView *imageCoins = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 128, 128)];
           [imageCoins setImage:[UIImage imageNamed:@"ic_coins.png"]];
           [self.view addSubview:imageCoins];
    
            self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.button.frame = CGRectMake(40, (self.view.frame.size.height - 70), 240, 50);
            self.button.layer.cornerRadius = 5.0;
            [self.button addTarget:self action:@selector(buyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            // [self.button setBackgroundColor:[UIColor lightGrayColor]];
            [self.button setBackgroundColor:[UIColor colorWithHexString:@"0096d2"]];
            [self.button setTintColor:[UIColor whiteColor]];
            NSString *title = [[NSString alloc]initWithFormat:@"%@ - %@%@",LocalizedString(@"BuyThisPackage"),_product.price,@"$"];
            [self.button setTitle: title forState:UIControlStateNormal];
            [self.view addSubview:self.button];
}

- (void) refreshView
{
    [self.button removeFromSuperview];
    [self.packageLable removeFromSuperview];
    [self.productDescription removeFromSuperview];
    
    NSString *imageName = [[InAppAPHelper sharedInstance] imageNameForProduct:self.product];
    self.packageImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    self.packageImageView.frame = CGRectMake((self.view.frame.size.width / 2) - (self.packageImageView.frame.size.width / 2), (self.view.frame.size.height / 2) - (self.packageImageView.frame.size.height / 2), self.packageImageView.frame.size.width, self.packageImageView.frame.size.height);
    [self.view addSubview:self.packageImageView];
    
    self.packageLable = [[UILabel alloc] initWithFrame:CGRectMake(40, (self.view.frame.size.height - 70), 240, 50)];
    self.packageLable.text = @"7lalek";
    self.packageLable.numberOfLines = 0;
    self.packageLable.textColor = [UIColor darkGrayColor];
    self.packageLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.packageLable];
}

#pragma mark - UIButton Action
- (void)buyButtonPressed:(id)sender
{
    [[InAppAPHelper sharedInstance] buyProduct:self.product];
    
}

#pragma mark - StoreKit
- (void)productPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = notification.object;
    if ([self.product.productIdentifier isEqualToString:productIdentifier]) {
        NSLog(@"This product has been purchased!");
       // [self refreshView];
    }
}


@end
