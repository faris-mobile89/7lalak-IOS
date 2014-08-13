//
//  TabBarViewController.m
//  7lalak
//
//  Created by Faris IOS on 8/13/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabBarViewController.h"
#import "LocalizeHelper.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ya hla bl tab");
    
    // Assign tab bar item with titles
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];

    [tabBarItem1 setTitle:LocalizedString(@"TAB_OFFERS")];
    [tabBarItem2 setTitle:LocalizedString(@"TAB_SECTIONS")];
    [tabBarItem3 setTitle:LocalizedString(@"TAB_MEDIA")];
    [tabBarItem4 setTitle:LocalizedString(@"TAB_MORE")];
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

@end
