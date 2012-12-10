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
        swerving = NO;
        
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
        
        float mass = 2.0f;
        
        body = cpBodyNew(mass,
                         cpMomentForPoly(mass, numVertices, verts, CGPointZero));
        
        cpSpace *space = [GameLayer sharedGameLayer].space;
        body->p = pos;
        
        cpSpaceAddBody(space, body);
     
        // TODO: maybe add more shapes to increase collision precision
        cpShape *shape = cpPolyShapeNew(body, numVertices, verts, CGPointZero);
        shape->e = 0.4f;
        shape->u = 0.4f;
        cpSpaceAddShape(space, shape);
        
        // Store a reference to this node for use in callback functions
        body->data = (__bridge void*)self;
    }
    return self;
}

-(void) addToLocation:(CGPoint)difference
{
    // Change this to make the "push/pull" more or less effective
    int impulseMultiplier = 5;
    
    CGPoint impulseVect = ccpMult(difference, impulseMultiplier);
    cpBodyApplyImpulse(body, impulseVect, CGPointZero);
}

-(void) fireMachineGun {
    
    // Add a flash effect on each side of the front of the car to simulate
    // machine gun fire
    leftFlashEffect = [MuzzleFlashEffect node];
    leftFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                       sprite.position.y + sprite.contentSize.height / 4);
    [sprite addChild:leftFlashEffect];
    rightFlashEffect = [MuzzleFlashEffect node];
    rightFlashEffect.position = CGPointMake(sprite.position.x + sprite.contentSize.width * .5f,
                                            sprite.position.y - sprite.contentSize.height / 4);
    
    [sprite addChild:rightFlashEffect];
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
    // Must invert the degree measure to match the body's angle
    if (!swerving) {
        sprite.rotation = -CC_RADIANS_TO_DEGREES(cpBodyGetAngle(body));
    }
    cpFloat rotationMagnitude = abs(sprite.rotation);
    // simulate corrective steering if past an arbitrary angle
    if (rotationMagnitude > 10 && swerving == NO) {
        swerving = YES;
        [self steerCorrectively];
        cpBodySetAngVel(body, 0);
    }
    
    // TODO: make this less verbose/more efficient
    leftFlashEffect.position = CGPointMake(sprite.contentSize.width,
                                           sprite.contentSize.height * .25f);
    rightFlashEffect.position = CGPointMake(sprite.contentSize.width,
                                            sprite.contentSize.height * .75f);
}

-(void) steerCorrectively
{
    float swerveAngle = -CC_RADIANS_TO_DEGREES(cpBodyGetAngVel(body));
    id swerveUp = [CCRotateTo actionWithDuration:.25f angle:swerveAngle];
    id matchBody = [CCCallBlock actionWithBlock:^{
        cpBodySetAngle(body, -CC_DEGREES_TO_RADIANS(sprite.rotation));
    }];
    id swerveDown = [CCRotateTo actionWithDuration:.25f angle:-swerveAngle];
    id center = [CCRotateTo actionWithDuration:.25f angle:0];
    id endSwerve = [CCCallBlock actionWithBlock: ^{
        cpBodySetAngle(body, 0);
        swerving = NO;
    }];					
    id sequence = [CCSequence actions:swerveUp, matchBody, swerveDown, matchBody, center, endSwerve, nil];
    [sprite runAction:sequence];
}

@end
