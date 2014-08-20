//
//  AddMoreImagesVC.h
//  7lalak
//
//  Created by Faris IOS on 8/19/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddMoreImagesDelegate <NSObject>
-(NSMutableArray *)didDoneClick:(NSMutableArray *)data;
@end

@interface AddMoreImagesVC : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *add_image;
@property (assign) id<AddMoreImagesDelegate> delegate;
@property int numberOfAllowedImage;
@property (strong, nonatomic)  NSMutableArray *imagesData;
- (IBAction)addImage:(id)sender;
- (IBAction)doneBtn:(id)sender;

@end

