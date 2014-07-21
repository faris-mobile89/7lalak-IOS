//
//  UserInfoVC.m
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "UserInfoVC.h"
#import "LocalizeHelper.h"
#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface UserInfoVC ()

@end

@implementation UserInfoVC

//

-(void)set4SFrame{
    
    _btnDeactive.frame = CGRectMake(80, 340, 156, 38);
    
}

-(void)viewDidLayoutSubviews{
    //_btnDeactive.layer.cornerRadius =3;
    BOOL IS_4S = IS_HEIGHT_4S;
    if (IS_4S) {
        
        [self set4SFrame];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LocalizedString(@"TITLE_MORE_ACCOUNT_INFO");

    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserInfoData.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"UserInfoData" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSDictionary *userData =[NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"use%@",userData);
    if (userData != nil) {
        _fUserName.text = [userData objectForKey:@"USERNAME"];
         _fPhone.text = [userData objectForKey:@"PHONE"];
        
         //_fAdsVideoCount = [userData objectForKey:@""];
      //  _fAdsImagesCount = [userData objectForKey:@""];
       
    }else{
        NSLog(@"No Registerd User ");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)btnDeactiveAccount:(id)sender {
}
@end
