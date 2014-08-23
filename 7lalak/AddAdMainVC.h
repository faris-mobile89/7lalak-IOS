//
//  AddAdMainVC.h
//  7lalak
//
//  Created by Faris IOS on 8/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAdMainVC : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *addImage;
@property (weak, nonatomic) IBOutlet UIButton *addVideo;


- (IBAction)addimageClick:(id)sender;
- (IBAction)addVideoClick:(id)sender;

@end
