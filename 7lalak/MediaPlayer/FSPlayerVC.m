/*
 * This file is part of the FreeStreamer project,
 * (C)Copyright 2011-2014 Matias Muhonen <mmu@iki.fi>
 * See the file ''LICENSE'' for using the code.
 *
 * https://github.com/muhku/FreeStreamer
 */

#import "FSPlayerVC.h"
#import "FSAudioStream.h"
#import "FSAudioController.h"
#import "FSPlaylistItem.h"
#import "AJNotificationView.h"
#import "PlayListPicker1.h"
#import "UIColor_hex.h"
#import "PlayList.h"
#import "LocalizeHelper.h"

#define IS_HEIGHT_4S [[UIScreen mainScreen ] bounds].size.height < 568.0f

@interface FSPlayerVC ()

- (void)clearStatus;
- (void)showStatus:(NSString *)status;
- (void)showErrorStatus:(NSString *)status;
- (void)updatePlaybackProgress;
- (void)seekToNewTime;
- (void)determineStationNameWithMetaData:(NSDictionary *)metaData;

@property (strong,nonatomic) NSMutableArray *PlayListData;
@end

@implementation FSPlayerVC
@synthesize PlayListData;

bool flagIsSelectedPlayList= false;
bool flagIsPlaying= false;
int playingCurrentIndex=0;

/*
 * =======================================
 * View control
 * =======================================
 */

-(void)set4SFrame{
    
    _ios5View.frame = CGRectMake(0, 365, 320, 88);
    
}

-(void)viewDidLayoutSubviews{
    
    BOOL IS_4S = IS_HEIGHT_4S;
    _holder.layer.cornerRadius = 18;
    if (IS_4S) {
        
        [self set4SFrame];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 70000)
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent
                                                animated:NO];
#else
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque
                                                animated:NO];
#endif
    
    /*
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBarHidden = NO;
    
    _stationURL = nil;
    self.navigationItem.rightBarButtonItem = nil;
    */
    
  //  UINavigationController *favNav = [[UINavigationController alloc]
                                     // initWithRootViewController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    //NSLog(@"back");
/*
    if (_shouldStartPlaying) {
        _shouldStartPlaying = NO;
        [self.audioController play];
        [_playButton setHidden:FALSE];
    }
 */

    if ([[PlayList sharedPlayList]getItems] != nil && flagIsPlaying == false) {
        
      //  NSLog(@"Shared Objects: %@",[[PlayList sharedPlayList]getItems]);
        
        flagIsSelectedPlayList = true;
        PlayListData = [[PlayList sharedPlayList]getItems];
        playingCurrentIndex = [[PlayList sharedPlayList]getPickedIndex];
        
      //  NSLog(@"object at %@",[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"url"]);
       
        
        FSPlaylistItem *item = [[FSPlaylistItem alloc]init];
        [item setTitle:[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"name"]];
        [item setOriginatingUrl:[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"url"]];
        [self setSelectedPlaylistItem:item];
        [self play:self];
        flagIsPlaying = true;
    }
    
   
    
     [_playButton setHidden:FALSE];
    
    /*
     [item setOriginatingUrl:@"http://download.media.islamway.net/several/anasheed/ILoveGod.mp3"];
     [self setSelectedPlaylistItem:item];
     */
  
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self becomeFirstResponder];
    
    _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                            target:self
                                                          selector:@selector(updatePlaybackProgress)
                                                          userInfo:nil
                                                           repeats:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"004557"]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamStateDidChange:)
                                                 name:FSAudioStreamStateChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamErrorOccurred:)
                                                 name:FSAudioStreamErrorNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioStreamMetaDataAvailable:)
                                                 name:FSAudioStreamMetaDataNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    // Hide the buttons as we display them based on the playback status (callback)
    self.playButton.hidden = YES;
    self.pauseButton.hidden = YES;
    
    _infoButton = self.navigationItem.rightBarButtonItem;
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
     */
}

- (void)viewDidDisappear:(BOOL)animated
{
    /*
    [super viewDidDisappear:animated];
    
    // Free the resources (audio queue, etc.)
    _audioController = nil;
    
    if (_progressUpdateTimer) {
        [_progressUpdateTimer invalidate], _progressUpdateTimer = nil;
    }
     */
}

/*
 * =======================================
 * Observers
 * =======================================
 */

- (void)audioStreamStateDidChange:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int state = [[dict valueForKey:FSAudioStreamNotificationKey_State] intValue];
    switch (state) {
        case kFsAudioStreamRetrievingURL:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            [self showStatus:@"Retrieving URL..."];
            
            self.statusLabel.text = @"";
            
            self.progressSlider.enabled = NO;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
            _paused = NO;
            break;
            
        case kFsAudioStreamStopped:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            self.statusLabel.text = @"";
            
            self.progressSlider.enabled = NO;
            self.playButton.hidden = NO;
            self.pauseButton.hidden = YES;
            _paused = NO;
            break;
            
        case kFsAudioStreamBuffering:
            [self showStatus:@"Buffering..."];

            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            self.progressSlider.enabled = NO;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
            _paused = NO;
            break;
            
        case kFsAudioStreamSeeking:
            [self showStatus:@"Seeking..."];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            self.progressSlider.enabled = NO;
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
            _paused = NO;
            break;
            
        case kFsAudioStreamPlaying:
            [self determineStationNameWithMetaData:nil];
            
            [self clearStatus];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            self.progressSlider.enabled = YES;
            
            if (!_progressUpdateTimer) {
                _progressUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                        target:self
                                                                      selector:@selector(updatePlaybackProgress)
                                                                      userInfo:nil
                                                                       repeats:YES];
            }
            
            self.playButton.hidden = YES;
            self.pauseButton.hidden = NO;
            _paused = NO;
            
            break;
            
        case kFsAudioStreamFailed:
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.progressSlider.enabled = NO;
            self.playButton.hidden = NO;
            self.pauseButton.hidden = YES;
            _paused = NO;
            break;
    }
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPause: /* FALLTHROUGH */
            case UIEventSubtypeRemoteControlPlay:  /* FALLTHROUGH */
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if (_paused) {
                    [self play:self];
                } else {
                    [self pause:self];
                }
                break;
            default:
                break;
        }
    }
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification
{
}

- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification
{
}

- (void)audioStreamErrorOccurred:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    int errorCode = [[dict valueForKey:FSAudioStreamNotificationKey_Error] intValue];
    
    NSString *errorDescription;
    
    switch (errorCode) {
        case kFsAudioStreamErrorOpen:
            errorDescription = @"Cannot open the audio stream";
            break;
        case kFsAudioStreamErrorStreamParse:
            errorDescription = @"Cannot read the audio stream";
            break;
        case kFsAudioStreamErrorNetwork:
            errorDescription = @"Network failed: cannot play the audio stream";
            break;
        case kFsAudioStreamErrorUnsupportedFormat:
            errorDescription = @"Unsupported format";
            break;
        case kFsAudioStreamErrorStreamBouncing:
            errorDescription = @"Network failed: cannot get enough data to play";
            break;
        default:
            errorDescription = @"Unknown error occurred";
            break;
    }
    
    [self showErrorStatus:errorDescription];
}

- (void)audioStreamMetaDataAvailable:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    NSDictionary *metaData = [dict valueForKey:FSAudioStreamNotificationKey_MetaData];
    
    NSMutableString *streamInfo = [[NSMutableString alloc] init];
    
    [self determineStationNameWithMetaData:metaData];
    
    if (metaData[@"MPMediaItemPropertyArtist"] &&
        metaData[@"MPMediaItemPropertyTitle"]) {
        [streamInfo appendString:metaData[@"MPMediaItemPropertyArtist"]];
        [streamInfo appendString:@" - "];
        [streamInfo appendString:metaData[@"MPMediaItemPropertyTitle"]];
    } else if (metaData[@"StreamTitle"]) {
        [streamInfo appendString:metaData[@"StreamTitle"]];
    }
    
    if (metaData[@"StreamUrl"] && [metaData[@"StreamUrl"] length] > 0) {
        _stationURL = [NSURL URLWithString:metaData[@"StreamUrl"]];
        
        self.navigationItem.rightBarButtonItem = _infoButton;
    }
    
    [_statusLabel setHidden:NO];
    self.statusLabel.text = streamInfo;
}

/*
 * =======================================
 * Stream control
 * =======================================
 */

- (IBAction)play:(id)sender
{
  
    if (flagIsSelectedPlayList == FALSE) {
        [self showMessage:LocalizedString(@"PLEASE_SELECT_PLAYLIST")];
        return;
    }
    
    if (_paused) {
        /*
         * If we are paused, call pause again to unpause so
         * that the stream playback will continue.
         */
        [self.audioController pause];
        _paused = NO;
    } else {
        /*
         * Not paused, just directly call play.
         */
        [self.audioController play];
    }
    
    self.playButton.hidden = YES;
    self.pauseButton.hidden = NO;
}

- (IBAction)pause:(id)sender
{
    [self.audioController pause];
    
    _paused = YES;
    
    self.playButton.hidden = NO;
    self.pauseButton.hidden = YES;
}

- (IBAction)seek:(id)sender
{
    _seekToPoint = self.progressSlider.value;
    
    [_progressUpdateTimer invalidate], _progressUpdateTimer = nil;
    
    [_playbackSeekTimer invalidate], _playbackSeekTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                                           target:self
                                                                                         selector:@selector(seekToNewTime)
                                                                                           userInfo:nil
                                                                                            repeats:NO];
}

- (IBAction)openStationUrl:(id)sender
{

    [[UIApplication sharedApplication] openURL:_stationURL];
}

/*
 * =======================================
 * Properties
 * =======================================
 */

- (void)setSelectedPlaylistItem:(FSPlaylistItem *)selectedPlaylistItem
{
   
    if (_selectedPlaylistItem == selectedPlaylistItem) {
        return;
    }
    
    _selectedPlaylistItem = selectedPlaylistItem;
    
    self.navigationItem.title = self.selectedPlaylistItem.title;
    
    self.audioController.url = self.selectedPlaylistItem.nsURL;
}

- (FSPlaylistItem *)selectedPlaylistItem
{
    return _selectedPlaylistItem;
}

- (FSAudioController *)audioController
{
    if (!_audioController) {
        _audioController = [[FSAudioController alloc] init];
        
    }
    return _audioController;
}

/*
 * =======================================
 * Private
 * =======================================
 */

- (void)clearStatus
{
    [AJNotificationView hideCurrentNotificationViewAndClearQueue];
}

- (void)showStatus:(NSString *)status
{
    [self clearStatus];
    
    [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                    type:AJNotificationTypeDefault
                                   title:status
                         linedBackground:AJLinedBackgroundTypeAnimated
                               hideAfter:0];
}

- (void)showErrorStatus:(NSString *)status
{
    [self clearStatus];
    
    [AJNotificationView showNoticeInView:[[[UIApplication sharedApplication] delegate] window]
                                    type:AJNotificationTypeRed
                                   title:status
                               hideAfter:10];
}

- (void)updatePlaybackProgress
{
    if (self.audioController.stream.continuous) {
        self.progressSlider.enabled = NO;
        self.progressSlider.value = 0;
        self.currentPlaybackTime.text = @"";
    } else {
        double s = self.audioController.stream.currentTimePlayed.minute * 60 + self.audioController.stream.currentTimePlayed.second;
        double e = self.audioController.stream.duration.minute * 60 + self.audioController.stream.duration.second;
        
        self.progressSlider.enabled = YES;
        self.progressSlider.value = s / e;
        
        FSStreamPosition cur = self.audioController.stream.currentTimePlayed;
        FSStreamPosition end = self.audioController.stream.duration;
        
        self.currentPlaybackTime.text = [NSString stringWithFormat:@"%i:%02i / %i:%02i",
                                         cur.minute, cur.second,
                                         end.minute, end.second];
    }
}

- (void)seekToNewTime
{
    self.progressSlider.enabled = NO;
    
    unsigned u = (self.audioController.stream.duration.minute * 60 + self.audioController.stream.duration.second) * _seekToPoint;
    
    unsigned s,m;
    
    s = u % 60, u /= 60;
    m = u;
    
    FSStreamPosition pos;
    pos.minute = m;
    pos.second = s;
    
    [self.audioController.stream seekToPosition:pos];
}

- (void)determineStationNameWithMetaData:(NSDictionary *)metaData
{
    if (metaData[@"IcecastStationName"] && [metaData[@"IcecastStationName"] length] > 0) {
        self.navigationController.navigationBar.topItem.title = metaData[@"IcecastStationName"];
    } else {
        FSPlaylistItem *playlistItem = self.audioController.currentPlaylistItem;
        NSString *title = playlistItem.title;
        
        if ([playlistItem.title length] > 0) {
            self.navigationController.navigationBar.topItem.title = title;
        } else {
            /* The last resort - use the URL as the title, if available */
            if (metaData[@"StreamUrl"] && [metaData[@"StreamUrl"] length] > 0) {
                self.navigationController.navigationBar.topItem.title = metaData[@"StreamUrl"];
            }
        }
    }
}

- (IBAction)btnPlayListPicker:(id)sender {
    
    //PlayListPicker1 *picker= [[PlayListPicker1 alloc]init];
    [self  performSegueWithIdentifier:@"pick" sender:nil];
    flagIsPlaying =false;
    
}

-(void)showMessage: (NSString*)msg{
    
    UIAlertView *internetError = [[UIAlertView alloc] initWithTitle: nil message:msg delegate: self cancelButtonTitle: LocalizedString(@"Ok") otherButtonTitles: nil];
    
    [internetError show];
    
}


- (IBAction)btnNext:(id)sender {
    
    if ([[PlayList sharedPlayList]getItems]!=nil) {
        

        
        
        NSLog(@"cont %i",playingCurrentIndex);
        
        int temp = playingCurrentIndex + 1;
        
        if (temp >  [PlayListData count]-1) {
            
            [_next setEnabled:FALSE];
            return;
            
        }
        
        playingCurrentIndex++;
        [_back setEnabled:TRUE];
        FSPlaylistItem *item = [[FSPlaylistItem alloc]init];
        [item setTitle:[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"name"]];
        [item setOriginatingUrl:[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"url"]];
        [self setSelectedPlaylistItem:item];
        [self play:self];
        flagIsPlaying = true;
        flagIsSelectedPlayList = true;

        
     
    }

}

- (IBAction)btnBack:(id)sender {
    if ([[PlayList sharedPlayList]getItems]!=nil) {
        
        
        
        if (playingCurrentIndex <  1 ) {
            [_back setEnabled:FALSE];
            return;
        }
        playingCurrentIndex--;
        [_next setEnabled:TRUE];

        FSPlaylistItem *item = [[FSPlaylistItem alloc]init];
        [item setTitle:[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"name"]];
        [item setOriginatingUrl:[[PlayListData objectAtIndex:playingCurrentIndex]valueForKey:@"url"]];
        [self setSelectedPlaylistItem:item];
        [self play:self];
        flagIsPlaying = true;
        flagIsSelectedPlayList = true;
        
    }
    
}

- (IBAction)btnNextProgress:(id)sender {
    

    
}

- (IBAction)btnBackProgress:(id)sender {
    
    }


@end