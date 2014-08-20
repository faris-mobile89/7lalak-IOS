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
#import "LocalizeHelper.h"
#import "Localization.h"
#include "HUD.h"

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height>=568.0f?480:300;

@interface AddVideoVC (){
    NSArray *recipeImages;
    NSMutableArray *imagesData;
    NSMutableArray *imagesDataToUpload;
    NSMutableArray *pickerJsonData;
    NSMutableArray *mainCat;
    UIPickerView *pickerCategoriesInput;
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
int selectedIndexMain;
bool isUserPiked = false;
bool isFirstLoadSubCat = true;


-(void)viewDidLayoutSubviews{
    
    //== Localization UI =====//
    [_categoryField setPlaceholder:LocalizedString(@"holder_cat")];
    [_fAdsPrice setPlaceholder:LocalizedString(@"holder_price")];
    [_buttonaddVideo setTitle:LocalizedString(@"btn_Add_Video") forState:UIControlStateNormal];
    [_upload_btn setTitle:LocalizedString(@"btn_Upload") forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.title = LocalizedString(@"TITLE_MORE_ADD_VIDEO");
    [_fAdsText setText:LocalizedString(@"holder_description")];
    hieght = SCREEN_HEIGHT;
    pickerCategoriesInput = [[UIPickerView alloc]init];
    pickerCategoriesInput.delegate=self;
    pickerCategoriesInput.dataSource=self;
    _categoryField.inputView=pickerCategoriesInput;
    
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
    
    [_upload_btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    pickerJsonData = [[NSMutableArray alloc]init];
    
    imagesData = [[NSMutableArray alloc]init];
    imagesDataToUpload = [[NSMutableArray alloc]init];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:LocalizedString(@"DONE") style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    
    _fAdsPrice.inputAccessoryView = numberToolbar;
    _categoryField.inputAccessoryView = numberToolbar;
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, 130);
    [self.view addSubview: activityIndicator];
    
    
    [self loadMainCat];
}

- (IBAction)addVideoButton:(id)sender {
    
    UIAlertView *chooser = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"PICK_GALLERY"),LocalizedString(@"Open_camera"), nil];
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
   // NSLog(@"Picked Video Url:%@",fileURL);
    videoURL = fileURL;

    //NSLog(@"video file size %@",[NSByteCountFormatter stringFromByteCount:movieData.length countStyle:NSByteCountFormatterCountStyleFile]);
   // NSLog(@"video file size %f",movieData.length/1024.0f/1024.0f);
    
    if (movieData.length/1024.0f/1024.0f > 2.0f ) {
        [_upload_btn setEnabled:FALSE];
        _textVideoindicator.text=@"Attaced video is greater than 2MB";
        return;
    }else{
        [_upload_btn setEnabled:TRUE];
    }
    
    _textVideoindicator.text=LocalizedString(@"ONE_VID_ATTACHED");
    [_imageVideoIndicator setImage:[UIImage imageNamed:@"ic_video_file.png"]];
    [_buttonaddVideo setTitle:LocalizedString(@"REPLACE_VID") forState:UIControlStateNormal];
    
}

#pragma mark upload block

- (IBAction)uploadButtonAction:(id)sender {
  
    
    if ([_categoryField.text length] < 3 ) {
        
        [self showMessage:LocalizedString(@"") message:LocalizedString(@"ADs_CAT_REQUIRED")];
        return;
    }
    
    if ([_fAdsText.text length] < 13 ) {
        [self showMessage:LocalizedString(@"") message:LocalizedString(@"ADs_TEXT_REQUIRED")];
        return;
    }

        
     if ([_fAdsPrice.text length] < 1)
            _fAdsPrice.text=@"0";
        
    
    if (videoURL == nil) {
        
        [self showMessage:@"" message:LocalizedString(@"ERROR_SELECT_VIDEO")];
        return;
    }
    
        NSLog(@"starting Upload");
        [_upload_btn setEnabled:FALSE];
        [self uploadService];
        
}

-(void)uploadService{
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"UPLOADING")];
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
    //NSLog(@"dic%@",dictParameter);
    NSString *strURL = @"http://7lalek.com/api/uploader.php";
    
    NSString *date = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    date =  [date stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *videoName = [[NSString alloc]initWithFormat:@"7lalak_IOS_Video_%@%@",
                           date,@".mov"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"starting Upload ...");

        if (videoURL != nil) {
            NSData *videoData= [NSData dataWithContentsOfURL:videoURL];
             [formData appendPartWithFileData:videoData name:@"7lalak_video_file" fileName:videoName mimeType:@"video/MPEG"];
        }else{
            [self showMessage:@"" message:LocalizedString(@"ERROR_SELECT_VIDEO")];
            return;
        }
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                           
                                           [HUD hideUIBlockingIndicator];
                                           [_upload_btn setEnabled:TRUE];
                                           
                                           if ([[responseObject valueForKey:@"error"]intValue] == 0) {
                                               
                                               [self showMessage:@"" message:LocalizedString(@"MESSAGE_ADs_Added")];
                                               
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }else{
                                               [self showMessage:@"" message:LocalizedString(@"ERROR_UPLOAD")];
                                           }
                                       }
                                  
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [HUD hideUIBlockingIndicator];
                                           [_upload_btn setEnabled:TRUE];
                                           [self showMessage:@"" message:LocalizedString(@"ERROR_UPLOAD")];
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
        [label setFont:[UIFont  boldSystemFontOfSize:15]];
         label.numberOfLines=3;
        
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
        
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
        
        selectedIndexMain = (int)row;
        catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"id"];
        selectedMaincatId = catId;
        _categoryField.text=@"";
        [self loadSubCat];
        
    }else if (component == 1){
        isUserPiked = true;
        
        selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"id"];
        
        NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:selectedIndexMain]valueForKey:@"name"]];
        _categoryField.text = catName;
    }
}

-(void)loadSubCat{
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getSubCategories.php?tag=getSubCat&mainId=%@&lang=%@",catId,[[Localization sharedInstance]getPreferredLanguage]];
    
    [activityIndicator startAnimating];
    NSURL *url= [NSURL URLWithString:urlString];
    
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
                 
                 subCat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (subCat) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [activityIndicator stopAnimating];
                         [pickerCategoriesInput reloadComponent:1];
                         
                         if ([subCat count]>0)
                             selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"id"];
                         
                         if (!isFirstLoadSubCat) {
                             
                             NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"name"]];
                             _categoryField.text = catName;
                             
                         }
                         isFirstLoadSubCat = false;
                         //NSLog(@"subCat: %@", subCat);
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                         [activityIndicator stopAnimating];
                         NSLog(@"ERROR: %@", error);
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
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}

-(void)loadMainCat{
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getMainCategories.php?tag=getMainCat&lang=%@",[[Localization sharedInstance]getPreferredLanguage]];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
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
                         [pickerCategoriesInput reloadComponent:0];
                         [activityIndicator stopAnimating];
                         catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"id"];
                         selectedMaincatId = catId;
                         selectedIndexMain =0;
                         [self loadSubCat];
                         
                         // NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"ERROR: %@", error);
                         [activityIndicator stopAnimating];
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
                 [activityIndicator stopAnimating];
             }else{
                 [activityIndicator stopAnimating];
                
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activityIndicator stopAnimating];
                 });
             }
         }
         else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
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

-(void)doneButton:(id)sender{
    
    if (!isUserPiked) {
    NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:selectedIndexMain]valueForKey:@"name"]];
    _categoryField.text = catName;
    }
    
    [_fAdsPrice resignFirstResponder];
    [_categoryField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _fAdsPrice) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController){
        [UIMenuController sharedMenuController].menuVisible= NO;
    }
        return NO;
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
