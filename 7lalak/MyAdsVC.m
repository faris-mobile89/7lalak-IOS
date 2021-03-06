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
#import "MyAdVideoDetails.h"
#import "Localization.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f
#define IS_HEIGHT_iPad [[UIScreen mainScreen ] bounds].size.height > 700.0f

@interface MyAdsVC (){

    NSString *lang;
    BOOL iS_iPad;

}
@property id jData;
@end

@implementation MyAdsVC
NSInteger selectedIndex;
@synthesize jsonObject;
@synthesize jData;

-(void)viewDidLayoutSubviews{
    
    BOOL IS_4S = IS_HEIGHT_4S;
    if (IS_4S) {
        self.myTable.frame =CGRectMake(0, 0, 320, 388);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    iS_iPad = IS_HEIGHT_iPad;
    self.title = LocalizedString(@"TITLE_MORE_MY_Ads");
    
    lang = [[NSString alloc]init];
    lang = [[Localization sharedInstance]getPreferredLanguage];
    NSString *path = [[NSBundle mainBundle]pathForResource:lang ofType:@"lproj"];
    NSBundle *langBundle = [NSBundle bundleWithPath:path];
    
    if (iS_iPad) {
        [self.myTable registerNib:[UINib nibWithNibName:@"ItemViewCell_iPad" bundle:langBundle]forCellReuseIdentifier:@"ItemCell"];
    }else{
        [self.myTable registerNib:[UINib nibWithNibName:@"ItemViewCell" bundle:langBundle]forCellReuseIdentifier:@"ItemCell"];
    }
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self getUserAds];
}


#pragma mark getUserAds

-(void)getUserAds{
    
    NSString * urlString =[[NSString alloc]initWithFormat:@"http://7lalek.com/api/api.php?tag=getUserAds&user_id=%@&UDID=%@&device=IOS",_userID,_apiKey ];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
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
                         
                         
                         if ([[jsonObject valueForKey:@"error"]intValue]==0) {
                             jData = [jsonObject objectForKey:@"userAds"];
                            // NSLog(@"jdata%@",jData);
                             [self.myTable reloadData];
                             [activityIndicator stopAnimating];
                         }
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
                 [activityIndicator stopAnimating];

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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jData count];
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
    
    
    [cell.fImage sd_setImageWithURL:[NSURL URLWithString:[[jData objectAtIndex:indexPath.row]valueForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"Icon-60.png"]];
    
    if ([[[jData objectAtIndex:indexPath.row]valueForKey:@"type"]isEqualToString:@"1"]) {
        [cell.fType setImage:[UIImage imageNamed:@"ic_new_video-file.png"]];
    }
    
    [cell.fTitle setText:[[jData objectAtIndex:indexPath.row]valueForKey:@"description"]];
    
    [cell.fDate setText:[[jData objectAtIndex:indexPath.row]valueForKey:@"created"]];
    
    NSString *price= [[NSString alloc]initWithFormat:@"%@ %@",[[jData objectAtIndex:indexPath.row]valueForKey:@"price"],LocalizedString(@"KWD")];
    
    [cell.fPrice setText:price];
    
    int status = [[[jData objectAtIndex:indexPath.row]valueForKey:@"status"]intValue];
    if (status == 2) {
        if ([lang isEqualToString:@"ar"]) {
            [cell.imgSold setImage:[UIImage imageNamed:@"ic_sold_flag_ar.png"]];
        }else{
            [cell.imgSold setImage:[UIImage imageNamed:@"ic_sold_flag.png"]];
        }
    }else [cell.imgSold setImage:nil];
    
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
    
 if ([[[jData objectAtIndex:indexPath.row]valueForKey:@"type"]isEqualToString:@"2"]) {
     
    MyAdDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAdsDetailsVC"];
    details.paramDescription = [[jData objectAtIndex:selectedIndex]valueForKey:@"description"];
    details.paramPrice =  [[jData objectAtIndex:selectedIndex]valueForKey:@"price"];
    details.paramAvailabilityCode = [[jData objectAtIndex:selectedIndex]valueForKey:@"status"];
    details.paramAdId = [[jData objectAtIndex:selectedIndex]valueForKey:@"id"];
    details.paramMid = [[jData objectAtIndex:selectedIndex]valueForKey:@"mid"];
    details.paramSid = [[jData objectAtIndex:selectedIndex]valueForKey:@"sid"];
    details.paramStatus = [[jData objectAtIndex:selectedIndex]valueForKey:@"status"];
    details.userID = _userID;
    details.apiKey = _apiKey;
    details.jsonImages = [[jData objectAtIndex:selectedIndex]valueForKey:@"imgs"];
    details.catName =[[jData objectAtIndex:selectedIndex]valueForKey:@"cat_name"];
    [self.navigationController pushViewController: details animated:YES];
     
 }else if ([[[jData objectAtIndex:indexPath.row]valueForKey:@"type"]isEqualToString:@"1"]){
     
     MyAdVideoDetails *details = [self.storyboard instantiateViewControllerWithIdentifier:@"MyAdsVideoDetailsVC"];
     details.paramDescription = [[jData objectAtIndex:selectedIndex]valueForKey:@"description"];
     details.paramPrice =  [[jData objectAtIndex:selectedIndex]valueForKey:@"price"];
     details.paramAvailabilityCode = [[jData objectAtIndex:selectedIndex]valueForKey:@"status"];
     details.paramAdId = [[jData objectAtIndex:selectedIndex]valueForKey:@"id"];
     details.paramMid = [[jData objectAtIndex:selectedIndex]valueForKey:@"mid"];
     details.paramSid = [[jData objectAtIndex:selectedIndex]valueForKey:@"sid"];
     details.paramStatus = [[jData objectAtIndex:selectedIndex]valueForKey:@"status"];
     details.userID = _userID;
     details.apiKey = _apiKey;
     details.catName =[[jData objectAtIndex:selectedIndex]valueForKey:@"cat_name"];
     if ([[[jData objectAtIndex:selectedIndex]valueForKey:@"vids"]count]) {
         details.isUploadVideo = true;
         details.videoURL = [[[jData objectAtIndex:selectedIndex]valueForKey:@"vids"]objectAtIndex:0];
        // NSLog(@"fe video");
     }else{
         details.isUploadVideo = false;
        // NSLog(@"No video ");
     }
     
     [self.navigationController pushViewController: details animated:YES];
 }
  
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@""] ){
    }
}

-(void)showErrorInterentMessage:(NSString *)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"NETWORK_ERROR") message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
