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


@implementation AssassinCar
@synthesize velocity;
-(AssassinCar *) init
{
    if (self = [super init]) {
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:@"car.png"];
        sprite = [CCSprite spriteWithSpriteFrame:spriteFrame];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CGSize carSize = sprite.contentSize;
        
        // Place it on the middle-left side of the window for now.
        CGPoint pos = ccp(carSize.width / 2, screenSize.height / 2);
        sprite.position = pos;
        nextPosition = sprite.position;
    
        gunsFiring = NO;
        
        [self addChild:sprite z:0];
        
        const int numVertices = 4;
        float  halfSpriteWidth = carSize.width / 2;
        float halfSpriteHeight = carSize.height / 2;
        
        CGPoint verts[] =
        {
            ccp(-halfSpriteWidth, -halfSpriteHeight),
            ccp(-halfSpriteWidth, halfSpriteHeight),
            ccp(halfSpriteWidth, halfSpriteHeight),
            ccp(halfSpriteWidth, -halfSpriteHeight),
        };
        
        float mass = 1.0f;
        
        body = cpBodyNew(mass,
                         cpMomentForPoly(mass, numVertices, verts, CGPointZero));
        
        cpSpace *space = [GameLayer sharedGameLayer].space;
        body->p = pos;
        
        cpSpaceAddBody(space, body);
     
        cpShape *shape = cpPolyShapeNew(body, numVertices, verts, CGPointZero);
        shape->e = 0.4f;
        shape->u = 0.4f;
        cpSpaceAddShape(space, shape);
        
        body->data = (__bridge void*)self;
    }
    return self;
}

-(void) addToLocation:(CGPoint)difference
{
    CGPoint impulseVect = ccpMult(difference, 1);
    cpBodyApplyImpulse(body, impulseVect		, CGPointZero);
}

-(void) fireMachineGun {
    
    // Add a flash effect on each side of the front of the car to simulate
    // machine gun fire
    
    leftFlashEffect = [MuzzleFlashEffect node];
    leftFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                       sprite.position.y + sprite.contentSize.height / 4);
    [self addChild:leftFlashEffect z:1 tag:AssassinCarNodeLeftFlashEffect];
 
    rightFlashEffect = [MuzzleFlashEffect node];
    rightFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                            sprite.position.y - sprite.contentSize.height / 4);
    
    [self addChild:rightFlashEffect z:1 tag:AssassinCarNodeRightFlashEffect];
}

-(void) stopMachineGun {
    [leftFlashEffect removeFromParentAndCleanup:YES];
    [rightFlashEffect removeFromParentAndCleanup:YES];
    
    // Make sure these are nil for the update check
    leftFlashEffect = nil;
    rightFlashEffect = nil;
}

-(void) syncSpriteWithBody
{
    sprite.position = body->p;
    sprite.rotation = -CC_RADIANS_TO_DEGREES(cpBodyGetAngle(body));
    leftFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                           sprite.position.y + sprite.contentSize.height / 4);
    rightFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                            sprite.position.y - sprite.contentSize.height / 4);
}

@end
