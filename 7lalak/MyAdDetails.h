//
//  MyAdDetails.h
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdDetails : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UISegmentedControl *availability;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UILabel *labelCat;

@property (strong ,nonatomic) NSString * paramDescription;
@property (strong ,nonatomic) NSString * paramPrice;
@property (strong ,nonatomic) NSString * paramAvailabilityCode;
@property  (strong,nonatomic) NSString * paramAdId;
@property (strong ,nonatomic) NSString * paramStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnEditCat;

@property (weak, nonatomic) IBOutlet UILabel *labelCatName;
@property  (strong,nonatomic) NSString * paramMid;
@property  (strong,nonatomic) NSString * paramSid;
@property (strong ,nonatomic) NSString * userID;
@property (strong ,nonatomic) NSString * apiKey;

@property (weak, nonatomic) IBOutlet UIPickerView *category_picker;

- (IBAction)btnEditCatClick:(id)sender;
- (IBAction)deleteBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;

@end
