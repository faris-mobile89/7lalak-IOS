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

#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height>=568.0f?480:300;

@interface AddImageVC (){
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

@end


@implementation AddImageVC
@synthesize choosePhotoBtn, takePhotoBtn;
@synthesize userID;
@synthesize subCat,catId,selectedMaincatId,selectedSubcatId,jsonObject;
float hieght ;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hieght = SCREEN_HEIGHT;
    
    if (hieght < 500) {
        _pickerCategories.transform = CGAffineTransformMakeScale(.5, 0.5);
    }
    jsonObject =[[NSDictionary alloc]init];
    subCat = [[NSDictionary alloc]init];
    catId =[[NSString alloc]init];
    selectedMaincatId  = [[NSString alloc]init];
    selectedSubcatId   = [[NSString alloc]init];

    _fAdsPrice.delegate=self;
    _fAdsText.delegate=self;
    _fAdsText.layer.cornerRadius=10;
    _fAdsText.layer.borderWidth=2.0;
    _fAdsText.clipsToBounds = YES;
    _fAdsText.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, (self.view.frame.size.height / 2.0)-50);
    [self.view addSubview: activityIndicator];
    
    [activityIndicator startAnimating];
    
    pickerJsonData = [[NSMutableArray alloc]init];
    
    
    _pickerCategories.frame = CGRectMake(0, 0, 300, 162.0);
    imagesData = [[NSMutableArray alloc]init];
    imagesDataToUpload = [[NSMutableArray alloc]init];
    
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self loadMainCat];
}

- (IBAction)uploadButtonAction:(id)sender {
    
    if ([_fAdsPrice.text length] >= 1  && [_fAdsText.text length]> 5 ) {
        NSLog(@"starting Upload");
        [self uploadService];
    }
}

-(IBAction) getPhoto:(id) sender {
    
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
  //  picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];

	
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
	
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


-(void)uploadService{
    
    //NSLog(@"asdf%@",data);
    NSString * MCID =[[NSString alloc]initWithFormat:@"%@",selectedMaincatId];
    NSString * SCID =[[NSString alloc]initWithFormat:@"%@",selectedSubcatId];
    userID =@"fsdf";
    NSDictionary *dictParameter = @{@"addImage": @{@"userID": userID, @"text":_fAdsText.text,@"price":_fAdsPrice.text, @"mainCatId":MCID,@"subCatID":SCID}};
    
    NSString *strURL = @"http://serv01.vm1692.sgvps.net/~karasi/sale/uploader.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"starting");
        [activityIndicator startAnimating];
        for (int i =0 ; i<[imagesDataToUpload count]; i++) {
            
            NSString *date = [[NSString alloc]initWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
            
            date =  [date stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            NSString *imageName = [[NSString alloc]initWithFormat:@"7lalak_IOS%i_%@%@",i,
                                   date,@".jpg"];
           
            
            [formData appendPartWithFileData:[imagesDataToUpload  objectAtIndex:i]
                                        name:[[NSString alloc]initWithFormat:@"file%i",i] fileName:imageName mimeType:@"image/jpeg"];
            
        }
        // [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    }
                                       success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
                                           NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                           [activityIndicator stopAnimating];
                                           
                                           UIAlertView *successAlert = [[UIAlertView alloc]initWithTitle:@"Uploader" message:@"Your Ads has been added" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil        , nil];
                                           [successAlert show];
                                           
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
                                           [activityIndicator stopAnimating];
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
        [label setFont:[UIFont  boldSystemFontOfSize:10]];
        
        
        
         if(hieght<500){
         label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
         label.text = [NSString stringWithFormat:@"  %d", row+1];
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
 
 
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://ns1.vm1692.sgvps.net/~karasi/sale/getSubCategories.php?tag=getSubCat&mainId=%@",catId];
    
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

-(void)loadMainCat{
    
    NSURL* url = [NSURL URLWithString:@"http://serv01.vm1692.sgvps.net/~karasi/sale/getMainCategories.php?tag=getMainCat"];
    
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

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [_fAdsPrice resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
