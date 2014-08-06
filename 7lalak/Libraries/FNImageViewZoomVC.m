//
//  FNImageViewZoomVC.m
//  7lalak
//
//  Created by Faris IOS on 8/6/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "FNImageViewZoomVC.h"

@interface FNImageViewZoomVC ()

@end

@implementation FNImageViewZoomVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
                              
        [imageView setImage:[UIImage imageNamed:@"ic_defualt_image.png"]];
    
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
