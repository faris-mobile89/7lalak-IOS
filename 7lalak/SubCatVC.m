//
//  TableViewController.m
//  7lalak
//
//  Created by Faris IOS on 6/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "SubCatVC.h"
#import "Home1ViewCell.h"
#import "ItemsViewController.h"
#import <UIKit/UIColor.h>
#import "UIColor_Hex.h"
#import "InternetConnection.h"
#import "HUD.h"
#import "JSONLoader.h"
#import "Connection.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "LocalizeHelper.h"
#import "Localization.h"

#define IS_HEIGHT_iPad [[UIScreen mainScreen ] bounds].size.height > 700.0f

 
@interface SubCatVC (){
    NSString *lang;
    BOOL iS_iPad;
}
@property NSInteger selectedIndex;
@property (nonatomic,copy) id jsonObject;
@end

@implementation SubCatVC
@synthesize jsonObject,selectedIndex;
@synthesize catId;


UIImageView *bannerView;

-(void)viewDidLayoutSubviews{
    
    iS_iPad = IS_HEIGHT_iPad;
    
    if (iS_iPad) {
        _tableView.frame = CGRectMake(0,0,_tableView.frame.size.width, _tableView.frame.size.height-108);
        bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0,_tableView.frame.size.height, 768, 108)];
        
    }else{
        _tableView.frame = CGRectMake(0,0,_tableView.frame.size.width, _tableView.frame.size.height-54);
        bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0,_tableView.frame.size.height, 320, 54)];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:LocalizedString(@"BACK") style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iS_iPad = IS_HEIGHT_iPad;
    lang = [[NSString alloc]init];
    lang = [[Localization sharedInstance]getPreferredLanguage];
    NSString *path = [[NSBundle mainBundle]pathForResource:lang ofType:@"lproj"];
    NSBundle *langBundle = [NSBundle bundleWithPath:path];
    
    if (iS_iPad) {
        
        [self.tableView registerNib:[UINib nibWithNibName:@"Home1ViewCell_iPad" bundle:langBundle]forCellReuseIdentifier:@"HomeCell"];
    }else{
        
        [self.tableView registerNib:[UINib nibWithNibName:@"Home1ViewCell" bundle:langBundle]forCellReuseIdentifier:@"HomeCell"];
    }
    
    
    [self.tableView setBackgroundColor: [UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];

    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getSubCategories.php?tag=getSubCat&mainId=%@&lang=%@",catId,[[Localization sharedInstance]getPreferredLanguage]];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-30);
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
                         // self.model = jsonObject;
                         [activityIndicator stopAnimating];
                         [self.tableView reloadData];
                         [self loadBanner];
                       //  NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"SubCat"]);
                         
                         
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
                 UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: @"Network Error" message:@"The Internet connection appears to be offline" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 
                 [internetError show];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
    
    if ([self testInternetConcecction]) {
      //  NSLog(@"Connected");
    }
    
}


-(void)loadBanner{
    
    NSString *uRlString= [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getBanner.php?device=IOS&cat=mainCat&cat_id=%@",catId ];
    
    NSURL* url = [NSURL URLWithString:uRlString];
    
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
                            //   NSLog(@"%@",[jsonBanner objectForKey:@"url"]);
                             
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
    
    return [[jsonObject objectForKey:@"SubCat"]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Home1ViewCell *cell = (Home1ViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    
    cell.fImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.fImage.layer.cornerRadius=41;
    cell.fImage.layer.borderWidth=1.5;
    cell.fImage.layer.masksToBounds = YES;
    cell.fImage.clipsToBounds = YES;
    cell.fImage.layer.borderColor=[[UIColor colorWithHexString:@"ba4325"] CGColor];
    
    
    
    [cell.fImage sd_setImageWithURL:[NSURL URLWithString:
                                  [[[jsonObject objectForKey:@"SubCat"] objectAtIndex:indexPath.row]objectForKey:@"image"]]
                placeholderImage:[UIImage imageNamed:@"Icon-60.png"]];
    [cell.fLabel setText:
     [[[jsonObject objectForKey:@"SubCat"]
       objectAtIndex:indexPath.row]objectForKey:@"name"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (iS_iPad) {
        return 150;
    }
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"itemsDetails" sender:self];
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"itemsDetails"] ){
        
        ItemsViewController *tableVC = [segue destinationViewController];
        NSString *param = [[NSString alloc]initWithFormat:@"%@%@",
         catId,[[[jsonObject objectForKey:@"SubCat"] objectAtIndex:selectedIndex]objectForKey:@"id"] ];
        tableVC.subCatId = [[[jsonObject objectForKey:@"SubCat"] objectAtIndex:selectedIndex]objectForKey:@"id"];
        tableVC.catId = param;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
