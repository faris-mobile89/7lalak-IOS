//
//  FarisJSONParser.m
//  VistJOrdan New
//
//  Created by Faris on 2/20/14.
//  Copyright (c) 2014 Faris. All rights reserved.
//

#import "FarisJSONParser.h"
#import "InternetConnection.h"
#import "Connection.h"
#import "HUD.h"

@implementation FarisJSONParser
@synthesize json;

-(Boolean)testInternetConcecction{
	if ([Connection isConnected]) {
        return TRUE;
	}
	else {
		UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error"
                                                            message: @"Error connecting to the internet"
                                                            delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
		[someError show];
	}
    return FALSE;
}

-(void)hideHUD
{
    [HUD hideUIBlockingIndicator];
}


-(NSDictionary *)loadJSON_DATA:(NSString *)url delegate:(id /*<UIAlertViewDelegate>*/)delegate {
    
if ([self testInternetConcecction]) {
        
    //[HUD showUIBlockingIndicator];
    //[HUD showUIBlockingIndicatorWithText:@"Loading Ya Faris" withTimeout:1000];
    dispatch_queue_t loadJSON = dispatch_queue_create("Load JSON Feed",NULL);
    
    dispatch_async(loadJSON, ^{
        
        //NSLog(@"loading Started...");

             NSData* ytData = [NSData dataWithContentsOfURL:
                               [NSURL URLWithString:url]
                               ];
 
        
             if (ytData!=Nil) {
                 self.json = [NSJSONSerialization
                              JSONObjectWithData:ytData
                              options:kNilOptions
                              error:nil];
             
             }else{
                 
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Network Error"
                                                                     message: @"Error connecting to the internet"
                                                                    delegate: delegate cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                 [someError show];
                 self.json=nil;
             }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //NSLog(@"JSON:%@",json);
            //NSLog(@"loading finished");
            
            [HUD hideUIBlockingIndicator];
            
        });
        
    });
    
    }
    
    return json;
}

@end
