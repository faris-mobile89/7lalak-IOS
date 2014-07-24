//
//  MyAdsVC.h
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) id jsonObject;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (strong ,nonatomic) NSString * userID;
@property (strong ,nonatomic) NSString * apiKey;


@end
