//
//  UserInfoVC.h
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *fUserName;
@property (weak, nonatomic) IBOutlet UILabel *fPhone;
@property (weak, nonatomic) IBOutlet UILabel *fAdsVideoCount;
@property (weak, nonatomic) IBOutlet UILabel *fAdsImagesCount;
@property (weak, nonatomic) IBOutlet UIButton *btnDeactive;
- (IBAction)btnDeactiveAccount:(id)sender;

@end
