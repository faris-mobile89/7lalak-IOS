//
//  BuyAdsVC.m
//  7lalak
//
//  Created by Faris IOS on 7/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "BuyAdsVC.h"
#import "InAppAPHelper.h"
#import "LocalizeHelper.h"
#import "UIColor_hex.h"

@interface BuyAdsVC ()
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSNumberFormatter *priceFormatter;
@end

@implementation BuyAdsVC

#pragma mark - User Interface set up

- (id)init
{
    self = [super init];
    if (self) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(restoreTapped:)];
        
         self.priceFormatter = [[NSNumberFormatter alloc] init];
        [self.priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [self.priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.title = LocalizedString(@"TITLE_MORE_BUY_Ads");
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [super viewWillAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - StoreKit

/*
 When the reload is called (whether it be the first manual call, or when the user pulls to refresh), it calls the FruitIAPHelper’s requestProductsWithCompletionHandler method we wrote earlier to return the In-App Purchase product info from iTunes Connect. When this completes, the block will be called. All it does is store the list of products in the instance variable, reload the table view to display them, and tells the refresh control to stop animating.
 */


- (void)reload
{
    self.products = nil;
    [[InAppAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
        }
    }];
}

- (void)restoreTapped:(id)sender
{
    [[InAppAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)productPurchased:(NSNotification *)notification
{
    NSString *productIdentifier = notification.object;
    [self.products enumerateObjectsUsingBlock:^(SKProduct *product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            *stop = YES;
        }
    }];
}

- (void)buyButtonTapped:(id)sender
{
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = self.products[buyButton.tag];
    NSLog(@"Buying %@ ... (buyButtonTapped in BuyTableVC.m", product.productIdentifier);
    [[InAppAPHelper sharedInstance] buyProduct:product];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
