//
//  MediaVC.m
//  7lalak
//
//  Created by Faris IOS on 7/3/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "MediaVC.h"
#import "UIColor_hex.h"
#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface MediaVC ()
{
    
    UIBarButtonItem *mRefresh;
    
    id mTimeObserver;
    
    __block NSMutableArray *itunesPreviewUrls;
}

@end

@implementation MediaVC

@synthesize playButton, pauseButton, nextButton, previousButton, firstButton, secondButton, refreshIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    _holder.layer.cornerRadius = 18;
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];

    
    [self initDefaults];
    
    
    HysteriaPlayer *hysteriaPlayer = [HysteriaPlayer sharedInstance];
    [hysteriaPlayer addDelegate:self];
    
    /*
     Register Handlers of HysteriaPlayer
     All Handlers are optional
     */
    [hysteriaPlayer registerHandlerReadyToPlay:^(HysteriaPlayerReadyToPlay identifier) {
        switch (identifier) {
            case HysteriaPlayerReadyToPlayPlayer:
                // It will be called when Player is ready to play at the first time.
                
                // If you have any UI changes related to Player, should update here.
                
                if ( mTimeObserver == nil ) {
                    mTimeObserver = [hysteriaPlayer addPeriodicTimeObserverForInterval:CMTimeMake(100, 1000)
                                                                                 queue:NULL // main queue
                                                                            usingBlock:^(CMTime time) {
                                                                                float totalSecond = CMTimeGetSeconds(time);
                                                                                int minute = (int)totalSecond / 60;
                                                                                int second = (int)totalSecond % 60;
                                                                                self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minute, second];
                                                                            }];
                }
                
                
                break;
                
            case HysteriaPlayerReadyToPlayCurrentItem:
                // It will be called when current PlayerItem is ready to play.
                
                // HysteriaPlayer will automatic play it, if you don't like this behavior,
                // You can pausePlayerForcibly:YES to stop it.
                break;
            default:
                break;
        }
    }];
    
    [hysteriaPlayer registerHandlerFailed:^(HysteriaPlayerFailed identifier, NSError *error) {
        switch (identifier) {
            case HysteriaPlayerFailedPlayer:
                break;
                
            case HysteriaPlayerFailedCurrentItem:
                // Current Item failed, advanced to next.
                [hysteriaPlayer playNext];
                break;
            default:
                break;
        }
        NSLog(@"%@", [error localizedDescription]);
    }];
    [self playFromServer];
}

-(void)set4SFrame{
    
    _ios5View.frame = CGRectMake(0, 365, 320, 88);
    
}

-(void)viewDidLayoutSubviews{
    
    BOOL IS_4S = IS_HEIGHT_4S;
    if (IS_4S) {
        
        [self set4SFrame];
    }
}

-(BOOL)prefersStatusBarHidden{
    return TRUE;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)hysteriaPlayerCurrentItemChanged:(AVPlayerItem *)item
{
    NSLog(@"current item changed");
}

- (void)hysteriaPlayerCurrentItemPreloaded:(CMTime)time
{
    NSLog(@"current item pre-loaded time: %f", CMTimeGetSeconds(time));
}

- (void)hysteriaPlayerDidReachEnd
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Player did reach end."
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
}

- (void)hysteriaPlayerRateChanged:(BOOL)isPlaying
{
    [self syncPlayPauseButtons];
    NSLog(@"player rate changed");
}



#pragma mark - play from server

- (void)playFromServer
{
    
    HysteriaPlayer *hysteriaPlayer = [HysteriaPlayer sharedInstance];
    
    [hysteriaPlayer removeAllItems];
    
    itunesPreviewUrls = [NSMutableArray array];
    [itunesPreviewUrls addObject:@"http://download.media.islamway.net/several/172/03.mp3"];
    
    [hysteriaPlayer setupSourceGetter:^NSURL *(NSUInteger index) {
        return [NSURL URLWithString:[itunesPreviewUrls objectAtIndex:index]];
    } ItemsCount:[itunesPreviewUrls count]];

    [hysteriaPlayer fetchAndPlayPlayerItem:0];
    [hysteriaPlayer setPlayerRepeatMode:HysteriaPlayerRepeatModeOn];
}

#pragma mark - Async source getter example, advanced usage.
/*
 You need to know counts of items that you playing.
 
 Useful when you have a list of songs but you don't have media links,
 this way could help you access the link (ex. with song.id) and setup your PlayerItem with your async connection.
 
 This example shows how to use asyncSetupSourceGetter:ItemsCount:,
 but in this situation that we had media links already, highly recommend you use setupSourceGetter:ItemsCount: instead.
 */


- (IBAction)play_pause:(id)sender
{
    HysteriaPlayer *hysteriaPlayer = [HysteriaPlayer sharedInstance];
    
    if ([hysteriaPlayer isPlaying])
    {
        [hysteriaPlayer pausePlayerForcibly:YES];
        [hysteriaPlayer pause];
    }else{
        [hysteriaPlayer pausePlayerForcibly:NO];
        [hysteriaPlayer play];
    }
}

- (IBAction)playNext:(id)sender
{
    [[HysteriaPlayer sharedInstance] playNext];
}

- (IBAction)playPreviouse:(id)sender
{
    [[HysteriaPlayer sharedInstance] playPrevious];
}

#pragma mark -
#pragma mark ===========   Additions  =========
#pragma mark -

- (void)initDefaults
{
    mRefresh = [[UIBarButtonItem alloc] initWithCustomView:refreshIndicator];
    [mRefresh setWidth:30];
}

- (void)syncPlayPauseButtons
{
    /*
    HysteriaPlayer *hysteriaPlayer = [HysteriaPlayer sharedInstance];
    
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[toolbar items]];
    switch ([hysteriaPlayer getHysteriaPlayerStatus]) {
        case HysteriaPlayerStatusUnknown:
            [toolbarItems replaceObjectAtIndex:3 withObject:mRefresh];
            break;
        case HysteriaPlayerStatusForcePause:
            [toolbarItems replaceObjectAtIndex:3 withObject:playButton];
            break;
        case HysteriaPlayerStatusBuffering:
            [toolbarItems replaceObjectAtIndex:3 withObject:playButton];
            break;
        case HysteriaPlayerStatusPlaying:
            [toolbarItems replaceObjectAtIndex:3 withObject:pauseButton];
        default:
            break;
    }
     */
}


@end
