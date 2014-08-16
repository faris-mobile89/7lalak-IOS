//
//  HomePageVC.h
//  7lalak
//
//  Created by Faris IOS on 7/2/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *fImageTopAds;
@property (weak, nonatomic) IBOutlet UIButton *buttonAR;
@property (weak, nonatomic) IBOutlet UIButton *btnEN;
@property (weak, nonatomic) IBOutlet UIView *errorHolder;

- (IBAction)arClick:(id)sender;
- (IBAction)enClick:(id)sender;

- (IBAction)btnRefresh:(id)sender;

@end
