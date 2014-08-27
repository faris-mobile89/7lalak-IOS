//
//  MyAdDetails.h
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMoreImagesVC.h"

@interface MyAdDetails : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AddMoreImagesDelegate>
@property (weak, nonatomic) IBOutlet UILabel *numberOfPickedImages;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIButton *btn_saveChanges;
@property (weak, nonatomic) IBOutlet UITextView *description;
- (IBAction)btnAddImageClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UILabel *lablel_add_image;
@property (weak, nonatomic) IBOutlet UITextField *categoryField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *availability;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
@property (strong,nonatomic) NSArray * arrImages;
@property (strong,nonatomic) NSString * catName;
@property (strong,nonatomic) id jsonImages;
@property (strong,nonatomic) NSMutableArray *attachedNewImages;
- (IBAction)deleteBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;

@end
