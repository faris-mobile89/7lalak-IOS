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

-(void)viewDidLayoutSubviews{
    
    [_label_form setText:LocalizedString(@"label_form")];
    [_btn_send setTitle:LocalizedString(@"btn_send_text") forState:UIControlStateNormal];
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
        
        UIAlertView *formError = [[UIAlertView alloc] initWithTitle: nil message:LocalizedString(@"error_form_contact_1") delegate: nil cancelButtonTitle:LocalizedString(@"DONE") otherButtonTitles: nil];
        
        [formError show];
        
    }else{
        [self submit];
    }
}

-(void)submit{
    

    NSString *encodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:encodeURL];
    
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
                 
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [self showMessage:LocalizedString(@"Thanks_contactUs_title") message:LocalizedString(@"Thanks_contactUs_msg")];
                        _contactForm.text=@"";
                         [activityIndicator stopAnimating];

                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
             }else{
                 [activityIndicator stopAnimating];
                 }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                  [activityIndicator stopAnimating];
                 
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
             });
         }
     }];
    

}
-(void)showMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: nil cancelButtonTitle: LocalizedString(@"OK") otherButtonTitles: nil];
    [internetError show];
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
