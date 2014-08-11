//
//  UIColor_hex.m
//  staticTable
//
//  Created by Faris on 11/17/13.
//  Copyright (c) 2013 Faris. All rights reserved.
//


#import "UIColor_Hex.h"
@interface UIColor(HexConverterCategory)

// Takes 0x123456
+ (UIColor *)colorWithHex:(UInt32)color andAlpha:(float)alpha;

@end

@implementation UIColor(HexConverterCategory)

+ (UIColor *)colorWithHex:(UInt32)color andAlpha:(float)alpha
{
    unsigned char r, g, b;
    b = color & 0xFF;
    g = (color >> 8) & 0xFF;
    r = (color >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}

@end

@implementation UIColor(MBCategory)

+ (UIColor *)colorWithHexString:(NSString *)hexStr
{
    float alpha;
    NSString *newHexStr;
    NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"/-_,~^*&\\ "];
    if(![hexStr hasPrefix:@"#"]) hexStr = [NSString stringWithFormat:@"#%@", hexStr];
    if([hexStr rangeOfCharacterFromSet:cSet].location != NSNotFound) {
        
        NSScanner *scn = [NSScanner scannerWithString:hexStr];
        [scn scanUpToCharactersFromSet:cSet intoString:&newHexStr];
        alpha = [[[hexStr componentsSeparatedByCharactersInSet:cSet] lastObject] floatValue];
        
    } else {
        
        newHexStr = hexStr;
        alpha = 1.0f;
        
    }
    
    const char *cStr = [newHexStr cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [UIColor colorWithHex:x andAlpha:alpha];
}
@end