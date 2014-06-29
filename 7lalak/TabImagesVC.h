//
//  TabImagesVC.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICETutorialController.h"

@interface TabImagesVC : UIViewController<ICETutorialControllerDelegate>
@property (strong,nonatomic) NSString *var;
@property (weak,nonatomic) id jsonObject;
//- (void)setupScrollView:(UIScrollView*)scrMain ;
@property (strong, nonatomic) ICETutorialController *viewController;
@end
