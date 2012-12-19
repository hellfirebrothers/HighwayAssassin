//
//  TileMapLayer.m
//  
//
//  Created by Alexander Woods on 12/7/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "TileMapBackground.h"
#import "GameLayer.h"
#import "Enemy.h"
#define ENEMIES 1

@implementation TileMapBackground

-(id) init
{
    if ((self = [super init]))
    {
        tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"tilemap.tmx"];
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        // position and leave room for the control panel
        tileMap.position = ccp(0, windowSize.height / 5);
        [self addChild:tileMap z:-1 tag:TileMapNode];
        eventLayer= [tileMap layerNamed:@"GameEvents"];
        eventLayer.visible = NO;
        currentTileColumn = 0;
        [self scrollBackground];
        
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) scrollBackground
{
    float tileWidth = tileMap.tileSize.width;
    // Speed of 5 tiles/sec
    id actionMoveMap = [CCMoveBy actionWithDuration:.2f position:ccp(-tileWidth, 0)];
    id actionCheckTile = [CCCallFunc actionWithTarget:self selector:@selector(checkTile)];
    id actionSequence = [CCSequence actions:actionMoveMap, actionCheckTile, nil];
    id action = [CCRepeatForever actionWithAction:actionSequence];
    [tileMap runAction:action];
}

-(void) checkTile
{
    if (ENEMIES) {
        currentTileColumn++;
        for (int i = 0; i < 8; i++) {
            int currentGID = [eventLayer tileGIDAt:ccp(currentTileColumn, i)];
            if (currentGID)
            {
                [self handleEventTile:currentGID];
            }
        }
    }
}

-(void) handleEventTile:(int)GID
{
    NSDictionary *properties = [tileMap propertiesForGID:GID];
    NSNumber *value = [properties valueForKey:@"enemyType"];
    if (value.intValue == 0) {
        [Enemy spawnEnemyOfType:EnemyTypeGeneric];
    }
    if (value.intValue == 1) {
        [Enemy spawnEnemyOfType:EnemyTypePolice];
    }
}

-(void) update:(ccTime)delta
{
}


@end