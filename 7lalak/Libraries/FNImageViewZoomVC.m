//
//  FNImageViewZoomVC.m
//  7lalak
//
//  Created by Faris IOS on 8/6/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "FNImageViewZoomVC.h"
#import "SSUIViewMiniMe.h"
#import "UIImageView+ProgressView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT  [UIScreen mainScreen].bounds.size.height
#define BUTTON_SIZE 10

@interface FNImageViewZoomVC () <SSUIViewMiniMeDelegate>

@end

@implementation FNImageViewZoomVC
{
    SSUIViewMiniMe *ssMiniMeView;
    NSInteger row;
    NSInteger col;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //[self.view setBackgroundColor:[UIColor whiteColor]];
    UIView *tempView = [[UIView alloc]initWithFrame:self.view.frame];
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(0, 0, 310, 460);
   
    [imgView setImageWithURL:_imageURl usingProgressView:nil];
    [imgView setContentMode:UIViewContentModeScaleAspectFill];
    [tempView addSubview:imgView];
    row=0;
    col=0;
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 50, 50, 50)];
    [doneBtn setImage:[UIImage imageNamed:@"close-window.png"] forState:UIControlStateNormal];
    //[doneBtn setBackgroundColor:[UIColor greenColor]];
    [doneBtn addTarget:self
                   action:@selector(aMethod:)
         forControlEvents:UIControlEventTouchUpOutside];
    [doneBtn addTarget:self
                action:@selector(aMethod:)
      forControlEvents:UIControlEventTouchUpInside];
    
    ssMiniMeView = [[SSUIViewMiniMe alloc]initWithView:tempView withRatio:4];
    ssMiniMeView.delegate = self;
    [self.view addSubview:ssMiniMeView];
    [self.view addSubview:doneBtn];
   
}

- (void)aMethod:(UIButton *)sender
{
    NSLog(@"Dismiss");
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)enlargedView:(SSUIViewMiniMe *)enlargedView willBeginDragging:(UIScrollView *)scrollView
{
    //Delegate Example
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
