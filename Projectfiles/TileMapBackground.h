//
//  TileMapLayer.h
//  
//
//  Created by Alexander Woods on 12/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum
{
    TileMapNode = 0,
};

@interface TileMapBackground : CCNode {
    CCTMXTiledMap *tileMap;
    CCTMXLayer *eventLayer;
    int currentTileColumn;
}

-(void) scrollBackground;
-(void) checkTile;
-(void) handleEventTile:(int)GID;

@end
