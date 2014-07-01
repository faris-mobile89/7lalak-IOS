//
//  ItemsViewController.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *catId;
@property (nonatomic) int numberOfnewPosts;
@property (nonatomic) UIRefreshControl *refreshControl;
@end
