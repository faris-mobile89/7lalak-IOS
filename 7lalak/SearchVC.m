//
//  SearchVC.m
//  7lalak
//
//  Created by Faris IOS on 7/12/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "SearchVC.h"
#import "SearchResultsVC.h"
#import "LocalizeHelper.h"
#include "UIColor_hex.h"

@interface SearchVC ()
@property NSDictionary *jsonObject;
@property NSDictionary *subCat;
@property NSString *catId;
@property NSString *selectedMaincatId;
@property NSString *selectedSubcatId;
@end

@implementation SearchVC

@synthesize jsonObject,catId,subCat;



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title =LocalizedString(@"SEARCH");
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"FFFFFF"]];
    jsonObject =[[NSDictionary alloc]init];
    subCat = [[NSDictionary alloc]init];
    catId =[[NSString alloc]init];
    _selectedMaincatId  = [[NSString alloc]init];
    _selectedSubcatId   = [[NSString alloc]init];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    
    _price_to.inputAccessoryView = numberToolbar;
    _price_from.inputAccessoryView = numberToolbar;
    
    _price_to.delegate=self;
    _price_from.delegate=self;
    _keyword.delegate=self;
    
    
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_keyword resignFirstResponder];
    
    return YES;
}
-(void)doneButton:(id)sender{
    
    [_price_from resignFirstResponder];
    [_price_to resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _price_from || textField == _price_to) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else if(textField == _keyword ){
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 45) ? NO : YES;
    }
    else return YES;
}



-(void)showErrorInterentMessage:(NSString *)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"NETWORK_ERROR") message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchResult_segue"]) {
        SearchResultsVC *result = segue.destinationViewController;
        result.catID = _parentID;
        result.priceFrom = _price_from.text;
        result.priceTo = _price_to.text;
        result.keyword = _keyword.text;
    }
}


- (IBAction)btnSearch:(id)sender {
    
    if (_price_from.text ==nil ) {
        _price_from.text=@"";
    }
    if (_price_to.text == nil) {
        _price_to.text=@"";
    }
    if ([_keyword.text  length] > 0) {
        [self performSegueWithIdentifier:@"searchResult_segue" sender:sender];
    }
    else{
        
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: nil
                                                            message: @"Please enter keyword to search!"
                                                           delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [someError show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
