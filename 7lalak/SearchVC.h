//
//  SearchVC.h
//  7lalak
//
//  Created by Faris IOS on 7/12/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVC : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *main_cat;
@property (weak, nonatomic) IBOutlet UITextField *keyword;
@property (weak, nonatomic) IBOutlet UITextField *price_from;
@property (weak, nonatomic) IBOutlet UITextField *price_to;

- (IBAction)btnSearch:(id)sender;

@end
