//
//  JSONLoader.h
//
//  Created by Faris on 10/30/13.
//
//

#import <Foundation/Foundation.h>

@interface JSONLoader : NSObject
 @property  (nonatomic,strong) NSDictionary* json,*data;
-(NSDictionary *)loadDataFromURL:(NSString *) url;
-(void) executeInBackground:(NSString *) url;
-(void) executeOnMainThread:(NSString *) url;
@end
