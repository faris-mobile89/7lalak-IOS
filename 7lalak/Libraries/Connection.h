#import <Foundation/Foundation.h>  
#import <SystemConfiguration/SystemConfiguration.h>  
#import <netinet/in.h>  
#import <arpa/inet.h>  
#import <netdb.h>  

@interface Connection : NSObject {  
	
}  

+ (BOOL) isConnected;  

@end 