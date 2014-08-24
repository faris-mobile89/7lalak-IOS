//
//  AddImageVC.m
//  7lalak
//
//  Created by Faris IOS on 7/1/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "AddImageVC.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"
#import "UploadCell.h"
#import "UIColor_hex.h"
#import "LocalizeHelper.h"
#import "Localization.h"

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height>=568.0f?480:300;

@interface AddImageVC (){
    NSArray *recipeImages;
    NSMutableArray *imagesData;
    NSMutableArray *imagesDataToUpload;
    NSMutableArray *pickerJsonData;
    NSMutableArray *mainCat;
    UIActivityIndicatorView *activityIndicator;
    UIPickerView *pickerCategoriesInput;
}
@property NSDictionary *jsonObject;
@property NSDictionary *subCat;
@property NSString *catId;
@property NSString *selectedMaincatId;
@property NSString *selectedSubcatId;

@end


@implementation AddImageVC
@synthesize choosePhotoBtn, takePhotoBtn;
@synthesize userID;
@synthesize subCat,catId,selectedMaincatId,selectedSubcatId,jsonObject;
float hieght;
int selectedIndexMain;

BOOL flagTextenter;
bool isUserPikedImage3 = false;
bool isFirstLoadSubCatImages = true;

-(void)viewDidLayoutSubviews{
    
    //== Localization UI =====//
    [_categoryField setPlaceholder:LocalizedString(@"holder_cat")];
    [_fAdsPrice setPlaceholder:LocalizedString(@"holder_price")];
    [choosePhotoBtn setTitle:LocalizedString(@"btn_Add_Image") forState:UIControlStateNormal];
    [_upload_btn setTitle:LocalizedString(@"btn_Upload") forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flagTextenter =FALSE;
    self.title = LocalizedString(@"TITLE_MORE_ADD_IMAGE");
    [_fAdsText setText:LocalizedString(@"holder_description")];
    hieght = SCREEN_HEIGHT;
    
    pickerCategoriesInput = [[UIPickerView alloc]init];
    pickerCategoriesInput.delegate=self;
    pickerCategoriesInput.dataSource=self;
    _categoryField.inputView=pickerCategoriesInput;
    
    jsonObject =[[NSDictionary alloc]init];
    subCat = [[NSDictionary alloc]init];
    catId =[[NSString alloc]init];
    selectedMaincatId  = [[NSString alloc]init];
    selectedSubcatId   = [[NSString alloc]init];
    
    _fAdsPrice.delegate=self;
    _fAdsText.delegate=self;
    _fAdsText.layer.cornerRadius=10;
    _fAdsText.layer.borderWidth=0.5;
    _fAdsText.clipsToBounds = YES;
    
    _fAdsText.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, 130);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    pickerJsonData = [[NSMutableArray alloc]init];
    
    imagesData = [[NSMutableArray alloc]init];
    imagesDataToUpload = [[NSMutableArray alloc]init];
    
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self loadMainCat];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    _fAdsPrice.inputAccessoryView = numberToolbar;
    _categoryField.inputAccessoryView = numberToolbar;

}



-(IBAction) getPhoto:(id) sender {
    
    UIAlertView *chooser = [[UIAlertView alloc]initWithTitle:nil message:nil delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"PICK_GALLERY"),LocalizedString(@"Open_camera"), nil];
    [chooser show];
	
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;


    if (buttonIndex == 1) {
       // picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.navigationController presentViewController:picker animated:YES completion:nil];

    }else if (buttonIndex == 2){
 		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:nil];

    }
    
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
	 imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSData *imageToUpload = UIImageJPEGRepresentation([info objectForKey:@"UIImagePickerControllerOriginalImage"], 1.0);
    
    
    [imagesDataToUpload addObject:imageToUpload];

    [imagesData addObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    

    [_collectionView reloadData];
    if ([imagesData count]>6) {
        [choosePhotoBtn setEnabled:FALSE];
    }
}

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
    
    //NSLog(@"starting Upload");
    [_upload_btn setEnabled:FALSE];
    [self uploadService];
    

}

#pragma mark uploader-block

-(void)uploadService{
    
    NSString * MCID =[[NSString alloc]initWithFormat:@"%@",selectedMaincatId];
    NSString * SCID =[[NSString alloc]initWithFormat:@"%@",selectedSubcatId];
   // NSLog(@"cat%@%@",MCID,SCID);
    NSDictionary *dictParameter = @{
                                    @"tag":@"uploadImageAd",
                                    @"userID": userID,
                                    @"UDID":_apiKey,
                                    @"text":_fAdsText.text,
                                    @"price":_fAdsPrice.text,
                                    @"mainCatID":MCID,@"subCatID":SCID
                                    };
    
    NSString *strURL = @"http://7lalek.com/api/uploader.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"uploading...");
        [activityIndicator startAnimating];
        for (int i =0 ; i<[imagesDataToUpload count]; i++) {
            
            NSString *date = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            date =  [date stringByReplacingOccurrencesOfString:@"." withString:@""];
            NSString *imageName = [[NSString alloc]initWithFormat:@"7lalak_IOS%i_%@%@",i,
                                   date,@".jpg"];
            
            [formData appendPartWithFileData:[imagesDataToUpload  objectAtIndex:i]
                                        name:[[NSString alloc]initWithFormat:@"file%i",i] fileName:imageName mimeType:@"image/jpeg"];
            
        }
    }
                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           NSLog(@"Success:***** %@", responseObject);
                                           
                                           [activityIndicator stopAnimating];
                                           [_upload_btn setEnabled:TRUE];
                                           
                                           if ([[responseObject valueForKey:@"error"]intValue] == 0) {
                                               
                                            [self showMessage:@"" message:LocalizedString(@"MESSAGE_ADs_Added")];

                                               [self.navigationController popViewControllerAnimated:YES];
                                           }else{
                                               [self showMessage:@"" message:LocalizedString(@"ERROR_UPLOAD")];
                                           }
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           //NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [activityIndicator stopAnimating];
                                           [_upload_btn setEnabled:TRUE];
                                           [self showMessage:@"" message:LocalizedString(@"ERROR_UPLOAD")];

                                       }];
    
    [op start];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [imagesData count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"Cell";
    UploadCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.imageView.image = [imagesData  objectAtIndex:indexPath.row];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo-frame.png"]];
    [cell.deleteBtn addTarget:self action:@selector(deleteItem:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(IBAction)deleteItem:(id)sender event:(id)event{
    
    
    UIView * senderButton = (UIView*)sender;
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(UICollectionViewCell *)[[senderButton superview]superview]];
    [imagesData removeObjectAtIndex:indexPath.row];
    [imagesDataToUpload removeObjectAtIndex:indexPath.row];
    [ _collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
    [_collectionView reloadData];
    // NSLog(@"ImageData Count%i",[imagesData count]);
    if ([imagesData count]<7) {
        [choosePhotoBtn setEnabled:TRUE];
    }
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
         label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13];
        
        if (component == 0) {
            if ([[jsonObject objectForKey:@"MainCat"]count]>0) {
                NSString *lableText= [[NSString alloc]initWithFormat:@"%@  ",[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"name"]];
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
        
        selectedIndexMain = row;
        catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"id"];
        selectedMaincatId = catId;
        _categoryField.text=@"";
        [self loadSubCat];
        
    }else if (component == 1){
        isUserPikedImage3 = true;
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
                         [pickerCategoriesInput reloadComponent:1];
                         
                         if ([subCat count]>0)
                             selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"id"];
                         
                         if (!isFirstLoadSubCatImages) {
                             NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"name"]];
                             _categoryField.text = catName;
                         }
                         isFirstLoadSubCatImages = false;
                         
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
                         [activityIndicator stopAnimating];
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
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_timeout")];
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
                 [self showErrorInterentMessage:LocalizedString(@"error_internet_offiline")];
                 [activityIndicator stopAnimating];
             });
         }
     }];
    
}

#pragma mark Keyboard
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    // to remove placeholder
    if (!flagTextenter) {
        self.fAdsText.text=@"";
        flagTextenter = TRUE;
    }
    return TRUE;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == _fAdsPrice) {
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_fAdsPrice resignFirstResponder];
    return YES;
}
-(void)showErrorInterentMessage:(NSString *)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: LocalizedString(@"NETWORK_ERROR") message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
}
-(void)doneButton:(id)sender{
    
    if (!isUserPikedImage3) {
        NSString *catName= [[NSString alloc]initWithFormat:@"%@ , %@",[[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"name"],[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:selectedIndexMain]valueForKey:@"name"]];
        _categoryField.text = catName;
    }
    
    [_fAdsPrice resignFirstResponder];
    [_categoryField resignFirstResponder];
}

-(void)showMessage:(NSString *)title message:(NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: title message:msg delegate: nil cancelButtonTitle: LocalizedString(@"OK") otherButtonTitles: nil];
    
    [internetError show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
