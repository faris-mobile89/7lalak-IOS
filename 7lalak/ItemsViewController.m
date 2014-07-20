//
//  ItemsViewController.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "ItemsViewController.h"
#import "ItemViewCell.h"
#import "ItemDetailsViewController.h"
#import <UIKit/UIColor.h>
#import "UIColor_Hex.h"
#import "InternetConnection.h"
#import "HUD.h"
#import "JSONLoader.h"
#import "Connection.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalizeHelper.h"


@interface ItemsViewController ()
@property NSInteger selectedIndex;
@property (nonatomic,strong) NSMutableArray * jsonObject;

@end

@implementation ItemsViewController
@synthesize jsonObject,selectedIndex;
@synthesize catId;
@synthesize soundFileURLRef;
@synthesize soundFileObject;

UIImageView *bannerView;

-(void)viewDidLayoutSubviews{
    
    _tableView.frame = CGRectMake(0,0,_tableView.frame.size.width, _tableView.frame.size.height-44);
    bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0,_tableView.frame.size.height, 320, 48)];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    jsonObject = [[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LocalizedString(@"SEARCH")
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(searchTapped:)];
    _numberOfnewPosts = 3;
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemViewCell" bundle:nil]forCellReuseIdentifier:@"ItemCell"];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
    UITableViewController *tableViewController = [[UITableViewController alloc]init];
    tableViewController.tableView = self.tableView;
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl=self.refreshControl;
    
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://185.56.85.28/~c7lalek4/api/api.php?tag=getMoreItemsFromCategory&cat_id=%@&from=%i&lang=%@",catId,0,@"en"];
    
    [self loadFeeds:strUrl];
    
    
}
-(void)loadBanner{
    
    NSURL* url = [NSURL URLWithString:@"http://185.56.85.28/~c7lalek4/api/getBanner.php?device=ios&cat=main"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
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
                 
                 id jsonBanner = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonBanner) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if ([jsonBanner objectForKey:@"url"]!=nil) {
                             
                             [self.view addSubview:bannerView];
                             [bannerView sd_setImageWithURL:[NSURL URLWithString:[jsonBanner objectForKey:@"url"]]];
                             
                         }
                     });
                 }
             }
             
             
         }
     }];
    
    
}

-(void)searchTapped:(id)sender{
    
    [self  performSegueWithIdentifier:@"search_seuge" sender:sender];
}

- (void)insertNewObject:(id)sender
{
    [self playTick];
    [self loadMoreFeed:_numberOfnewPosts];
    
}
-(void)playTick{
    
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
                                                withExtension: @"aif"];
    
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (__bridge CFURLRef) tapSound ;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    NSLog(@"%d new fetched objects",self.numberOfnewPosts);
    
    AudioServicesPlaySystemSound (soundFileObject);
}

- (void)insertObject:(NSMutableArray *)newObject
{
    NSMutableArray *oldArray = [jsonObject mutableCopy];
    
    NSMutableArray *newArray =[[newObject valueForKey:@"items"]mutableCopy];
    
    [newArray addObjectsFromArray:oldArray];
    
    jsonObject = newArray;
    [self.tableView reloadData];
}

-(void)loadFeeds:(NSString *)urlString{
    
    
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
                 
                 NSMutableArray  *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (json) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [activityIndicator stopAnimating];
                         jsonObject = [json valueForKey:@"items"];
                         
                         [self.tableView reloadData];
                         [self loadBanner];
                        // NSLog(@"jsonObject: %@", jsonObject);
                         
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                       //  NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
             }else{
                 [activityIndicator stopAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                  //   NSLog(@"ERROR: %@", error);
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
               //  NSLog(@"ERROR: %@", error);
             });
         }
     }];
    
}

-(void)loadMoreFeed:(int )QueryCount{
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://185.56.85.28/~c7lalek4/api/api.php?tag=getMoreItemsFromCategory&cat_id=%@&from=%i&device=IOS&lang=%@",catId,QueryCount,@"ar"];
    
    NSURL* url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    
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
                 
                 NSMutableArray  * MorejsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (MorejsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if (jsonObject !=nil)
                         if ([MorejsonObject valueForKey:@"items"]!=nil &&
                             [[MorejsonObject valueForKey:@"items"]count] >0) {
                             
                             _numberOfnewPosts+=10;
                             [self insertObject:MorejsonObject];
                         }
                         
                         [self.refreshControl endRefreshing];
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                     });
                 }
             }
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
                 [self.refreshControl endRefreshing];
             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self.refreshControl endRefreshing];
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.refreshControl endRefreshing];
             });
         }
     }];
    
    
}

-(Boolean)testInternetConcecction{
    
    Boolean connectedStatus=false;
    
	if ([Connection isConnected]) {
        connectedStatus= TRUE;
	}
	else {
        [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
	}
    return connectedStatus;
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
                   placeholderImage:[UIImage imageNamed:@"img_7lalek.png"]];
    
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
    
    int status = [[[jsonObject objectAtIndex:indexPath.row]objectForKey:@"status"]integerValue];
    
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
