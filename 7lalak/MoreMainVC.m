//
//  MoreMainVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MoreMainVC.h"
#import "AddVideoVC.h"

@interface MoreMainVC ()

@end

@implementation MoreMainVC

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
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

- (IBAction)btnAdd:(id)sender {
    
    AddVideoVC *video = [self.storyboard instantiateViewControllerWithIdentifier:@"addVideoView"];
    [self.navigationController pushViewController:video animated:YES];
}
@end
