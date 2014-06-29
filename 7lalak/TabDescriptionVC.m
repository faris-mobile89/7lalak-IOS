//
//  TabDescriptionVC.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabDescriptionVC.h"
#import "UIImageView+WebCache.h"


@interface TabDescriptionVC ()
@property (strong,nonatomic) NSMutableArray *jsonObjects;
@end

@implementation TabDescriptionVC
@synthesize jsonObject;
@synthesize fPrice,fDate,fDescription,fImage,fPhone;
@synthesize jsonObjects;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [fPhone setText:[jsonObject objectForKey:@"phone"]];
    [fPrice setText:[jsonObject objectForKey:@"price"]];
    [fDescription setText:[jsonObject objectForKey:@"description"]];
    [fDate setText:[jsonObject objectForKey:@"created"]];
    
    [fImage sd_setImageWithURL:[NSURL URLWithString:[jsonObject objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"ic_defualt_image.png"]];

   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)btnFavClick:(id)sender {
    
   // NSLog(@"JSONObject%@",jsonObject);
    
    _btnFav1.hidden = TRUE;
    
    
    
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
    
    NSLog(@"path%@",path);
    
    NSLog(@"plist:%@",[[NSMutableArray alloc]initWithContentsOfFile:path]);
    
}

- (IBAction)btnCallClick:(id)sender {
    NSString *phNo = fPhone.text;
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else
    {
       UIAlertView * calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
}

- (IBAction)btnMessageClick:(id)sender {
    
    MFMessageComposeViewController *messageInstance = [[MFMessageComposeViewController alloc]init];
    if ([MFMessageComposeViewController canSendText]) {
        messageInstance.body = @"Hello from Shah";
        messageInstance.recipients = [NSArray arrayWithObjects:@"12345678",nil];
        messageInstance.messageComposeDelegate = self;
        [self presentModalViewController:messageInstance animated:YES];
    }
}

- (IBAction)btnWhatsappClick:(id)sender {
    
    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Hello%20World!"];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
