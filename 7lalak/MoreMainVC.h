//
//  MoreMainVC.h
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreMainVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

- (IBAction)btnAdd:(id)sender;
- (IBAction)btnFav:(id)sender;
- (IBAction)btnAccountInfo:(id)sender;
- (IBAction)btnBuy:(id)sender;
- (IBAction)btnContact:(id)sender;
- (IBAction)btnAboutUS:(id)sender;
@end
