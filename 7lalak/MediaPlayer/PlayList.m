//
//  PlayList.m
//  7lalak
//
//  Created by Faris IOS on 7/28/14.
//  Copyright (c) 2014 Faris Abu Saleem. All rights reserved.
//

#import "PlayList.h"

@implementation PlayList
static PlayList *sharedAlbumItems = nil; // static instance variable
static int pickedIndex;
static NSMutableArray *playListItems;

+(PlayList*)sharedPlayList{
    
    if (sharedAlbumItems == nil) {
        sharedAlbumItems = [[super allocWithZone:NULL]init];
    }
    return sharedAlbumItems;
}


- (id)init {
    if ( (self = [super init]) ) {
        // your custom initialization
    }
    return self;
}
-(NSMutableArray *)getItems{
    return playListItems;
}

-(void)setItems:(NSMutableArray *)items{
    
    playListItems = items;
}

-(int)getPickedIndex{
    return pickedIndex;
}

-(void)setPickedIndex:(int)index{
    pickedIndex = index;
}

// singleton methods
+(id)allocWithZone:(NSZone *)item {
    return [self sharedPlayList];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
