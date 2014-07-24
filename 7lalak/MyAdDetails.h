//
//  MyAdDetails.h
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdDetails : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UISegmentedControl *availability;
@property (weak, nonatomic) IBOutlet UISegmentedControl *visiability;
@property (weak, nonatomic) IBOutlet UILabel *labelStatus;
@property (weak, nonatomic) IBOutlet UIView *holder;
@property (strong ,nonatomic) NSString * paramDescription;

@property (strong ,nonatomic) NSString * paramPrice;
@property (strong ,nonatomic) NSString * paramAvailabilityCode;
@property (strong ,nonatomic) NSString * paramvisiabilityCode;

@property  (nonatomic) NSInteger paramAdId;


- (IBAction)deleteBtn:(id)sender;
- (IBAction)saveBtn:(id)sender;

@end
