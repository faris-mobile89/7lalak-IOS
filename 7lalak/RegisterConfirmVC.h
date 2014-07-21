//
//  RegisterConfirmVC.h
//  7lalak
//
//  Created by Faris IOS on 7/16/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterConfirmVC : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textVerificationCode;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong,nonatomic) NSString *phoneNumber;
- (IBAction)btnLoginClick:(id)sender;

@end
