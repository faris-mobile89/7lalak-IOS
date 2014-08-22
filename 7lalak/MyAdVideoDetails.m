//
//  MyAdVideoDetails.m
//  7lalak
//
//  Created by Faris IOS on 8/20/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MyAdVideoDetails.h"
#import "UIColor_hex.h"
#import "LocalizeHelper.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "Localization.h"
#import "UploadCell.h"
#import "UIImageView+ProgressView.h"
#import "HUD.h"
#import "AddMoreImagesVC.h"


#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface MyAdVideoDetails (){
    NSMutableArray *imagesData;
    UIPickerView *pickerCategoriesInput;
    NSMutableArray *imagesArray;
    NSURL *localVideoURL;
}
@property NSDictionary *jsonObject;
@property NSDictionary *subCat;
@property NSString *catId;
@property (strong) NSString *selectedMaincatId;
@property (strong) NSString *selectedSubcatId;
@property bool flagEditCat;
@property bool isUserPikedImage;
@property bool isFirstLoad;
@property bool isAttachedNewVideo;
@property int selectedIndexMain;
@property int selectedIndexSub;
@property bool flagDelete;
@end

@implementation MyAdVideoDetails

@synthesize jsonObject,subCat,catId,selectedMaincatId,selectedSubcatId,flagDelete,isAttachedNewVideo;
@synthesize flagEditCat,isUserPikedImage,isFirstLoad,selectedIndexSub,selectedIndexMain;
@synthesize videoURL,isUploadVideo;

-(void)viewDidLayoutSubviews{

    [_categoryField setPlaceholder:LocalizedString(@"holder_cat")];
    
    _description.layer.cornerRadius= 10;
    _description.layer.borderWidth=0.5;
    _description.clipsToBounds = YES;
    _description.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectedMaincatId = [[NSString alloc]init];
    selectedSubcatId = [[NSString alloc]init];
     selectedSubcatId =_paramSid; selectedMaincatId=_paramMid;
    
    if (!isUploadVideo) {
        [_iconVideoFlag setHidden:YES];
        [_labelStatus setText:LocalizedString(@"FLAG_LESS_25MB")];
    }else{
        [_labelStatus setHidden:TRUE];
    }
    [_saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    flagEditCat= false;
    isUserPikedImage =false;
    isFirstLoad = true;
    flagDelete = false;
    isAttachedNewVideo = false;
    
    _price.delegate = self;
    _description.delegate=self;
    
    _description.text= _paramDescription;
    _price.text = _paramPrice;
    
    pickerCategoriesInput = [[UIPickerView alloc]init];
    pickerCategoriesInput.delegate=self;
    pickerCategoriesInput.dataSource=self;
    _categoryField.inputView=pickerCategoriesInput;
    
    imagesData = [[NSMutableArray alloc]init];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    _price.inputAccessoryView = numberToolbar;
    _categoryField.inputAccessoryView = numberToolbar;
    
    if ([_paramStatus isEqualToString:@"2"]) {
        
        [_availability setSelectedSegmentIndex:0];
        
    }else{
        [_availability setSelectedSegmentIndex:1];
    }
    
    [self loadMainCat];
}

#pragma mark Video Picker


- (IBAction)replaceVideoClick:(id)sender {
    
    UIAlertView *chooser = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"PICK_GALLERY"),LocalizedString(@"Open_camera"), nil];
    [chooser show];
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
    NSURL *chosenMovie = [info objectForKey:UIImagePickerControllerMediaURL];
    NSURL *fileURL = [self grabFileURL:@"video_7lalek.mov"];
    NSData *movieData = [NSData dataWithContentsOfURL:chosenMovie];
    [movieData writeToURL:fileURL atomically:YES];
    
    UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);

    localVideoURL = fileURL;

    
    if (movieData.length/1024.0f/1024.0f > 2.0f ) {
        [_saveBtn setEnabled:FALSE];
         [_labelStatus setHidden:FALSE];
        _labelStatus.text=@"Attaced video is greater than 2MB";
        return;
    }else{
        [ _saveBtn setEnabled:TRUE];
         [_labelStatus setHidden:FALSE];
    }
    
    _labelStatus.text=LocalizedString(@"ONE_VID_ATTACHED");
    isAttachedNewVideo = true;
    [_iconVideoFlag setHidden:NO];
}


- (IBAction)deleteBtn:(id)sender {
    
    flagDelete = true;
    UIAlertView *deleteConfirm = [[UIAlertView alloc]initWithTitle:nil message:LocalizedString(@"DELETE_CONFIRM") delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"DELETE"), nil];
    [deleteConfirm show];

}


- (IBAction)saveBtn:(id)sender {
    
    NSString*paramSelectedMaincatId,*paramSelectedSubcatId;
    
    if (flagEditCat) {
        
            //send new cat
            NSLog(@"selected= %@,%@",selectedMaincatId,selectedSubcatId);
            paramSelectedMaincatId = selectedMaincatId;
            paramSelectedSubcatId = selectedSubcatId;
            if (selectedMaincatId == nil || selectedSubcatId == nil) {
                NSLog(@"please select category");
                return;
            }
        
        
    }else{
        paramSelectedSubcatId = @"00"; paramSelectedMaincatId=@"00";
        NSLog(@"no categ selected");
        
    }
    
    NSString *newSatus;
    if (_availability.selectedSegmentIndex == 0 ) {
        newSatus  = @"2"; //sold
    }else if (_availability.selectedSegmentIndex == 1 ){
        newSatus = @"1"; //available
    }
    
    NSString *strURL = @"http://7lalek.com/api/uploader.php";
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING")];
    
    
    NSDictionary *dictParameter =@{
                                   @"tag":@"editVideoAd",
                                   @"Ad_id":_paramAdId,
                                   @"text":_description.text,
                                   @"price":_price.text,
                                   @"status":newSatus,
                                   @"mid":paramSelectedMaincatId,
                                   @"sid":paramSelectedSubcatId,
                                   @"user_id":_userID,
                                   @"UDID":_apiKey
                                   };
    
   
    NSString *date = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    date =  [date stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    NSString *videoName = [[NSString alloc]initWithFormat:@"7lalak_IOS_Video_%@%@",
                           date,@".mov"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"uploading...");
        
        if (localVideoURL != nil && isAttachedNewVideo) {
            NSData *videoData= [NSData dataWithContentsOfURL:localVideoURL];
            [formData appendPartWithFileData:videoData name:@"7lalak_video_file" fileName:videoName mimeType:@"video/MPEG"];
        }else{
            [self showMessage:@"" message:LocalizedString(@"ERROR_SELECT_VIDEO")];
            return;
        }
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"Success:***** %@", responseObject);
                                           [HUD hideUIBlockingIndicator];
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
                                           [self showMessage:@"" message:LocalizedString(@"ERROR_UPLOAD")];
                                           
                                       }];
    
    [op start];
    
    
    
}

-(void)deleteAction{
    
    NSString *strURL = @"http://7lalek.com/api/api.php";
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"DELETING")];
    
    NSDictionary *dictParameter =@{
                                   @"tag":@"deleteAd",
                                   @"Ad_id":_paramAdId,
                                   @"user_id":_userID,
                                   @"UDID":_apiKey
                                   };
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [HUD hideUIBlockingIndicator];
                                           if (responseObject != nil) {
                                               
                                               if ([[responseObject valueForKey:@"error"]intValue]==0) {
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                           }
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [HUD hideUIBlockingIndicator];
                                       }];
    
    [op start];
    
}

#pragma mark picker

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
        // [label setFont:[UIFont  boldSystemFontOfSize:10]];
        
        
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        label.numberOfLines=3;
        //[label setBackgroundColor:[UIColor colorWithHexString:@"339999"]];
        
        if (component == 0) {
            if ([[jsonObject objectForKey:@"MainCat"]count]>0) {
                NSString *lableText= [[NSString alloc]initWithFormat:@"%@  >   ",[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"name"]];
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
    
    flagEditCat = true;
    
    if (component==0){
        selectedIndexMain = (int)row;
        catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"id"];
        [self loadSubCat];
        selectedMaincatId = catId;
        NSLog(@"Main Picked = %@ , %@",[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:selectedIndexMain]valueForKey:@"name"],selectedMaincatId);
    }else if (component == 1){
        
        isUserPikedImage = true;
        selectedIndexSub = (int)row;
        selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"id"];
        
        NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:row]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:selectedIndexMain]valueForKey:@"name"]];
        
        _categoryField.text = catName;
        
        NSLog(@"Sub Picked = %@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:row]valueForKey:@"name"],selectedSubcatId);
    }
}

-(void)loadSubCat{
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getSubCategories.php?tag=getSubCat&mainId=%@&lang=%@",catId,[[Localization sharedInstance]getPreferredLanguage]];
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING") withTimeout:3];
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
             [HUD hideUIBlockingIndicator];
             if (httpResponse.statusCode == 200 /* OK */) {
                 NSError* error;
                 subCat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (subCat) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if ([subCat count] < 1 )
                             return;
                         selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"id"];
                         [pickerCategoriesInput reloadComponent:1];
                         
                         if (isFirstLoad) {
                             
                             // search by cat name => return cat name from JSON
                             for (NSInteger i = 0 ; i < [[subCat objectForKey:@"SubCat"]count]; i++) {
                                 
                                 if ([_paramSid intValue] ==  [[[[subCat objectForKey:@"SubCat"]objectAtIndex:i]objectForKey:@"id"]intValue] ) {
                                     
                                     _categoryField.text = [[[subCat objectForKey:@"SubCat"]objectAtIndex:i]objectForKey:@"name"];
                                     isFirstLoad = false;
                                     break;
                                 }
                             }
                         }//end first load
                         
                         // NSLog(@"subCat: %@", subCat);
                         
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
             }
         }
         else {
             [HUD hideUIBlockingIndicator];
         }
     }];
    
}

-(void)loadMainCat{
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getMainCategories.php?tag=getMainCat&lang=%@",[[Localization sharedInstance]getPreferredLanguage]];
    
    NSURL* url = [NSURL URLWithString:urlString];
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
                 
                 jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [pickerCategoriesInput reloadComponent:0];
                         
                         catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"id"];
                         selectedMaincatId = catId;
                         selectedIndexMain = 0;
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
                 
             }
         }
         else {
             // show offiline msg
         }
     }];
    
}

#pragma mark images slider view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([imagesArray count]) {
        return [imagesArray count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UploadCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSURL *u = [NSURL URLWithString:imagesArray[indexPath.row]];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    UIProgressView * p = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    
    [cell.imageView setImageWithURL:u usingProgressView:p];
    
    [cell.deleteBtn addTarget:self action:@selector(deleteItem:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark Keyboard

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _price) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else return YES;
}

-(void)doneButton:(id)sender{
    
    if (flagEditCat) {
        
        NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:selectedIndexSub]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:selectedIndexMain]valueForKey:@"name"]];
        _categoryField.text = catName;
        NSLog(@"edit cat");
    }
    
    
    [_price resignFirstResponder];
    [_categoryField resignFirstResponder];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (flagDelete && buttonIndex == 1) {
        
        [self deleteAction];
        flagDelete = false;
        return;
    }
    
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [_price resignFirstResponder];
    return YES;
}

-(void)showErrorInterentMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}
-(void)showMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: nil cancelButtonTitle: LocalizedString(@"OK") otherButtonTitles: nil];
    
    [internetError show];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
