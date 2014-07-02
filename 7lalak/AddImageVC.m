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

@interface AddImageVC (){
    NSArray *recipeImages;
    NSMutableArray *imagesData;
    NSMutableArray *pickerJsonData;
    NSMutableArray *mainCat;
}
@end


@implementation AddImageVC
@synthesize choosePhotoBtn, takePhotoBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pickerJsonData = [[NSMutableArray alloc]init];
    
    [self loadPickerViewData ];
    
    _pickerCategories.frame = CGRectMake(0, 0, 300, 162.0);
    imagesData = [[NSMutableArray alloc]init];
    
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}

-(IBAction) getPhoto:(id) sender {
    
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	
	if((UIButton *) sender == choosePhotoBtn) {
		picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
	} else {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
	
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
    [picker dismissViewControllerAnimated:YES completion:nil];
    
	//imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    //NSData *imageToUpload = UIImageJPEGRepresentation(imageView.image, 1.0);
    
    [imagesData addObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    //[self send:imageToUpload];
    [_collectionView reloadData];
    if ([imagesData count]>6) {
        [choosePhotoBtn setEnabled:FALSE];
    }
}


-(void)send:(NSData *)data{
    
    //NSLog(@"asdf%@",data);
    
    NSDictionary *dictParameter = @{@"adduser": @{@"firstname": @"faris", @"lastname":@"nemet",@"email":@"faris.it.cs@gmail.com", @"projectids":@"1"}};
    
    NSString *strURL = @"http://serv01.vm1692.sgvps.net/~karasi/sale/uploader.php";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *op = [manager POST:strURL parameters:dictParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"starting");
        [formData appendPartWithFileData:data name:@"file0" fileName:@"fileasdf.jpg" mimeType:@"image/jpeg"];
        // [formData appendPartWithFileURL:filePath name:@"image" error:nil];
    }
                                       success:^(AFHTTPRequestOperation *operation, NSString *responseObject) {
                                           NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                                           // NSLog(@"Success: *****%@",response);
                                       }
                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                           NSLog(@"Error: %@ ***** %@", operation.responseString, error);
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
    [ _collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    
    [_collectionView reloadData];
   // NSLog(@"ImageData Count%i",[imagesData count]);
    if ([imagesData count]<7) {
        [choosePhotoBtn setEnabled:TRUE];
    }
}
int subIndexCount=0;
int selectedMainRowindex=0;

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component ==0) {
        return [mainCat count];
    }else if (component==1){
        if (subIndexCount > 0) {
            return subIndexCount;
        }
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* label = (UILabel*)view;
    if (!label){
        label = [[UILabel alloc] init];
        [label setFont:[UIFont  boldSystemFontOfSize:10]];
        /*
        label.backgroundColor = [UIColor lightGrayColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
        label.text = [NSString stringWithFormat:@"  %d", row+1];
        */
        if (component == 0) {
            if ([mainCat count]>0) {
                label.text=  [mainCat objectAtIndex:row];
            }
        }
        else if (component==1){
            if ([pickerJsonData count]>0 && subIndexCount > 0) {
                
                label.text=  [[[[[pickerJsonData objectAtIndex:0]objectAtIndex:selectedMainRowindex]valueForKey:@"subCat"]objectAtIndex:row]valueForKey:@"name"];
                
            }else{
                NSLog(@"SubCat is Empty!");
            }
            
        }
    }
    return label;
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        if ([mainCat count]>0) {
            return  [mainCat objectAtIndex:row];
        }
    }
    else if (component==1){
        if ([pickerJsonData count]>0 && subIndexCount > 0) {
            
         return  [[[[[pickerJsonData objectAtIndex:0]objectAtIndex:selectedMainRowindex]valueForKey:@"subCat"]objectAtIndex:row]valueForKey:@"name"];

        }else{
            NSLog(@"SubCat is Empty!");
        }

    }
    return @"";
}
*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component==0){
        
        if ([pickerJsonData count] > 0) {

            subIndexCount = [[[[pickerJsonData objectAtIndex:0]objectAtIndex:row]valueForKey:@"subCat"]count];
            NSLog(@"sub index count%i",subIndexCount);
            selectedMainRowindex = row;
            NSLog(@"selected index: %i",selectedMainRowindex);
             [_pickerCategories reloadComponent:1];
        }
        

        
    }else if(component ==1){

        }
}
-(void)loadPickerViewData{
    
    NSLog(@"loading...");
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://serv01.vm1692.sgvps.net/~karasi/sale/UiPickerDataIOS.php?tag=getAllCat"];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
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
                        id json = jsonObject;
                         [activityIndicator stopAnimating];
                         [pickerJsonData addObject:[json objectForKey:@"MainCat"]];
                         
                         
                         //NSLog(@"jsonObject: %@", [json objectForKey:@"MainCat"]);
                         mainCat= [[NSMutableArray alloc]init];
                         
                         for (int i =0 ; i<= [json count]+1; i++) {
                             [mainCat addObject: [[[json objectForKey:@"MainCat"]objectAtIndex:i]objectForKey:@"name"]];
                         }
                         // set defualt index to first row of categories
                         subIndexCount =  [[[[pickerJsonData objectAtIndex:0]valueForKey:@"subCat"]objectAtIndex:0]count];
                         
                         [_pickerCategories reloadAllComponents];
                         [_pickerCategories reloadComponent:0];
                         
                         
                         
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
