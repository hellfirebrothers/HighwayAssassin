//
//  GameScene.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12.02.12
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@class TileMapBackground;

typedef enum
{
	GameSceneNodeTileMapBackground,
    GameSceneNodeControlsLayer,
    GameSceneNodeAssassinCar,
    GameSceneNodeMax
} GameSceneNodeTags;

@interface GameLayer : CCLayer 
{
    CGPoint lastTouchLocation;
    TileMapBackground *background;
    bool readyForTouch;
    cpShape *walls[4];
}

@property cpSpace *space;

+(id) scene;
+(GameLayer*) sharedGameLayer;
-(BOOL) isTouchForMe:(CGPoint)touchLocation;
-(void) initPhysics;
void updateBodies(cpBody *body, void *data);
@end
