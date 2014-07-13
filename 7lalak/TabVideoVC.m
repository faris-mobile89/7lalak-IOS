//
//  TabVidoeVC.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabVideoVC.h"
#import "VideoCell.h"

@interface TabVideoVC ()

@end

@implementation TabVideoVC
@synthesize moviePlayer;
@synthesize jsonObject;


- (void)viewDidLoad
{
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:nil]forCellReuseIdentifier:@"VideoCell"];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    
   // NSLog(@"%@",[[jsonObject objectForKey:@"vids"]objectAtIndex:0]);
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[jsonObject objectForKey:@"vids"]count];
}


// detecting the play button on the you tube video thumbnail

- (UIButton *)findButtonInView:(UIView *)view {
    UIButton *button = nil;
    
    if ([view isMemberOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    
    if (view.subviews && [view.subviews count] > 0) {
        for (UIView *subview in view.subviews) {
            button = [self findButtonInView:subview];
            if (button) return button;
        }
    }
    
    return button;
}


- (void)webViewDidFinishLoad:(UIWebView *)_webView {
    UIButton *button = [self findButtonInView:_webView];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 130;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     VideoCell *cell = (VideoCell *)[tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    [cell.fWebView setBackgroundColor:[UIColor clearColor]];
    [cell.fWebView setOpaque:NO];
    cell.fWebView.scrollView.scrollEnabled = NO;

    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new] ;
    cell.selectedBackgroundView = [UIView new];
    
    cell.fVideoTitle.text=[[NSString alloc]initWithFormat:@"Video %li",indexPath.row+1];

    //UIWebView  *wbView = (UIWebView *)[cell.contentView viewWithTag:1];
    NSString *embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    NSString *html = [NSString stringWithFormat:embedHTML,[[jsonObject objectForKey:@"vids"]objectAtIndex:indexPath.row], 126.0, 109.0];
    [cell.fWebView loadHTMLString:html baseURL:nil];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [ _tableView cellForRowAtIndexPath:indexPath];
    
    UIWebView  *wbView = (UIWebView *)[cell.contentView viewWithTag:1];
    UIButton *btn = [self findButtonInView:wbView];
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
    
}


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
