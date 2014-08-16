//
//  UserInfoVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoVC : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *fUserName;
@property (weak, nonatomic) IBOutlet UILabel *fPhone;
@property (weak, nonatomic) IBOutlet UITextField *fAdsImagesCount;
@property (weak, nonatomic) IBOutlet UITextField *fAdsVideoCount;

@property (weak, nonatomic) IBOutlet UIButton *btnDeactive;
- (IBAction)btnDeactiveAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lable_adsScore;
@property (weak, nonatomic) IBOutlet UILabel *lablel_adVidScore;
@property (weak, nonatomic) IBOutlet UILabel *lable_adImageScore;
@property (weak, nonatomic) IBOutlet UILabel *label_paid_ads_title;
@property (weak, nonatomic) IBOutlet UILabel *label_paid_video;
@property (weak, nonatomic) IBOutlet UILabel *label_paid_image;
@property (weak, nonatomic) IBOutlet UITextField *fAdsPaid_video;
@property (weak, nonatomic) IBOutlet UITextField *fAdsPaid_image;

@end
