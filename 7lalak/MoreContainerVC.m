//
//  MoreContainerVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MoreContainerVC.h"
#import "UIColor_hex.h"

@interface MoreContainerVC ()

@end

@implementation MoreContainerVC


- (void)viewDidLoad
{
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];

    
    [super viewDidLoad];
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
