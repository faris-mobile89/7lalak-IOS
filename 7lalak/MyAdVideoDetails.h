//
//  MyAdVideoDetails.h
//  7lalak
//
//  Created by Faris IOS on 8/20/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdVideoDetails : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *availability;
@property (weak, nonatomic) IBOutlet UIImageView *iconVideoFlag;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (strong ,nonatomic) NSString * paramDescription;
@property (strong ,nonatomic) NSString * paramPrice;
@property (strong ,nonatomic) NSString * paramAvailabilityCode;
@property  (strong,nonatomic) NSString * paramAdId;
@property (strong ,nonatomic) NSString * paramStatus;
@property  (strong,nonatomic) NSString * paramMid;
@property  (strong,nonatomic) NSString * paramSid;
@property (strong ,nonatomic) NSString * userID;
@property (strong ,nonatomic) NSString * apiKey;
@property (strong ,nonatomic) NSString * videoURL;
@property  bool isUploadVideo;
- (IBAction)deleteBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *replaceVideo;
- (IBAction)replaceVideoClick:(id)sender;

@end
