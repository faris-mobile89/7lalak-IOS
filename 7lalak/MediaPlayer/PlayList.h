//
//  PlayList.h
//  7lalak
//
//  Created by Faris IOS on 7/28/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayList : NSObject
+(PlayList *)sharedPlayList;
-(NSMutableArray *)getItems;
-(void)setItems:(NSMutableArray *)items;
-(int)getPickedIndex;
-(void)setPickedIndex:(int)index;
-(bool)isPlaying;
@end
