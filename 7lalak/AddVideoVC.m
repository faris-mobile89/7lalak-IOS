//
//  AddVideoVC.m
//  7lalak
//
//  Created by Faris IOS on 6/25/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "AddVideoVC.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"


@interface AddVideoVC ()
@end

@implementation AddVideoVC



- (void)viewDidLoad
{
    
    [super viewDidLoad];
}
-(void)x{
    
    NSString *stringUrl =@"http://www.myserverurl.com/file/uloaddetails.php?";
    NSString *string =@"http://myimageurkstrn.com/img/myimage.png";
    NSURL *filePath = [NSURL fileURLWithPath:string];
    
    NSDictionary *parameters  = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"id", nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:stringUrl parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileURL:filePath name:@"userfile" error:nil];//here userfile is a paramiter for your image
     }
          success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@",[responseObject valueForKey:@"Root"]);
         //Alert_Success_fail = [[UIAlertView alloc] initWithTitle:@"myappname" message:string delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
         //[Alert_Success_fail show];
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         //Alert_Success_fail = [[UIAlertView alloc] initWithTitle:@"myappname" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        // [Alert_Success_fail show];
         
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
