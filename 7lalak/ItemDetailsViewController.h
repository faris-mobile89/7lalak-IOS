//
//  ItemDetailsViewController.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *containterView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabsView;
@property (weak,nonatomic) id jsonObject;
- (IBAction)tabsChanged:(id)sender;

@end
