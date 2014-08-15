//
//  SearchResultsVC.m
//  7lalak
//
//  Created by Faris IOS on 7/12/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "SearchResultsVC.h"
#import "ItemViewCell.h"
#import "ItemDetailsViewController.h"
#import <UIKit/UIColor.h>
#import "UIColor_Hex.h"
#import "InternetConnection.h"
#import "Connection.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalizeHelper.h"

@interface SearchResultsVC ()
@property NSInteger selectedIndex;
@property (nonatomic,strong) NSMutableArray * jsonObject;

@end

@implementation SearchResultsVC
@synthesize jsonObject,selectedIndex;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView registerNib:[UINib nibWithNibName:@"ItemViewCell" bundle:nil]forCellReuseIdentifier:@"ItemCell"];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];

    

    [self loadSearchData];
    
}

-(void)loadSearchData{
    
    NSString *strUrl = [[NSString alloc]
                        initWithFormat:@"http://7lalek.com/api/search-items.php?tag=search&keyword=%@&catID=%@&priceFrom=%@&priceTo=%@",_keyword,_catID,_priceFrom,_priceTo];
    
    NSString *encodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSURL *searchURL = [NSURL URLWithString:encodeURL];
    
      NSLog(@"URL:%@",searchURL);
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:searchURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         
         if (data) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             
             if (httpResponse.statusCode == 200 /* OK */) {
                 NSError* error;
                 
                 jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         NSLog(@"response%@",jsonObject);
                    if (jsonObject !=nil){
                             
                        if ([[jsonObject valueForKey:@"error"]intValue]==1) {
                            
                            UIAlertView *someError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"SEARCH_RESULT")
                                                                                message: LocalizedString(@"ERROR_NO_RESULT")
                                                                               delegate: self cancelButtonTitle:
                                                      LocalizedString(@"DONE") otherButtonTitles: nil];
                            [someError show];
                         }else if([[jsonObject valueForKey:@"error"]intValue]==0){
                             
                             jsonObject = [jsonObject valueForKey:@"items"];
                             [_tableView reloadData];
                          }
                         }
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
             }else{
                 [activityIndicator stopAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
             });
         }
     }];
    

    
}

-(void)showErrorInterentMessage:(NSString *)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"NETWORK_ERROR") message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([jsonObject count] > 0 && jsonObject !=nil)
        return [jsonObject count];
    
    else
        return 0;
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
    
    
    
    [cell.fImage sd_setImageWithURL:[NSURL URLWithString:
                                     [[jsonObject objectAtIndex:indexPath.row]objectForKey:@"img"]]
                   placeholderImage:[UIImage imageNamed:@"Icon-60.png"]];
    
    if ([[[jsonObject
           objectAtIndex:indexPath.row]objectForKey:@"type"]isEqualToString:@"1"]) {
        [cell.fType setImage:[UIImage imageNamed:@"ic_video_ads.png"]];
    }
    
    [cell.fTitle setText:
     [[jsonObject
       objectAtIndex:indexPath.row]objectForKey:@"description"]];
    
    [cell.fDate setText:[[jsonObject
                          objectAtIndex:indexPath.row]objectForKey:@"created"]];
    
    [cell.fPrice setText:[[jsonObject
                           objectAtIndex:indexPath.row]objectForKey:@"price"]];
    
    int status = [[[jsonObject objectAtIndex:indexPath.row]objectForKey:@"status"]intValue];
    
    if (status == 2) {
        [cell.imgSold setImage:[UIImage imageNamed:@"ic_sold_flag.png"]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"itemDetails" sender:self];
    
    
}


#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"itemDetails"] ){
        
        ItemDetailsViewController *itemDetailsVC = [segue destinationViewController];
        itemDetailsVC.jsonObject =[jsonObject objectAtIndex:selectedIndex];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end

