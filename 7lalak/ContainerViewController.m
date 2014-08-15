//
//  ContainerViewController.m
//  7lalak
//
//  Created by Faris IOS on 6/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "ContainerViewController.h"
#import "SubCatVC.h"
#import "Home1ViewCell.h"
#import <UIKit/UIColor.h>
#import "UIColor_Hex.h"
#import "InternetConnection.h"
#import "HUD.h"
#import "JSONLoader.h"
#import "Connection.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "HomePageVC.h"
#import "LocalizeHelper.h"
#import "Localization.h"
#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f


@interface ContainerViewController ()
@property NSInteger selectedIndex;
@end

@implementation ContainerViewController
@synthesize jsonObject,selectedIndex;

NSString*lang;

UIImageView *bannerView;


-(void)viewDidLayoutSubviews{
    
    _tableView.frame = CGRectMake(0,0,_tableView.frame.size.width, _tableView.frame.size.height-54);
    bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0,_tableView.frame.size.height, 320, 54)];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if (jsonObject ==nil) {
        [self loadTableData];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:LocalizedString(@"HOME_TITLE")
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(home:)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [UIView new] ;
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"Home1ViewCell" bundle:nil]forCellReuseIdentifier:@"HomeCell"];
    lang = [[NSString alloc]init];
    lang = [[Localization sharedInstance]getPreferredLanguage];
    
}
-(void)loadTableData{
    
    NSString *feedsURl= [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getMainCategories.php?tag=getMainCat&device=IOS&lang=%@",lang];
    NSURL* url = [NSURL URLWithString:feedsURl];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
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
                         [self.tableView reloadData];
                         
                        // NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);
                         [self loadBanner];
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
             }else{
                 [activityIndicator stopAnimating];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"ERROR: %@", error);
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 // NSLog(@"ERROR: %@", error);
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
                 [activityIndicator stopAnimating];
             });
         }
     }];

}
-(void)showErrorInterentMessage:(NSString *)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"NETWORK_ERROR") message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}

-(void)home:(id)sender{
    
    UIViewController *home = [self.storyboard instantiateViewControllerWithIdentifier:@"navi"];
    
    [self presentViewController:home animated:YES completion:nil];
}

-(void)loadBanner{
    
    NSURL* url = [NSURL URLWithString:@"http://7lalek.com/api/getBanner.php?device=IOS&cat=main"];
    
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
                             
                            // NSLog(@"%@",[jsonBanner objectForKey:@"url"]);

                             [self.view addSubview:bannerView];
                             [bannerView sd_setImageWithURL:[NSURL URLWithString:[jsonBanner objectForKey:@"url"]]];
                             
                         }
                     });
                 }
             }
             
       
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
    
    return [[jsonObject objectForKey:@"MainCat"]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Home1ViewCell *cell = (Home1ViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    
    cell.fImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.fImage.layer.cornerRadius=41;
    cell.fImage.layer.borderWidth=2.0;
    cell.fImage.layer.masksToBounds = YES;
    cell.fImage.clipsToBounds = YES;
    cell.fImage.layer.borderColor=[[UIColor colorWithHexString:@"ba4325"] CGColor];
    
    [cell.fImage sd_setImageWithURL:[NSURL URLWithString:
                                  [[[jsonObject objectForKey:@"MainCat"] objectAtIndex:indexPath.row]objectForKey:@"image"]]
                   placeholderImage:[UIImage imageNamed:@"Icon-60.png"]];
    [cell.fLabel setText:
    [[[jsonObject objectForKey:@"MainCat"]
      objectAtIndex:indexPath.row]objectForKey:@"name"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"table" sender:self];
}


#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
 if ([[segue identifier] isEqualToString:@"table"] ){
     
    SubCatVC *tableVC = [segue destinationViewController];
    tableVC.catId =[[[jsonObject objectForKey:@"MainCat"] objectAtIndex:selectedIndex]objectForKey:@"id"];
 }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
