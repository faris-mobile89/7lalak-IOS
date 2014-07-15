//
//  HomePageVC.m
//  7lalak
//
//  Created by Faris IOS on 7/2/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "HomePageVC.h"
#import "LocalizeHelper.h"
#import "FirstViewController.h"

@interface HomePageVC ()

@end

@implementation HomePageVC
/*
-(id)init{
    
    NSString *tempValue =@"ar";
    
    NSString *currentLanguage = @"en";
    
    if ([tempValue rangeOfString:NSLocalizedString(@"English", nil)].location != NSNotFound) {
        currentLanguage = @"en";
    } else if ([tempValue rangeOfString:NSLocalizedString(@"Arabic", nil)].location != NSNotFound) {
        currentLanguage = @"ar";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return nil;
}
 */
-(BOOL)prefersStatusBarHidden{
    
    return YES;
}
- (void)viewDidLoad
{
    
    /*
    [_fImageTopAds setImage:
     [UIImage imageWithData:[NSData dataWithContentsOfURL:
                             [NSURL URLWithString:@"http://"]]]];
     
     */
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.title=@"7lalek Home Page";
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
