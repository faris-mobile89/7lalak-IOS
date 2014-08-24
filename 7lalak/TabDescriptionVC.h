//
//  TabDescriptionVC.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface TabDescriptionVC : UIViewController<MFMessageComposeViewControllerDelegate ,UINavigationControllerDelegate>

@property (weak,nonatomic) id jsonObject;
@property (weak, nonatomic) IBOutlet UILabel *numberOfViews;
@property (weak, nonatomic) IBOutlet UILabel *label_views;

@property (weak, nonatomic) IBOutlet UIImageView *fImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgSoldFlag;
@property (weak, nonatomic) IBOutlet UILabel *fPhone;
@property (weak, nonatomic) IBOutlet UILabel *fDate;
@property (weak, nonatomic) IBOutlet UILabel *fPrice;
@property (weak, nonatomic) IBOutlet UITextView *fDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnFav1;
@property (weak, nonatomic) IBOutlet UIImageView *iconFav;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;

- (IBAction)btnFavClick:(id)sender;
- (IBAction)btnCallClick:(id)sender;
- (IBAction)btnMessageClick:(id)sender;
- (IBAction)btnWhatsappClick:(id)sender;

@end
