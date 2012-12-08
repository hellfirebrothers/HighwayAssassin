//
//  GameScene.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12.02.12
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
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
    
}

+(id) scene;
+(GameLayer*) sharedGameLayer;
-(BOOL) isTouchForMe:(CGPoint)touchLocation;
@end
