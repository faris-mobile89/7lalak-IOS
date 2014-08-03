//
//  FavoriteVC.m
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "FavoriteVC.h"
#import "ItemViewCell.h"
#import "UIColor_hex.h"
#import "UIImageView+WebCache.h"
#import "ItemDetailsViewController.h"
#import "LocalizeHelper.h"
#include "UIColor_hex.h"

@interface FavoriteVC (){
    NSInteger selectedIndex;
    NSString *filePath;
}

@end

@implementation FavoriteVC
@synthesize jsonObject;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LocalizedString(@"TITLE_MORE_FAV");
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"004557"]];

    [self.tableView registerNib:[UINib nibWithNibName:@"ItemViewCell" bundle:nil]forCellReuseIdentifier:@"ItemCell"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fav.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fav" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    filePath = path;
    //jsonObject = [[NSMutableArray alloc]init];
    jsonObject = [[NSMutableArray alloc]initWithContentsOfFile:path];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [jsonObject count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ItemViewCell *cell = (ItemViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    
    cell.fImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.fImage.layer.cornerRadius=10;
    cell.fImage.layer.borderWidth=1.5;
    cell.fImage.layer.masksToBounds = YES;
    cell.fImage.clipsToBounds = YES;
    cell.fImage.layer.borderColor=[[UIColor colorWithHexString:@"ba4325"] CGColor];
    
    
    [cell.fImage sd_setImageWithURL:[NSURL URLWithString:
                                     [[jsonObject objectAtIndex:indexPath.row]objectForKey:@"img"]]
                   placeholderImage:[UIImage imageNamed:@"ic_defualt_image.png"]];
    
    if ([[[jsonObject
           objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"1"]) {
        [cell.fType setImage:[UIImage imageNamed:@"ic_new_video-file.png"]];
    }else{
        [cell.fType setImage:[UIImage imageNamed:@"ic_new_image-file.png"]];
    }
    
    [cell.fTitle setText:[[ jsonObject
                           objectAtIndex:indexPath.row]objectForKey:@"description"]];
    
    [cell.fDate setText:[[jsonObject
                          objectAtIndex:indexPath.row]objectForKey:@"created"]];
    
    NSString *price= [[NSString alloc]initWithFormat:@"%@ KWD",[[jsonObject
                                                                 objectAtIndex:indexPath.row]objectForKey:@"price"]];
    [cell.fPrice setText:price];
    
    int status = [[[jsonObject objectAtIndex:indexPath.row]objectForKey:@"status"]intValue];
    
    if (status == 2) {
        [cell.imgSold setImage:[UIImage imageNamed:@"ic_sold_flag.png"]];
    }else
        [cell.imgSold setImage:nil];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    ItemDetailsViewController *detail= [self.storyboard instantiateViewControllerWithIdentifier:@"itemDetailsContainer"];
    detail.jsonObject =[jsonObject  objectAtIndex:selectedIndex];
    [self.navigationController pushViewController:detail animated:YES];
    
    // [self performSegueWithIdentifier:@"itemDetails" sender:self];
    
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    
    [super setEditing:editing animated:animated];
    
    if (editing) {
        //NSLog(@"edit on");
    }else {
      //  NSLog(@"Done");
        NSMutableArray * newArray =jsonObject;
        [newArray writeToFile:filePath atomically:YES];
    }
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        int index = (int)indexPath.row ;
        [jsonObject removeObjectAtIndex:index];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}



#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@""] ){
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
