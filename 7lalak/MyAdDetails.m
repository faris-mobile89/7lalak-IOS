//
//  MyAdDetails.m
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MyAdDetails.h"
#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface MyAdDetails ()

@end

@implementation MyAdDetails



-(void)viewDidLayoutSubviews{
    
    _description.layer.cornerRadius= 10;
    _description.layer.borderWidth=0.5;
    _description.clipsToBounds = YES;
    _description.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    _labelStatus.layer.cornerRadius =10;
    
    BOOL IS_4S = IS_HEIGHT_4S;
    if (!IS_4S) {
        
        self.holder.frame =CGRectMake(0, 50, 320, 400);
    }
    
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteBtn:(id)sender {
}

- (IBAction)saveBtn:(id)sender {
}
@end
