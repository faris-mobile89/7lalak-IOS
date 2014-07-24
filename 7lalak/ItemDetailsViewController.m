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
#import "LocalizeHelper.h"

@interface ItemDetailsViewController ()

@end
TabImagesVC *tabImage;
TabVideoVC *tabVideo;
TabDescriptionVC *tabDescription;

@implementation ItemDetailsViewController
@synthesize jsonObject;


- (void)viewDidLoad
{
    //NSLog(@"JSONObject%@",jsonObject);
    [super viewDidLoad];

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
    
   
    if ([[jsonObject objectForKey:@"type"]isEqualToString:@"1"]) {
        [_tabsView setTitle:LocalizedString(@"VIDEO") forSegmentAtIndex:1];
    }
    
    
    if ([[jsonObject objectForKey:@"type"]isEqualToString:@"1"]) {
        
  
        if ([[jsonObject objectForKey:@"vids"]count] ==0 ) {
        [_tabsView removeSegmentAtIndex:1 animated:NO];
    }
  }
    
    if ([[jsonObject objectForKey:@"type"]isEqualToString:@"2"]) {
        
        
        if ([[jsonObject objectForKey:@"imgs"]count] ==0 ) {
            [_tabsView removeSegmentAtIndex:1 animated:NO];
        }
    }
    
}


- (IBAction)tabsChanged:(id)sender {
    

    [[self.containterView subviews ]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger index = [self.tabsView selectedSegmentIndex];
    if (index==1) {
        
        if ([[jsonObject objectForKey:@"type"]isEqualToString:@"1"]) {
            
            
            [tabVideo willMoveToParentViewController:self];
            [self.containterView addSubview:tabVideo.view];
            [self addChildViewController:tabVideo];
            [tabVideo didMoveToParentViewController:self];
            [tabVideo setTitle:LocalizedString(@"VIDEO")];
            
        }else{
            
            [tabImage willMoveToParentViewController:self];
            [self.containterView addSubview:tabImage.view];
            [self addChildViewController:tabImage];
            [tabImage didMoveToParentViewController:self];
            [tabImage setTitle:LocalizedString(@"IMAGES")];
        }
        
    }else{
        
        [tabDescription willMoveToParentViewController:self];
        [self.containterView addSubview:tabDescription.view];
        [self addChildViewController:tabDescription];
        [tabDescription didMoveToParentViewController:self];
        [tabDescription setTitle:LocalizedString(@"DESCRIPTION")];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
