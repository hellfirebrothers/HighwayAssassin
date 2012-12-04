//
//  AssassinCar.m
//  HighwayAssassin
//
//  Created by Max on 12/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AssassinCar.h"
#import "MuzzleFlashEffect.h"


@implementation AssassinCar
-(AssassinCar *) init
{
    if (self = [super init]) {
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:@"car.png"];
        sprite = [CCSprite spriteWithSpriteFrame:spriteFrame];
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        CGSize carSize = sprite.contentSize;
        
        // Place it on the middle-left side of the window for now.
        sprite.position = CGPointMake(carSize.width * 0.5f, windowSize.height/2);
        nextPosition = sprite.position;
        
        gunsFiring = NO;
        
        [self addChild:sprite z:0];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) addToLocation:(CGPoint)difference
{
    CGPoint pos = sprite.position;
    pos.x += difference.x;
    pos.y -= difference.y;
    nextPosition = pos;
}

-(void) update:(ccTime)delta {
    sprite.position = nextPosition;
    
    if (leftFlashEffect) {
        leftFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                           sprite.position.y + sprite.contentSize.height / 5);
        rightFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                                sprite.position.y - sprite.contentSize.height / 5);
    }
}

-(void) fireMachineGun {
    
    // Add a flash effect on each side of the front of the car to simulate
    // machine gun fire
    
    leftFlashEffect = [MuzzleFlashEffect node];
    leftFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                       sprite.position.y + sprite.contentSize.height / 2);
    [self addChild:leftFlashEffect z:1 tag:AssassinCarNodeLeftFlashEffect];
 
    rightFlashEffect = [MuzzleFlashEffect node];
    rightFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                            sprite.position.y - sprite.contentSize.height / 5);
    
    [self addChild:rightFlashEffect z:1 tag:AssassinCarNodeRightFlashEffect];
}

-(void) stopMachineGun {
    [leftFlashEffect removeFromParentAndCleanup:YES];
    [rightFlashEffect removeFromParentAndCleanup:YES];
    
    // Make sure these are nil for the update check
    leftFlashEffect = nil;
    rightFlashEffect = nil;
}

-(void) setPosition:(CGPoint)pos
{
}


@end
