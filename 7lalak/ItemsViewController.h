//
//  ItemsViewController.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

@interface ItemsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *catId;
@property (nonatomic) int numberOfnewPosts;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;
@end

