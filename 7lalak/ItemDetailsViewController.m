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
     [_tabsView setTitle:LocalizedString(@"DETAILS") forSegmentAtIndex:0];
    
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
    [_tabsView setTitle:LocalizedString(@"DETAILS") forSegmentAtIndex:0];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:LocalizedString(@"BACK") style:UIBarButtonItemStyleBordered target:nil action:nil];
    
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
    
    NSInt

            
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
