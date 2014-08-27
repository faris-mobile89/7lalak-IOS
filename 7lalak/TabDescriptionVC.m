//
//  TabDescriptionVC.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabDescriptionVC.h"
#import "UIImageView+WebCache.h"
#import "UIColor_hex.h"
#import "LocalizeHelper.h"
#import "Localization.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f


@interface TabDescriptionVC (){
    NSString *lang;
}
@property (strong,nonatomic) NSMutableArray *jsonObjects;
@end

@implementation TabDescriptionVC
@synthesize jsonObject;
@synthesize fPrice,fDate,fDescription,fImage,fPhone;
@synthesize jsonObjects;

-(void)viewDidLayoutSubviews{
    
    BOOL IS_4S = IS_HEIGHT_4S;
    if (!IS_4S) {
        [fDescription setFrame:CGRectMake(fDescription.frame.origin.x, fDescription.frame.origin.y,fDescription.frame.size.width, fDescription.frame.size.height+70)];
    }
    [_label_views setText:LocalizedString(@"VIEWS")];
    
    lang = [[NSString alloc]init];
    lang = [[Localization sharedInstance]getPreferredLanguage];
    
    fImage.layer.cornerRadius=6;
    fImage.layer.borderWidth=1.0;
    fImage.layer.masksToBounds = YES;
    fImage.clipsToBounds = YES;
    fImage.layer.borderColor=[[UIColor colorWithHexString:@"CCCCCC"] CGColor];
    
    fDescription.layer.cornerRadius=6;
    fDescription.layer.borderWidth=0.3;
    fDescription.clipsToBounds = YES;
    fDescription.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    
    //=========== Custom Fav Button ==========//
    _btnFav1.layer.cornerRadius=6;
    _btnFav1.layer.borderWidth=1;
    //_btnFav1.clipsToBounds = YES;
    _btnFav1.layer.borderColor=[[UIColor blueColor] CGColor];
    [_btnFav1 setTitle:LocalizedString(@"Add_To_Fav") forState:UIControlStateNormal];
    
    //=========== Custom Call Button ==========//
    _btnCall.layer.cornerRadius=6;
    _btnCall.layer.borderWidth=1;
    _btnCall.clipsToBounds = YES;
    _btnCall.layer.borderColor=[[UIColor blueColor] CGColor];
    [_btnCall setTitle:LocalizedString(@"Call_Button") forState:UIControlStateNormal];
    
    //=========== Custom Message Button ==========//
    _btnMessage.layer.cornerRadius=6;
    _btnMessage.layer.borderWidth=1;
    _btnMessage.clipsToBounds = YES;
    _btnMessage.layer.borderColor=[[UIColor blueColor] CGColor];
    [_btnMessage setTitle:LocalizedString(@"Message_BTN") forState:UIControlStateNormal];
    //=========================================//
    
    [fPhone setText:[jsonObject objectForKey:@"phone"]];
    
    NSString *price= [[NSString alloc]initWithFormat:@"%@ %@",[jsonObject objectForKey:@"price"],LocalizedString(@"KWD")];
    
    [fPrice setText:price];
    
    [fDescription setText:[jsonObject objectForKey:@"description"]];
    [fDate setText:[jsonObject objectForKey:@"created"]];
    [_numberOfViews setText:[jsonObject objectForKey:@"views"]];
    [fImage sd_setImageWithURL:[NSURL URLWithString:[jsonObject objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"iTunesArtwork.png"]];
    
    NSString * status = [jsonObject objectForKey:@"status"];
    
    if ([status isEqualToString: @"2"]){
        if ([lang isEqualToString:@"ar"]) {
            
            [_imgSoldFlag setImage:[UIImage imageNamed:@"ic_sold_flag_ar.png"]];
        }else{
            [_imgSoldFlag setImage:[UIImage imageNamed:@"ic_sold_flag.png"]];
        }
    }else
        [_imgSoldFlag setImage:nil];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)btnFavClick:(id)sender {
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Fav.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"Fav" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    if ([[NSMutableArray alloc]initWithContentsOfFile:path]==nil) {
       jsonObjects = [[NSMutableArray alloc]init];
    }else{
       jsonObjects =[[NSMutableArray alloc]initWithContentsOfFile:path];
    }
    
    [jsonObjects addObject:jsonObject];
    [jsonObjects writeToFile:path atomically:YES];
    
    
    [_btnFav1 setEnabled:FALSE];
    [_btnFav1 setBackgroundColor:[UIColor orangeColor]];
    _btnFav1.layer.borderColor=[[UIColor grayColor] CGColor];
    
}

- (IBAction)btnCallClick:(id)sender {
    
    NSString *phNo = fPhone.text;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView * calert = [[UIAlertView alloc]initWithTitle:LocalizedString(@"ALERT") message:LocalizedString(@"CALL_Unavailable") delegate:nil cancelButtonTitle:LocalizedString(@"OK") otherButtonTitles:nil, nil];
        [calert show];
    }
}

- (IBAction)btnMessageClick:(id)sender {
    
    MFMessageComposeViewController *messageInstance = [[MFMessageComposeViewController alloc]init];
    if ([MFMessageComposeViewController canSendText]) {
        messageInstance.body = @"";
        messageInstance.recipients = [NSArray arrayWithObjects:fPhone.text,nil];
        messageInstance.messageComposeDelegate = self;
        [self presentViewController:messageInstance animated:YES completion:nil];
    }
}

- (IBAction)btnWhatsappClick:(id)sender {
    
    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=hi%20faris!"];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
