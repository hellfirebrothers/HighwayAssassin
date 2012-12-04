//
//  GameScene.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12.02.12
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class ScrollingBackground;

typedef enum
{
	GameSceneNodeScrollingBackground,
    GameSceneNodeControlsLayer,
    GameSceneNodeAssassinCar,
    GameSceneNodeMax
} GameSceneNodeTags;

@interface GameLayer : CCLayer 
{
    CGPoint lastTouchLocation;
    ScrollingBackground *background;
    bool readyForTouch;
    
}

+(id) scene;
+(GameLayer*) sharedGameLayer;
-(BOOL) isTouchForMe:(CGPoint)touchLocation;
@end
