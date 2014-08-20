//
//  AddMoreImagesVC.m
//  7lalak
//
//  Created by Faris IOS on 8/19/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "AddMoreImagesVC.h"
#import "LocalizeHelper.h"
#import "UploadCell.h"
#import "MyAdDetails.h"

@interface AddMoreImagesVC ()

@end

@implementation AddMoreImagesVC
@synthesize imagesData;

-(NSMutableArray *)didDoneClick:(NSMutableArray *)data{

    if (self.delegate) {
        [self.delegate didDoneClick:data];
    }
    return data;
}

- (void)viewDidLoad{
    [super viewDidLoad];
   // imagesData = [[NSMutableArray alloc]init];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
    [_collectionView registerNib:[UINib nibWithNibName:@"UploadCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_add_image setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    //NSLog(@"number = %i",_numberOfAllowedImage);
    //NSLog(@"attachedImages%@",imagesData);
    
    if ([imagesData count]>_numberOfAllowedImage-1) {
        
        [_add_image setEnabled:FALSE];
    }
}



- (IBAction)doneBtn:(id)sender {
    [self didDoneClick:imagesData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addImage:(id)sender {
    
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
    UIImageView *imageView= [[UIImageView alloc]init];
    
    imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    
    [imagesData addObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    
    
    [_collectionView reloadData];
    if ([imagesData count]>_numberOfAllowedImage-1) {
        
        [_add_image setEnabled:FALSE];
    }
    
    NSLog(@"imagesData:%@",imagesData);
    
}
#pragma mark images slider view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([imagesData count]) {
        return [imagesData count];
    }
    return 0;
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
    
    if ([imagesData count]<_numberOfAllowedImage) {
        [_add_image setEnabled:TRUE];
    }else{
        [_add_image setEnabled:FALSE];}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
