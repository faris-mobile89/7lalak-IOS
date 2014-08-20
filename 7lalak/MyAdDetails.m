//
//  MyAdDetails.m
//  7lalak
//
//  Created by Faris IOS on 7/22/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MyAdDetails.h"
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

@interface MyAdDetails (){
NSMutableArray *imagesData;
}
@property NSDictionary *jsonObject;
@property NSDictionary *subCat;
@property NSString *catId;
@property (strong) NSString *selectedMaincatId;
@property (strong) NSString *selectedSubcatId;

@end

@implementation MyAdDetails

@synthesize jsonObject,subCat,catId,selectedMaincatId,selectedSubcatId,jsonImages;
@synthesize attachedNewImages;
NSMutableArray *imagesArray;
bool flagEditCat= false;


-(NSMutableArray *)didDoneClick:(NSMutableArray *)data{

    NSLog(@"imagesArray = %@",imagesArray);
    
    [_lablel_add_image setText:[[NSString alloc]initWithFormat:@"%i new images",[data count]]];
    [_lablel_add_image setTextColor:[UIColor orangeColor]];
    
    attachedNewImages = data;
    return data;
}


-(void)viewDidLayoutSubviews{
    
    [_btnAddImage setBackgroundImage:[UIImage imageNamed:@"add-image-disable"] forState:UIControlStateDisabled];
 
    selectedMaincatId = [[NSString alloc]init];
    selectedSubcatId = [[NSString alloc]init];

    _description.layer.cornerRadius= 10;
    _description.layer.borderWidth=0.5;
    _description.clipsToBounds = YES;
    _description.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    selectedSubcatId =00; selectedMaincatId=00;
    
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _price.delegate = self;
    _description.delegate=self;
    
//=============== LOAD ONLINE IMAGES ==================//
     imagesArray = [[NSMutableArray alloc]init];
    
     if (jsonImages != nil && [jsonImages count]) {
        for (NSInteger i =0 ; i< [jsonImages count]; i++) {
            [imagesArray addObject:[jsonImages objectAtIndex:i]];
        }
        if ([imagesArray count] > 0) {
            [_collectionView reloadData];
        }
    }
    //NSLog(@"FimagesArray = %@",imagesArray);
//=====================================================//
    
    _description.text= _paramDescription;
    _price.text = _paramPrice;
     imagesData = [[NSMutableArray alloc]init];
    attachedNewImages = [[NSMutableArray alloc]init];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButton:)],
                           
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           nil];
    _price.inputAccessoryView = numberToolbar;
    
    if ([_paramStatus isEqualToString:@"2"]) {
        
        [_availability setSelectedSegmentIndex:0];
        
    }else{
        [_availability setSelectedSegmentIndex:1];
    }
    
    //[self loadMainCat];
}


- (IBAction)deleteBtn:(id)sender {
    
    UIAlertView *deleteConfirm = [[UIAlertView alloc]initWithTitle:nil message:LocalizedString(@"DELETE_CONFIRM") delegate:self cancelButtonTitle:LocalizedString(@"CANCEL") otherButtonTitles:LocalizedString(@"DELETE"), nil];
    [deleteConfirm show];
    
    
    
}
- (IBAction)btnAddImageClick:(id)sender {
    
    AddMoreImagesVC *addMore = [self.storyboard instantiateViewControllerWithIdentifier:@"addMoreImages"];
    addMore.numberOfAllowedImage =  7 - [imagesArray count];
    addMore.delegate = self;
    addMore.imagesData = attachedNewImages;
    [self.navigationController pushViewController:addMore animated:YES];

}


- (IBAction)saveBtn:(id)sender {
    
    NSString*paramSelectedMaincatId,*paramSelectedSubcatId;
    
    if (flagEditCat) {
    
    if (selectedSubcatId != _paramSid) {
        //send new cat
        NSLog(@"selected= %@,%@",selectedMaincatId,selectedSubcatId);
        paramSelectedMaincatId = selectedMaincatId;
        paramSelectedSubcatId = selectedSubcatId;
        if (selectedMaincatId == nil || selectedSubcatId == nil) {
            NSLog(@"please select category");
            return;
        }
     }
    
    }else{
        paramSelectedSubcatId = @"00"; paramSelectedMaincatId=@"00";
        NSLog(@"nil selected");
        
    }
    
    NSString *newSatus;
    if (_availability.selectedSegmentIndex == 0 ) {
       newSatus  = @"2"; //sold
    }else if (_availability.selectedSegmentIndex == 1 ){
        newSatus = @"1"; //available
    }
    
//++================= HANDLE NEW & OLD IMAGES TO UPLOAD ===================//
    NSError *error = [[NSError alloc]init];
    
    NSData *oldImagesJSON = [NSJSONSerialization dataWithJSONObject:imagesArray options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonStringWithOldImages = [[NSString alloc]initWithData:oldImagesJSON encoding:NSUTF8StringEncoding];
    
    //NSLog(@"new Imaes JSNON %@",jsonStringWithOldImages);
    
    return;
    
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
    
    
    
    NSString *strURL = @"http://7lalek.com/api/api.php";
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING")];
    
    NSDictionary *dictParameter =@{
                                   @"tag":@"editImageAd",
                                   @"Ad_id":_paramAdId,
                                   @"text":_description.text,
                                   @"price":_price.text,
                                   @"status":newSatus,
                                   @"mid":paramSelectedMaincatId,
                                   @"sid":paramSelectedSubcatId,
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
                                        NSLog(@"Error: %@ ***** %@", operation.responseString, error);                                          [HUD hideUIBlockingIndicator];

                                       }];
    
    [op start];

    
}

-(void)deleteAction{
    
    NSString *strURL = @"http://7lalek.com/api/api.php";
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING")];
    
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
        
    
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14];
        label.numberOfLines=3;
        //[label setBackgroundColor:[UIColor colorWithHexString:@"339999"]];
        
        if (component == 0) {
            if ([[jsonObject objectForKey:@"MainCat"]count]>0) {
                NSString *lableText= [[NSString alloc]initWithFormat:@"%@ > ",[[[jsonObject objectForKey:@"MainCat"]objectAtIndex:row]valueForKey:@"name"]];
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
    
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://7lalek.com/api/getSubCategories.php?tag=getSubCat&mainId=%@&lang=%@",catId,[[Localization sharedInstance]getPreferredLanguage]];
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING")];
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
                 [HUD hideUIBlockingIndicator];
                 subCat = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (subCat) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         if ([subCat count] < 1 )
                             return;
                         
                         selectedSubcatId = [[[subCat objectForKey:@"SubCat"]objectAtIndex:0]objectForKey:@"id"];
                         
                         ;
                          // search by cat name => return cat name from JSON
                         for (NSInteger i = 0 ; i < [[subCat objectForKey:@"SubCat"]count]; i++) {
                             
                             if ([_paramSid intValue] ==  [[[[subCat objectForKey:@"SubCat"]objectAtIndex:i]objectForKey:@"id"]intValue] ) {
                                 
                                 _labelCatName.text = [[[subCat objectForKey:@"SubCat"]objectAtIndex:i]objectForKey:@"name"];
                                 break;
                             }
                         }
                       
                        // NSLog(@"subCat: %@", subCat);
                         
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [HUD hideUIBlockingIndicator];
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 [HUD hideUIBlockingIndicator];

                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Connection Time Out" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
             }else{
                 [HUD hideUIBlockingIndicator];
                 
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
    
    [HUD showUIBlockingIndicatorWithText:LocalizedString(@"LOADING")];
    
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
                 [HUD hideUIBlockingIndicator];
                 jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                        // [_category_picker reloadComponent:0];
                         
                         catId = [[[jsonObject objectForKey:@"MainCat"]objectAtIndex:0]valueForKey:@"id"];
                         selectedMaincatId = catId;
                         [self loadSubCat];
                         // NSLog(@"jsonObject: %@", [jsonObject objectForKey:@"MainCat"]);
                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         NSLog(@"ERROR: %@", error);
                         [HUD hideUIBlockingIndicator];
                     });
                 }
             }
             
             else if(httpResponse.statusCode == 408){
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error" message: @"Connection Time Out" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
                 [HUD hideUIBlockingIndicator];

             }else{
                 [HUD hideUIBlockingIndicator];
             }
         }
         else {
             [HUD hideUIBlockingIndicator];
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
    UIProgressView * p = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    [cell.imageView setImageWithURL:u usingProgressView:p];
    
    [cell.deleteBtn addTarget:self action:@selector(deleteItem:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(IBAction)deleteItem:(id)sender event:(id)event{
    
    
    UIView * senderButton = (UIView*)sender;
    
    NSIndexPath *indexPath = [_collectionView indexPathForCell:(UICollectionViewCell *)[[senderButton superview]superview]];
    [imagesArray removeObjectAtIndex:indexPath.row];
    [ _collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    [_collectionView reloadData];
    
    if ([imagesArray count]<7) {
       [_btnAddImage setEnabled:TRUE];
    }else{
        [_btnAddImage setEnabled:FALSE];}
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
    
    [_price resignFirstResponder];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
