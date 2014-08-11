//
//  ItemDetailsViewController.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGalleryViewController.h"
@interface ItemDetailsViewController : UIViewController<FGalleryViewControllerDelegate>{
    NSArray *networkCaptions;
    NSArray *networkImages;
    FGalleryViewController *networkGallery;
}

@property (weak, nonatomic) IBOutlet UIView *containterView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabsView;
@property (weak,nonatomic) id jsonObject;
- (IBAction)tabsChanged:(id)sender;

@end
