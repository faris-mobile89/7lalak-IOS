//
//  SearchResultsVC.h
//  7lalak
//
//  Created by Faris IOS on 7/12/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSString *mainCatID;
@property (strong ,nonatomic) NSString *subCatID;
@property (strong ,nonatomic) NSString *keyword;
@property (strong ,nonatomic) NSString *priceFrom;
@property (strong ,nonatomic) NSString *priceTo;
@end
