//
//  ItemDetailsViewController.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "ItemDetailsViewController.h"
#import "TabImagesVC.h"
#import "TabVideoVC.h"
#import "TabDescriptionVC.h"

@interface ItemDetailsViewController ()

@end
TabImagesVC *tabImage;
TabVideoVC *tabVideo;
TabDescriptionVC *tabDescription;

@implementation ItemDetailsViewController
@synthesize jsonObject;


- (void)viewDidLoad
{
    NSLog(@"JSONObject%@",jsonObject);
    tabImage = [self.storyboard instantiateViewControllerWithIdentifier:@"ImagesContainer"];
    tabVideo = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoContainer"];
    tabDescription = [self.storyboard instantiateViewControllerWithIdentifier:@"DescriptionContainer"];
    
    tabDescription.jsonObject=jsonObject;
    tabImage.jsonObject=jsonObject;
    tabVideo.jsonObject=jsonObject;
    
    [tabDescription willMoveToParentViewController:self];
    [self.containterView addSubview:tabDescription.view];
    [self addChildViewController:tabDescription];
    [tabDescription didMoveToParentViewController:self];
    [super viewDidLoad];
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

- (IBAction)tabsChanged:(id)sender {
    [[self.containterView subviews ]makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSInteger index = [self.tabsView selectedSegmentIndex];
    if (index==1) {
        //item.view.frame= self.containterView.bounds;
        tabImage.var=@"hii";
        [tabImage willMoveToParentViewController:self];
        [self.containterView addSubview:tabImage.view];
        [self addChildViewController:tabImage];
        [tabImage didMoveToParentViewController:self];
        
    }else{
        
        /*
        [tabDescription willMoveToParentViewController:self];
        [self.containterView addSubview:tabDescription.view];
        [self addChildViewController:tabDescription];
        [tabDescription didMoveToParentViewController:self];
        [super viewDidLoad];
        */
        
        [tabVideo willMoveToParentViewController:self];
        [self.containterView addSubview:tabVideo.view];
        [self addChildViewController:tabVideo];
        [tabVideo didMoveToParentViewController:self];
        
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
