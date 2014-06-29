//
//  UserInfoVC.m
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "UserInfoVC.h"

@interface UserInfoVC ()

@end

@implementation UserInfoVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    NSArray *userData = [[NSArray alloc]initWithContentsOfFile:path];
    
    if ([userData count]>0) {
         _fUserName = [userData objectAtIndex:0];
         _fPhone = [userData objectAtIndex:1];
         _fAdsVideoCount = [userData objectAtIndex:2];
         _fAdsImagesCount = [userData objectAtIndex:3];
       
    }else{
        NSLog(@"No Registerd User ");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
