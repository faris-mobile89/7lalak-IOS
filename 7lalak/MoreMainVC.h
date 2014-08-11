//
//  MoreMainVC.h
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Localization.h"

@interface MoreMainVC : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btn6;
@property (weak, nonatomic) IBOutlet UIButton *btn7;
@property (weak, nonatomic) IBOutlet UIView *holderBtns;
- (IBAction)btnMyAds:(id)sender;
- (IBAction)btnAdd:(id)sender;
- (IBAction)btnFav:(id)sender;
- (IBAction)btnAccountInfo:(id)sender;
- (IBAction)btnBuy:(id)sender;
- (IBAction)btnContact:(id)sender;
- (IBAction)btnAboutUS:(id)sender;
@end
