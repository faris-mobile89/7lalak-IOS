//
//  PlayListPicker1.m
//  7lalak
//
//  Created by Faris IOS on 7/21/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "PlayListPicker1.h"
#import "FSPlayerVC.h"
#import "UIColor_hex.h"
#import "LocalizeHelper.h"
#import "PlayList.h"

@interface PlayListPicker1 ()
@property (strong,nonatomic) id arrData;
@end

UINavigationBar *bar;
@implementation PlayListPicker1
@synthesize arrData;

-(void)viewWillAppear:(BOOL)animated{
    
    bar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"004557"]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    bar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBarHidden = NO;
    [self.view addSubview:bar];
    
    
    
}
bool showItems=FALSE;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMedia];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//

-(void)loadMedia{
    
    NSString * urlString =[[NSString alloc]initWithFormat:@"http://7lalek.com/api/media.php?tag=getAlbums&device=IOS"];
    
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
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         
                         if (jsonObject !=nil) {
                            // NSLog(@"jsin%@",jsonObject);
                             
                             arrData = [jsonObject valueForKey:@"items"];
               

                            // NSLog(@"JSON%@",[jsonObject valueForKey:@"items"]);

                             [self.tableView reloadData];
                             
                         }
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 //[self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
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
                 // [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
                 [activityIndicator stopAnimating];
             });
         }
     }];
}

-(void)loadMediaItem :(NSString *)albumID{
    
    NSString * urlString =[[NSString alloc]initWithFormat:@"http://7lalek.com/api/media.php?tag=gatPlayList&albumID=%@&device=IOS",albumID];
    
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
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         
                         if (jsonObject !=nil) {
                             
                             arrData = [jsonObject valueForKey:@"items"];
                             
                             NSMutableArray *ar= arrData;
                             
                             [[PlayList sharedPlayList]setItems:ar];
                             
                          //  NSLog(@"JSON%@",[jsonObject valueForKey:@"items"]);
                             showItems = TRUE;
                             [self.tableView reloadData];
                             
                         }
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 //[self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
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
                 // [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
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
    return [arrData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text= [[arrData objectAtIndex:indexPath.row]valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (showItems) {
        
        [[PlayList sharedPlayList]setPickedIndex:(int)indexPath.row];
        
        showItems = FALSE;
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        return;
    }
    
    [self loadMediaItem:[[arrData objectAtIndex:indexPath.row]valueForKey:@"id"]];
}

-(void)showErrorInterentMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
    
}

-(void)showMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
    
}

-(void)showOffilneMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: nil otherButtonTitles: nil];
    
    [internetError show];
    
}

- (IBAction)cancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}
@end
