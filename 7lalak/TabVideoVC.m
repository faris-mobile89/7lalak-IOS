//
//  TabVidoeVC.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabVideoVC.h"
#import "VideoCell.h"
#import "LocalizeHelper.h"
#import "UIColor_hex.h"

#define IS_HEIGHT_iPad [[UIScreen mainScreen ] bounds].size.height > 700.0f

@interface TabVideoVC ()

@end

@implementation TabVideoVC
@synthesize moviePlayer;
@synthesize jsonObject;

-(void)viewDidLayoutSubviews{
    
    [_webView setBackgroundColor:[UIColor clearColor]];
    [_webView setOpaque:NO];
    _webView.scrollView.scrollEnabled = NO;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    
    NSString *embedHTML;
    
    embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    }\
    </style>\
    </head><body style=\"margin:0;padding:4\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";

    bool iS_iPad = IS_HEIGHT_iPad;
    
    NSString *html;
    if (iS_iPad) {
        
      html  = [NSString stringWithFormat:embedHTML,[[jsonObject objectForKey:@"vids"]objectAtIndex:0], 750.0, 800.0];
    }else{
    html = [NSString stringWithFormat:embedHTML,[[jsonObject objectForKey:@"vids"]objectAtIndex:0], 307.0, 330.0];

    }
   
    
  
    [_webView loadHTMLString:html baseURL:nil];

}

/*
- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    UIButton *button = [self findButtonInView:_webView];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}
*/

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
