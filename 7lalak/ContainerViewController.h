//
//  ContainerViewController.h
//  7lalak
//
//  Created by Faris IOS on 6/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) id jsonObject;
@end
