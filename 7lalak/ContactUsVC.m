//
//  ContactUsVC.m
//  7lalak
//
//  Created by Faris IOS on 6/29/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "ContactUsVC.h"
#import "UIColor_hex.h"
#import "LocalizeHelper.h"

@interface ContactUsVC ()

@end

@implementation ContactUsVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LocalizedString(@"TITLE_MORE_CONTACT_Us");
    _contactForm.layer.cornerRadius=10;
    _contactForm.layer.borderWidth=0.5;
    _contactForm.clipsToBounds = YES;
    _contactForm.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    
    _contactForm.delegate=self;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}



- (IBAction)btnSend:(id)sender {
    
    if ([_contactForm.text length] < 10) {
        
        UIAlertView *formError = [[UIAlertView alloc] initWithTitle: nil message:@"please write at least 4 words !" delegate: self cancelButtonTitle: @"Done" otherButtonTitles: nil];
        
        [formError show];
        
    }else{
        [self submit];
    }
}
-(void)submit{
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/api.php?tag=contact_us&user_id=%@&text=%@",_userID,_contactForm.text];
    
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
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
