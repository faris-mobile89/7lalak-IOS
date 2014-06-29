//
//  OffersVC.h
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICETutorialController.h"

@interface OffersVC : UIViewController<ICETutorialControllerDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ICETutorialController *viewController;
@property (weak, nonatomic) IBOutlet UIView *CustomView;

@end
