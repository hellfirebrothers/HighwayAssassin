//
//  AssassinCar.h
//  HighwayAssassin
//
//  Created by Max on 12/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@class MuzzleFlashEffect;

typedef enum {
    AssassinCarNodeLeftFlashEffect,
    AssassinCarNodeRightFlashEffect,
} AssassinCarNodeTags;

@interface AssassinCar : CCNode {
    CCSprite *sprite;
    CGPoint nextPosition;
    bool gunsFiring;
    MuzzleFlashEffect *leftFlashEffect;
    MuzzleFlashEffect *rightFlashEffect;
    cpBody *body;
}

@property CGPoint velocity;
-(void) addToLocation:(CGPoint)difference;
-(void) fireMachineGun;
-(void) stopMachineGun;
-(void) syncSpriteWithBody;
@end
