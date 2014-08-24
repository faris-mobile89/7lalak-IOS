//
//  SearchVC.h
//  7lalak
//
//  Created by Faris IOS on 7/12/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *keyword;
@property (weak, nonatomic) IBOutlet UITextField *price_from;
@property (weak, nonatomic) IBOutlet UITextField *price_to;
@property (strong ,nonatomic) NSString *parentID;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

- (IBAction)btnSearch:(id)sender;

@end
