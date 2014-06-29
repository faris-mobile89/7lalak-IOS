//
//  TabVidoeVC.m
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "TabVideoVC.h"

@interface TabVideoVC ()

@end

@implementation TabVideoVC
@synthesize moviePlayer;
@synthesize jsonObject;

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


- (void)viewDidLoad
{
   
//NSURL *url = [NSURL URLWithString:
                //  @"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];
    
      NSURL *url = [NSURL URLWithString:[[jsonObject objectForKey:@"vids"]objectAtIndex:0]];
    
   MPMoviePlayerController * _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
    
    
    NSLog(@"%@",[[jsonObject objectForKey:@"vids"]objectAtIndex:0]);
    /*
    NSURL *url = [NSURL URLWithString:[[jsonObject objectForKey:@"vids"]objectAtIndex:0]];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
   
    /*
    NSURL *movieUrl = [NSURL fileURLWithPath:[[jsonObject objectForKey:@"vids"]objectAtIndex:0]];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    
    player.view.frame = CGRectMake(0, 0, 320, 300);
    
    // Here is where you set the control Style like fullscreen or embedded
    //player.controlStyle = MPMovieControlStyleDefault;
    player.controlStyle = MPMovieControlStyleEmbedded;
    //player.controlStyle = MPMovieControlStyleDefault;
    //player.controlStyle = MPMovieControlStyleFullscreen;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    
    UIView *movieBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    [movieBox setBackgroundColor:[UIColor blackColor]];
    
    [movieBox addSubview:player.view];
    [self.videoHolderView addSubview:movieBox];
    player.scalingMode = MPMovieScalingModeAspectFit;
    
    //player.contentURL = movieUrl;
    
    
    [player play];*/
    
    [super viewDidLoad];
}
-(void)movieFinished{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
