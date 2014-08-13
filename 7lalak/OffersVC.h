//
//  OffersVC.h
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OffersVC : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *tabOffers;

@property (weak, nonatomic) IBOutlet UIWebView *fWebView;
@end
