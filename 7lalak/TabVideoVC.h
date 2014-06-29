//
//  TabVidoeVC.h
//  7lalak
//
//  Created by Faris IOS on 6/23/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface TabVideoVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
   MPMoviePlayerController *moviePlayer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (weak, nonatomic) IBOutlet UIView *videoHolderView;
@property (weak,nonatomic) id jsonObject;
@end