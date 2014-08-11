#ifndef localize
#define localize(key) [[Localization sharedInstance] localizedStringForKey:key]
#endif

@interface Localization : NSObject

@property (nonatomic, retain) NSBundle* fallbackBundle;
@property (nonatomic, retain) NSBundle* preferredBundle;

@property (nonatomic, copy) NSString* fallbackLanguage;
@property (nonatomic, copy) NSString* preferredLanguage;

-(NSString*) localizedStringForKey:(NSString*)key;

-(NSString*) pathForFilename:(NSString*)filename type:(NSString*)type;

+(Localization*)sharedInstance;

-(void) setPreferred:(NSString*)preferred fallback:(NSString*)fallback;
-(NSString *) getPreferredLanguage;

@end