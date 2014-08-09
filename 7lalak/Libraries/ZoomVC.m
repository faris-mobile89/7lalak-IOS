//
//  ZoomVC.m
//  7lalak
//
//  Created by Faris IOS on 8/7/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "ZoomVC.h"

@interface ZoomVC ()

@end

@implementation ZoomVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 50, 50, 50)];
    [doneBtn setImage:[UIImage imageNamed:@"close-window.png"] forState:UIControlStateNormal];
    [doneBtn setBackgroundColor:[UIColor greenColor]];
    [doneBtn addTarget:self
                action:@selector(aMethod:)
      forControlEvents:UIControlEventTouchUpOutside];
    [doneBtn addTarget:self
                action:@selector(aMethod:)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)aMethod:(UIButton *)sender
{
    NSLog(@"Dismiss");
    [self dismissViewControllerAnimated:NO completion:nil];
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
