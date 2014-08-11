#import "Localization.h"

@implementation Localization

+(Localization *)sharedInstance
{
    static dispatch_once_t pred;
    static Localization *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Localization alloc] init];
        [shared setPreferred:@"en" fallback:@"ar"];
    });
    return shared;
}

-(void) setPreferred:(NSString*)preferred fallback:(NSString*)fallback {
    self.fallbackLanguage = fallback;
    self.preferredLanguage = preferred;
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:self.fallbackLanguage];
    self.fallbackBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
    bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:self.preferredLanguage];
    self.preferredBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
}
-(NSString *) getPreferredLanguage{
    
    return  self.preferredLanguage;
}

-(NSString*) pathForFilename:(NSString*)filename type:(NSString*)type
{
    NSString *path = [self.preferredBundle pathForResource:filename ofType:type inDirectory:nil forLocalization:self.preferredLanguage];
    if (!path) path = [self.fallbackBundle pathForResource:filename ofType:type inDirectory:nil forLocalization:self.fallbackLanguage];
    if (!path) NSLog(@"Missing file: %@.%@", filename, type);
    return path;
}

-(NSString*) localizedStringForKey:(NSString*)key
{
    NSString* result = nil;
    if (_preferredBundle!=nil) {
        result = [_preferredBundle localizedStringForKey:key value:nil table:nil];
    }
    if (result == nil) {
        result = [_fallbackBundle localizedStringForKey:key value:nil table:nil];
    }
    if (result == nil) {
        result = key;
    }
    return result;
}

@end