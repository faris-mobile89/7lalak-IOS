//
//  ContainerViewController.m
//  7lalak
//
//  Created by Faris IOS on 6/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "ContainerViewController.h"
#import "TableViewController.h"
#import "Home1ViewCell.h"
#import <UIKit/UIColor.h>
#import "UIColor_Hex.h"
#import "InternetConnection.h"
#import "HUD.h"
#import "JSONLoader.h"
#import "Connection.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>



@interface ContainerViewController ()
@property NSInteger selectedIndex;
@end

@implementation ContainerViewController
@synthesize jsonObject,selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [UIView new] ;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"Home1ViewCell" bundle:nil]forCellReuseIdentifier:@"HomeCell"];

   NSURL* url = [NSURL URLWithString:@"http://serv01.vm1692.sgvps.net/~karasi/sale/getMainCategories.php?tag=getMainCat"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];

    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];

    

   // urlRequest.timeoutInterval =70;
    //[urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
   // urlRequest setTimeoutInterval:[nst]
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
    {

        if (data) {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            // check status code and possibly MIME type (which shall start with "application/json"):
           // NSRange range = [response.MIMEType rangeOfString:@"application/json"];

            if (httpResponse.statusCode == 200 /* OK */) {
                NSError* error;
                
                 jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (jsonObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // self.model = jsonObject;
                        [activityIndicator stopAnimating];
                        [self.tableView reloadData];

                       //NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);

                        
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

/*

-(Boolean)testInternetConcecction{
    
   Boolean connectedStatus=FALSE;
   InternetConnection *networkReachability = [InternetConnection reachabilityForInternetConnection];
   NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
   connectedStatus = networkStatus == NotReachable ?FALSE:TRUE;
    
	if (connectedStatus==FALSE) {
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Error connecting to the internet" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[someError show];
        
	}
    return connectedStatus;
    
}
 */



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
                   placeholderImage:[UIImage imageNamed:@"ic_defualt_image.png"]];
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
   // NSLog(@"selectd%i",selectedIndex);
    
    [self performSegueWithIdentifier:@"table" sender:self];


}





#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
 if ([[segue identifier] isEqualToString:@"table"] ){
     
    TableViewController *tableVC = [segue destinationViewController];
     tableVC.catId =[[[jsonObject objectForKey:@"MainCat"] objectAtIndex:selectedIndex]objectForKey:@"id"];
 }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
