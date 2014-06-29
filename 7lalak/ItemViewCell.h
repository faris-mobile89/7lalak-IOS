//
//  ItemViewCell.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *fImage;
@property (weak, nonatomic) IBOutlet UILabel *fTitle;
@property (weak, nonatomic) IBOutlet UILabel *fPrice;
@property (weak, nonatomic) IBOutlet UILabel *fDate;
@property (weak, nonatomic) IBOutlet UIImageView *fType;

@end
