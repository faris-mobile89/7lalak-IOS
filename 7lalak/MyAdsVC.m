//
//  MyAdsVC.m
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MyAdsVC.h"
#import "ItemViewCell.h"
#import "UIColor_hex.h"
#import "UIImageView+WebCache.h"
#import "LocalizeHelper.h"
#import "MyAdDetails.h"
#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface MyAdsVC ()

@end

@implementation MyAdsVC
NSInteger selectedIndex;
@synthesize jsonObject;

-(void)viewDidLayoutSubviews{
    
    BOOL IS_4S = IS_HEIGHT_4S;
    if (IS_4S) {

        self.myTable.frame =CGRectMake(0, 0, 320, 390);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LocalizedString(@"TITLE_MORE_MY_Ads");
    [self.myTable registerNib:[UINib nibWithNibName:@"ItemViewCell" bundle:nil]forCellReuseIdentifier:@"ItemCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;//[jsonObject count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItemViewCell *cell = (ItemViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    
    cell.fImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.fImage.layer.cornerRadius=10;
    cell.fImage.layer.borderWidth=2.0;
    cell.fImage.layer.masksToBounds = YES;
    cell.fImage.clipsToBounds = YES;
    cell.fImage.layer.borderColor=[[UIColor colorWithHexString:@"ba4325"] CGColor];
    
    /*
    [cell.fImage sd_setImageWithURL:[NSURL URLWithString:
                                     [[jsonObject objectAtIndex:indexPath.row]objectForKey:@"img"]]
                   placeholderImage:[UIImage imageNamed:@"ic_defualt_image.png"]];
    
    if ([[[jsonObject
           objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"1"]) {
        [cell.fType setImage:[UIImage imageNamed:@"ic_video_ads.png"]];
    }
    
    [cell.fTitle setText:[[ jsonObject
                           objectAtIndex:indexPath.row]objectForKey:@"description"]];
    
    [cell.fDate setText:[[jsonObject
                          objectAtIndex:indexPath.row]objectForKey:@"created"]];
    
    NSString *price= [[NSString alloc]initWithFormat:@"%@ KWD",[[jsonObject
                                                                 objectAtIndex:indexPath.row]objectForKey:@"price"]];
    [cell.fPrice setText:price];
    
    int status = [[[jsonObject objectAtIndex:indexPath.row]objectForKey:@"status"]integerValue];
    
    if (status == 2) {
        [cell.imgSold setImage:[UIImage imageNamed:@"ic_sold_flag.png"]];
    }
     */
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    
    MyAdDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAdsDetailsVC"];
    [self.navigationController pushViewController: details animated:YES];
}
#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@""] ){
    }
}

@end
