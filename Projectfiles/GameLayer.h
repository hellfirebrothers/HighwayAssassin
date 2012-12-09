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

typedef enum
{
    CP_LAYER_1 = 0xf0000000,
    CP_LAYER_2 = 0x0f000000,
    CP_LAYER_3 = 0x00f00000,
    CP_LAYER_4 = 0x000f0000,
    CP_LAYER_5 = 0x0000f000,
    CP_LAYER_6 = 0x00000f00,
    CP_LAYER_7 = 0x000000f0,
    CP_LAYER_8 = 0x0000000f,
} PhysicsLayers;

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
