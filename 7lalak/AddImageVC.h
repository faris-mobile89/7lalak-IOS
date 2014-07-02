//
//  AddImageVC.h
//  7lalak
//
//  Created by Faris IOS on 7/1/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageVC : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate> {
	UIImageView * imageView;
	UIButton * choosePhotoBtn;
	UIButton * takePhotoBtn;
    NSString *userID;
}
@property (weak, nonatomic) IBOutlet UITextField *fAdsText;
@property (weak, nonatomic) IBOutlet UITextField *fAdsPrice;
@property (strong,nonatomic) NSString *userID;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerCategories;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) IBOutlet UIButton * choosePhotoBtn;
@property (nonatomic, retain) IBOutlet UIButton * takePhotoBtn;
- (IBAction)uploadButtonAction:(id)sender;


-(IBAction) getPhoto:(id) sender;

@end
