//
//  AssassinCar.m
//  HighwayAssassin
//
//  Created by Max on 12/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AssassinCar.h"
#import "MuzzleFlashEffect.h"
#import "GameLayer.h"
#import "PhysicsSprite.h"
#import "Bullet.h"

@implementation AssassinCar

-(AssassinCar *) init
{
    if (self = [super init]) {
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:@"car.png"];
        sprite = [PhysicsSprite spriteWithSpriteFrame:spriteFrame mass:2.0f];
        [self addChild:sprite];
        CGSize carSize = sprite.contentSize;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Place it on the middle-left side of the window for now.
        CGPoint pos = ccp(carSize.width / 2, screenSize.height / 2);
        sprite.position = pos;
        nextPosition = sprite.position;
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) addToLocation:(CGPoint)difference
{
    // Change this to make the "push/pull" more or less effective
    int impulseMultiplier = 5;
    
    CGPoint impulseVect = ccpMult(difference, impulseMultiplier);
    cpBodyApplyImpulse(sprite.body, impulseVect, CGPointZero);
}

-(void) fireMachineGun {
    // Add a flash effect on each side of the front of the car to simulate
    // machine gun fire
    leftFlashEffect = [MuzzleFlashEffect node];
    CGPoint leftFirePosition = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                           sprite.position.y + sprite.contentSize.height / 4);
    leftFlashEffect.position = leftFirePosition;
    [sprite addChild:leftFlashEffect z:0];
    [self startFiringBulletsFromPosition:leftFirePosition];
    
    rightFlashEffect = [MuzzleFlashEffect node];
    CGPoint rightFirePosition = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                           sprite.position.y - sprite.contentSize.height / 4);
    
    rightFlashEffect.position = rightFirePosition;
    [sprite addChild:rightFlashEffect z:0];
    [self startFiringBulletsFromPosition:rightFirePosition];
}

-(void) startFiringBulletsFromPosition:(CGPoint)position
{
    Bullet *bullet = [Bullet node];
    [self addChild:bullet z:5];
    [bullet fireFromPosition:position withRotation:sprite.rotation];
}

-(void) stopMachineGun {
    [leftFlashEffect removeFromParentAndCleanup:YES];
    [rightFlashEffect removeFromParentAndCleanup:YES];
    
    // Make sure these are nil for the update check
    leftFlashEffect = nil;
    rightFlashEffect = nil;
}

-(void) update:(ccTime)delta
{
    cpFloat rotationMagnitude = abs(sprite.rotation);
    
    // simulate corrective steering if past an arbitrary angle
    if (rotationMagnitude > 10 && swerving == NO) {
        swerving = YES;
        [self steerCorrectively];
        cpBodySetAngVel(sprite.body, 0);
    }
    
    // TODO: make this less verbose/more efficient
    leftFlashEffect.position = CGPointMake(sprite.contentSize.width,
                                           sprite.contentSize.height * .25f);
    rightFlashEffect.position = CGPointMake(sprite.contentSize.width,
                                            sprite.contentSize.height * .75f);
}

-(void) steerCorrectively
{
    float swerveAngle = -CC_RADIANS_TO_DEGREES(cpBodyGetAngVel(sprite.body)) * .5f;
    id swerveUp = [CCRotateTo actionWithDuration:.25f angle:swerveAngle];
    id swerveDown = [CCRotateTo actionWithDuration:.25f angle:-swerveAngle];
    id center = [CCRotateTo actionWithDuration:.25f angle:0];
    id endSwerve = [CCCallBlock actionWithBlock: ^{
        sprite.rotation = 0;
        swerving = NO;
    }];
    
    id sequence = [CCSequence actions:swerveUp, swerveDown, center, endSwerve, nil];
    [sprite runAction:sequence];
}

-(CGPoint) position {
    return sprite.position;
}

-(CGPoint) velocity {
    return sprite.body->v;
}

-(void) dealloc {
    cpBodyFree(sprite.body);
}


@end
