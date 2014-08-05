//
//  AddImageVC.h
//  7lalak
//
//  Created by Faris IOS on 7/1/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageVC : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate> {
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    NSString *userID;
}
@property (strong, nonatomic) IBOutlet UITextView *fAdsText;
@property (strong, nonatomic) IBOutlet UITextField *fAdsPrice;
@property (strong,nonatomic) NSString *userID;
@property (strong,nonatomic) NSString *apiKey;
@property (weak, nonatomic) IBOutlet UIButton *upload_btn;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerCategories;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
@property (weak, nonatomic) IBOutlet UILabel *labelSelectCat;
- (IBAction)uploadButtonAction:(id)sender;


-(IBAction) getPhoto:(id) sender;

@end
