//
//  MoreMainVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MoreMainVC.h"
#import "AddVideoVC.h"
#import "AddImageVC.h"
#import "FavoriteVC.h"
#import "UserInfoVC.h"
#import "RegisterVC.h"
#import "ContactUsVC.h"
#include "BuyTableVC.h"

@interface MoreMainVC ()

@end
Boolean isRegistered=FALSE;

@implementation MoreMainVC

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
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
        
        isRegistered = TRUE;
    }
    [super viewDidLoad];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
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

-(void)registerView{
    
    NSLog(@"waiting for register");
    
    RegisterVC *userRegister = [self.storyboard instantiateViewControllerWithIdentifier:@"registerVC"];
    [self.navigationController pushViewController: userRegister animated:YES];
}

- (IBAction)btnAdd:(id)sender {
    
    if (!isRegistered) {
        
        UIAlertView *chooser = [[UIAlertView alloc]initWithTitle:nil message:@"Please choose Ads type" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Image",@"Video", nil];
        [chooser show];
        
        
        
    }else{
        [self registerView];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
        
    if (buttonIndex == 1) {
        
        AddImageVC *imageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addImages"];
        [self.navigationController pushViewController:imageVC animated:YES];
        
    }else if (buttonIndex == 2){
        
        AddVideoVC *video = [self.storyboard instantiateViewControllerWithIdentifier:@"addVideoView"];
        [self.navigationController pushViewController:video animated:YES];
    }
    

}

- (IBAction)btnFav:(id)sender {
    
    FavoriteVC *fav = [self.storyboard instantiateViewControllerWithIdentifier:@"FavVC"];
    [self.navigationController pushViewController:fav animated:YES];
}

- (IBAction)btnAccountInfo:(id)sender {
    
    if (isRegistered) {
        UserInfoVC *info = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoVC"];
        [self.navigationController pushViewController:info animated:YES];
    }else{
        [self registerView];
    }
}

- (IBAction)btnBuy:(id)sender {
    
    if (!isRegistered) {
        
        BuyTableVC *buy = [self.storyboard instantiateViewControllerWithIdentifier:@"buyAdsVC"];
        [self.navigationController pushViewController:buy animated:YES];
    }else{
        [self registerView];
    }
}

- (IBAction)btnContact:(id)sender {
    
    ContactUsVC *contactUs = [self.storyboard instantiateViewControllerWithIdentifier:@"contactUsVC"];
    [self.navigationController pushViewController:contactUs animated:YES];
}

- (IBAction)btnAboutUS:(id)sender {
}
@end
