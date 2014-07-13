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



@interface ItemsViewController ()
@property NSInteger selectedIndex;
@property (nonatomic,strong) NSMutableArray * jsonObject;

@end

@implementation ItemsViewController
@synthesize jsonObject,selectedIndex;
@synthesize catId;





- (void)viewDidLoad
{
    [super viewDidLoad];
    jsonObject = [[NSMutableArray alloc]init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(searchTapped:)];
    _numberOfnewPosts = 3;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ItemViewCell" bundle:nil]forCellReuseIdentifier:@"ItemCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(insertNewObject:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.refreshControl];
    
    
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://ns1.vm1692.sgvps.net/~karasi/sale/api.php?tag=getMoreItemsFromCategory&cat_id=%@&from=%i",catId,0];
    
    [self loadFeeds:strUrl];
    
    
}
-(void)searchTapped:(id)sender{
    
    [self  performSegueWithIdentifier:@"search_seuge" sender:sender];
    NSLog(@"Search..");
}

- (void)insertNewObject:(id)sender
{
    NSLog(@"%d new fetched objects",self.numberOfnewPosts);
    
    [self loadMoreFeed:_numberOfnewPosts];
    
}

- (void)insertObject:(NSMutableArray *)newObject
{
     //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSMutableArray *oldArray = [jsonObject mutableCopy];
    
    NSMutableArray *newArray =[[newObject valueForKey:@"items"]mutableCopy];
    
    [newArray addObjectsFromArray:oldArray];
    
    
    jsonObject = newArray;
    
    
    
    NSLog(@"DataSource:%@",jsonObject);
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
                         
                        // NSLog(@"jsonObject: %@", jsonObject);
                         
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Connection Time Out" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
             }else{
                 [activityIndicator stopAnimating];
                 
                 // status code indicates error, or didn't receive type of data requested
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 NSError* error = [NSError errorWithDomain:@"HTTP Request"
                                                      code:-1000
                                                  userInfo:@{NSLocalizedDescriptionKey: desc}];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self handleError:error];  // execute on main thread!
                     NSLog(@"ERROR: %@", error);
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             // request failed - error contains info about the failure
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self handleError:error]; // execute on main thread!
                 NSLog(@"ERROR: %@", error);
             });
         }
     }];
    
    
    if ([self testInternetConcecction]) {
        //  NSLog(@"Connected");
    }
    
}

-(void)loadMoreFeed:(int )QueryCount{
    
    NSLog(@"loading more ..");
    
    NSString *strUrl = [[NSString alloc]initWithFormat:@"http://ns1.vm1692.sgvps.net/~karasi/sale/api.php?tag=getMoreItemsFromCategory&cat_id=%@&from=%i",@"1",QueryCount];
    
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
                         
                         //NSLog(@"jsonObject: %@", [MorejsonObject valueForKey:@"items"]);
                         
                         if ([MorejsonObject valueForKey:@"items"]!=nil &&
                             [[MorejsonObject valueForKey:@"items"]count] >0) {
                             
                             _numberOfnewPosts+=3;
                             [self insertObject:MorejsonObject];
                         }
                         
                         [self.refreshControl endRefreshing];
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Connection Time Out" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
                 [self.refreshControl endRefreshing];
             }else{
                 
                 // status code indicates error, or didn't receive type of data requested
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 NSError* error = [NSError errorWithDomain:@"HTTP Request"
                                                      code:-1000
                                                  userInfo:@{NSLocalizedDescriptionKey: desc}];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self handleError:error];  // execute on main thread!
                     NSLog(@"ERROR: %@", error);
                     [self.refreshControl endRefreshing];
                 });
             }
         }
         else {
             // request failed - error contains info about the failure
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self handleError:error]; // execute on main thread!
                 NSLog(@"ERROR: %@", error);
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
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Error connecting to the internet" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[someError show];
	}
    return connectedStatus;
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
                   placeholderImage:[UIImage imageNamed:@"ic_defualt_image.png"]];
    
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
