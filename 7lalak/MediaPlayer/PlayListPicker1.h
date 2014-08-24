//
//  PlayListPicker1.h
//  7lalak
//
//  Created by Faris IOS on 7/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListPicker1 : UIViewController<UITableViewDataSource,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *done;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)cancel:(id)sender;

@end
