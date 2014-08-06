//
//  AddVideoVC.h
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddVideoVC : UIViewController<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate> {
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    NSString *userID;
}
@property (strong, nonatomic) IBOutlet UITextView *fAdsText;
@property (strong, nonatomic) IBOutlet UITextField *fAdsPrice;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (strong,nonatomic) NSString *userID;
@property (strong,nonatomic) NSString *apiKey;

@property (weak, nonatomic) IBOutlet UIButton *upload_btn;

@property (weak, nonatomic) IBOutlet UILabel *textVideoindicator;
@property (weak, nonatomic) IBOutlet UIImageView *imageVideoIndicator;
@property (weak, nonatomic) IBOutlet UIButton *buttonaddVideo;

- (IBAction)addVideoButton:(id)sender;

- (IBAction)uploadButtonAction:(id)sender;



@end
