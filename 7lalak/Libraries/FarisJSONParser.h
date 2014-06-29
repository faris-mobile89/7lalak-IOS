//
//  FarisJSONParser.h
//  VistJOrdan New
//
//  Created by Faris on 2/20/14.
//  Copyright (c) 2014 Faris. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FarisJSONParser : NSObject
@property  (nonatomic,strong) NSDictionary* json;
-(NSDictionary *)loadJSON_DATA:(NSString *)url delegate:(id /*<UIAlertViewDelegate>*/)delegate;
@end
