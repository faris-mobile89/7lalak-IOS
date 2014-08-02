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
#import "UploadCell.h"
#import "UIColor_hex.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "LocalizeHelper.h"

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height>=568.0f?480:300;

@interface AddVideoVC (){
    NSArray *recipeImages;
    NSMutableArray *imagesData;
    NSMutableArray *imagesDataToUpload;
    NSMutableArray *pickerJsonData;
    NSMutableArray *mainCat;
    UIActivityIndicatorView *activityIndicator;
    
    
}
@property NSDictionary *jsonObject;
@property NSDictionary *subCat;
@property NSString *catId;
@property NSString *selectedMaincatId;
@property NSString *selectedSubcatId;
@property NSURL *videoURL;

@end


@implementation AddVideoVC
@synthesize userID;
@synthesize subCat,catId,selectedMaincatId,selectedSubcatId,jsonObject;
@synthesize videoURL;
float hieght;
bool flagTextenter;
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = LocalizedString(@"TITLE_MORE_ADD_VIDEO");
    
    hieght = SCREEN_HEIGHT;
    
    if (hieght < 500) {
        _pickerCategories.transform = CGAffineTransformMakeScale(.5, 0.5);
    }
    flagTextenter =FALSE;
    jsonObject =[[NSDictionary alloc]init];
    subCat = [[NSDictionary alloc]init];
    catId =[[NSString alloc]init];
    selectedMaincatId  = [[NSString alloc]init];
    selectedSubcatId   = [[NSString alloc]init];
    //_labelSelectCat.layer.cornerRadius =6;
    _fAdsPrice.delegate=self;
    _fAdsText.delegate=self;
    _fAdsText.layer.cornerRadius=10;
    _fAdsText.layer.borderWidth=0.5;
    _fAdsText.clipsToBounds = YES;
    _fAdsText.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)+50);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    pickerJsonData = [[NSMutableArray alloc]init];
    
    imagesData = [[NSMutableArray alloc]init];
    imagesDataToUpload = [[NSMutableArray alloc]init];
    
    [self loadMainCat];
}

- (IBAction)addVideoButton:(id)sender {
    
    UIAlertView *chooser = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Pick from gallery",@"Open camera", nil];
    [chooser show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
      picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    
    if (buttonIndex == 1) {
        //picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
        
    }else if (buttonIndex == 2){
 		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:nil];

    }
    

}
- (NSURL*)grabFileURL:(NSString *)fileName {
    
    // find Documents directory
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    // append a file name to it
    documentsURL = [documentsURL URLByAppendingPathComponent:fileName];
    
    return documentsURL;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    // grab our movie URL
    NSURL *chosenMovie = [info objectForKey:UIImagePickerControllerMediaURL];
    // save it to the documents directory
    NSURL *fileURL = [self grabFileURL:@"video_7lalek.mov"];
    NSData *movieData = [NSData dataWithContentsOfURL:chosenMovie];
    [movieData writeToURL:fileURL atomically:YES];
    
    // save it to the Camera Roll
    UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);
    
    // and dismiss the picker
    NSLog(@"Picked Video Url:%@",fileURL);
    videoURL = fileURL;

    
    _textVideoindicator.text=LocalizedString(@"ONE_VID_ATTACHED");
    [_imageVideoIndicator setImage:[UIImage imageNamed:@"ic_video_file.png"]];
    [_buttonaddVideo setTitle:LocalizedString(@"REPLACE_VID") forState:UIControlStateNormal];
    
    //[imagesDataToUpload addObject:imageToUpload];
    
    //[imagesData addObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    

}

#pragma mark upload block

- (IBAction)uploadButtonAction:(id)sender {
    
    if ([_fAdsPrice.text length] >= 1  && [_fAdsText.text length]> 5 ) {
        NSLog(@"starting Upload");
        [self uploadService];
    }
}

-(void)uploadService{
    
    [activityIndicator startAnimating];
    NSString * MCID =[[NSString alloc]initWithFormat:@"%@",selectedMaincatId];
    NSString * SCID =[[NSString alloc]initWithFormat:@"%@",selectedSubcatId];
    NSDictionary *dictParameter = @{
                                    @"tag":@"uploadVideoAd",
                                    @"userID": userID,
                                    @"UDID":_apiKey,
                                    @"text":_fAdsText.text,
                                    @"price":_fAdsPrice.text,
                                    @"mainCatID":MCID,@"subCatID":SCID
                                    };
    NSLog(@"dic%@",dictParameter);
    NSString *strURL = @"http://7lalek.com/api/uploader.php";
    
    NSString *date = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    date =  [date stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *videoName = [[NSString alloc]initWithFormat:@"7lalak_IOS_Video_%@%@",
                           date,@".mov"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"starting Upload ...");
        
        
        NSData *videoData= [NSData dataWithContentsOfURL:videoURL];

    [formData appendPartWithFileData:videoData name:@"7lalak_video_file" fileName:videoName mimeType:@"video/MPEG"];
    }
                                       success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
                                           NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                           [activityIndicator stopAnimating];
                                           
                                           UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:nil message:LocalizedString(@"MESSAGE_ADs_Added") delegate:nil cancelButtonTitle:LocalizedString(@"DONE") otherButtonTitles:nil        , nil];
                                           [successAlert show];
                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [activityIndicator stopAnimating];
                                       }];
    
    [op start];
    
}



#pragma mark pickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component ==0) {
        return [[jsonObject objectForKey:@"MainCat"]count];
    }else if (component==1){
        return [[subCat objectForKey:@"SubCat"]count];
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [[UILabel alloc] init];
        [label setFont:[UIFont  boldSystemFontOfSize:10]];
         label.numberOfLines=3;
        
        
        if(hieght<500){
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
            //label.text = [NSString stringWithFormat:@"  %ld", row+1];
        }
        
        if (component == 0) {
            if ([[jsonObject objectForKey:@"MainCat"]count]>0) {
                NSString *lableText= [[NSString alloc]initWithFormat:@"%@  >",[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"name"]];
                label.text= lableText;
            }
        }
        
        else if (component==1){
            if ([[subCat objectForKey:@"SubCat"]count]>0) {
                
                label.text=  [[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"name"];
                
            }
        }
        
    }
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0){
        
        catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"id"];
        [self loadSubCat];
        selectedMaincatId = catId;
    }else if (component == 1){
        selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"id"];
    }
}

-(void)loadSubCat{
    
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getSubCategories.php?tag=getSubCat&mainId=%@",catId];
    
    NSURL *url= [NSURL URLWithString:urlString];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
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
                 
                 subCat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (subCat) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         [_pickerCategories reloadComponent:1];
                         
                         if ([subCat count]>0)
                             selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"id"];
                         
                         
                         //NSLog(@"subCat: %@", subCat);
                         
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
             dispatch_async(dispatch_get_main_queue(), ^{
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}

-(void)loadMainCat{
    
    NSURL* url = [NSURL URLWithString:@"http://7lalek.com/api/getMainCategories.php?tag=getMainCat"];
    
    NSMutableURLRequest* urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
    
    
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
                         [_pickerCategories reloadComponent:0];
                         
                         catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"id"];
                         selectedMaincatId = catId;
                         [self loadSubCat];
                         
                         // NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);
                         
                         
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    // to remove placeholder
    if (!flagTextenter) {
        self.fAdsText.text=@"";
        flagTextenter = TRUE;
    }
    return TRUE;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_fAdsPrice resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _fAdsPrice) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
