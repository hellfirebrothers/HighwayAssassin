//
//  TileMapLayer.m
//  
//
//  Created by Alexander Woods on 12/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TileMapBackground.h"


@implementation TileMapBackground

-(id) init
{
    if ((self = [super init]))
    {
        CCTMXTiledMap *tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        // position and leave room for the control panel
        tileMap.position = ccp(0, windowSize.height / 5);
        [self addChild:tileMap z:-1 tag:TileMapNode];
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) update:(ccTime)delta
{
    CCTMXTiledMap *map = (CCTMXTiledMap *)[self getChildByTag:TileMapNode];
    float scrollSpeed = 200;
    CGPoint pos = map.position;
    pos.x -= scrollSpeed * delta;
    map.position = pos;
}


@end