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
@class PhysicsSprite;

@class MuzzleFlashEffect;

typedef enum {
    AssassinCarNodeLeftFlashEffect,
    AssassinCarNodeRightFlashEffect,
} AssassinCarNodeTags;

@interface AssassinCar : CCNode {
    PhysicsSprite *sprite;
    CGPoint nextPosition;
    bool gunsFiring;
    MuzzleFlashEffect *leftFlashEffect;
    MuzzleFlashEffect *rightFlashEffect;
    bool swerving;
}

@property(nonatomic) CGPoint velocity;
@property(nonatomic) CGPoint position;

-(void) addToLocation:(CGPoint)difference;
-(void) fireMachineGun;
-(void) stopMachineGun;
-(void) steerCorrectively;
@end
