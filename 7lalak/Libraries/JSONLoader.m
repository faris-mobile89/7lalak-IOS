//
//  LoadHotelsJSONData.m
//  Visit Jordan
//
//  Created by Faris on 10/30/13.
//
//

#import "JSONLoader.h"

@implementation JSONLoader{
}
@synthesize json,data;



-(NSDictionary *)loadDataFromURL:(NSString *) url{
    
    
    //[self performSelectorInBackground:@selector(executeInBackground:) withObject:url];
    [self performSelectorOnMainThread:@selector(executeInBackground:) withObject:url waitUntilDone:YES];
    
   

    return json;
    
}

-(void) executeInBackground:(NSString *) url;
{
    NSData* ytData = [NSData dataWithContentsOfURL:
                      [NSURL URLWithString:url]
                      ];

    if (ytData!=Nil) {
        self.json = [NSJSONSerialization
                     JSONObjectWithData:ytData
                     options:kNilOptions
                     error:nil];
    }
    else
        self.json=nil;
}

-(void) executeOnMainThread:(NSString *) url;
{
    NSData* ytData = [NSData dataWithContentsOfURL:
                      [NSURL URLWithString:url]
                      ];
    
    if (ytData!=Nil) {
        self.json = [NSJSONSerialization
                     JSONObjectWithData:ytData
                     options:kNilOptions
                     error:nil];
    }
    else
        self.json=nil;

}

@end
