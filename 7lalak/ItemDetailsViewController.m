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
#import "FNImageViewZoomVC.h"
#import "FGalleryViewController.h"

@interface ItemDetailsViewController ()

@end
TabImagesVC *tabImage;
TabVideoVC *tabVideo;
TabDescriptionVC *tabDescription;

@implementation ItemDetailsViewController
@synthesize jsonObject;


-(void)viewDidLayoutSubviews{
    
    
if ([[jsonObject objectForKey:@"type"]isEqualToString:@"2"]){
    
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
        
        
        NSMutableArray *dic =[[NSMutableArray alloc]init];
        
        for (NSInteger i =0 ; i< [[jsonObject objectForKey:@"imgs"]count]; i++) {
            [dic addObject:[[jsonObject objectForKey:@"imgs"]objectAtIndex:i ] ];
        }
        
        networkImages = [dic copy];
        
        
        if ([[jsonObject objectForKey:@"imgs"]count] ==0 ) {
            [_tabsView removeSegmentAtIndex:1 animated:NO];
        }
    }
    
    // increment number of views to current Ad
    
    [self numberOfviews];
}

  
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //NSLog(@"JSONObject%@",jsonObject);
    
    if ([[jsonObject objectForKey:@"type"]isEqualToString:@"1"]){
        
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
            
            
            NSMutableArray *dic =[[NSMutableArray alloc]init];
            
            for (NSInteger i =0 ; i< [[jsonObject objectForKey:@"imgs"]count]; i++) {
                [dic addObject:[[jsonObject objectForKey:@"imgs"]objectAtIndex:i ] ];
            }
            
            networkImages = [dic copy];
            
            
            if ([[jsonObject objectForKey:@"imgs"]count] ==0 ) {
                [_tabsView removeSegmentAtIndex:1 animated:NO];
            }
        }
        
        // increment number of views to current Ad
        
        [self numberOfviews];
    }

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:NO];
    
    if ([[jsonObject objectForKey:@"type"]isEqualToString:@"2"])
       [_tabsView setSelectedSegmentIndex:0];
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
            
            /* OLD DESIGN
            // sub view display
            [tabImage willMoveToParentViewController:self];
            [self.containterView addSubview:tabImage.view];
            [self addChildViewController:tabImage];
            [tabImage didMoveToParentViewController:self];
            [tabImage setTitle:LocalizedString(@"IMAGES")];
             */

            [tabImage setTitle:LocalizedString(@"IMAGES")];

            
            networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
            [self.navigationController pushViewController:networkGallery animated:YES];
        }
    }else{
        
        [tabDescription willMoveToParentViewController:self];
        [self.containterView addSubview:tabDescription.view];
        [self addChildViewController:tabDescription];
        [tabDescription didMoveToParentViewController:self];
        [tabDescription setTitle:LocalizedString(@"DESCRIPTION")];
    }
    
}

#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    if( gallery == networkGallery ) {
        num = (int)[networkImages count];
    }
	return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    
    if( gallery == networkGallery ) {
        caption = @"";
    }
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [networkImages objectAtIndex:index];
}

#pragma statistics traking

-(void)numberOfviews {
    
    NSString *strUl= [[NSString alloc]initWithFormat:@"http://7lalek.com/api/api.php?device=IOS&tag=numberOfViews&Ad_id=%@",[jsonObject objectForKey:@"id"]];
    
    NSURL* url = [NSURL URLWithString:strUl];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         
         if (data) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             
             if (httpResponse.statusCode == 200 /* OK */) {
                 NSError* error;
                 
                 id jsonBanner = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonBanner) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                     });
                 }
             }
             
         }
     }];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
