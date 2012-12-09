//
//  Enemy.m
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "GameLayer.h"

@implementation Enemy
// Just use this class for the police for now, but remember to fix class-structure later
-(Enemy *) init {
    if (self = [super init]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"police.png"];
        CGSize carSize = sprite.contentSize;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CGPoint pos = ccp(-carSize.width / 2, screenSize.height / 2);
        sprite.position = pos;
        [self addChild:sprite z:2];
        id emerge = [CCMoveTo actionWithDuration:1 position:ccp(carSize.width / 2, screenSize.height / 2)];
        id actionCallFunc = [CCCallFunc actionWithTarget:self
                                                selector:@selector(initPhysics)];
        id sequence = [CCSequence actions:emerge, actionCallFunc, nil];
        [sprite runAction:sequence];
    }
    
    return self;
}

-(void) initPhysics
{
    CGSize carSize = sprite.contentSize;
    const int numVertices = 4;
    float halfSpriteWidth = carSize.width / 2;
    float halfSpriteHeight = carSize.height / 2;
    
    CGPoint verts[] = {
        ccp(-halfSpriteWidth, -halfSpriteHeight),
        ccp(-halfSpriteWidth, halfSpriteHeight),
        ccp(halfSpriteWidth, halfSpriteHeight),
        ccp(halfSpriteWidth, -halfSpriteHeight),
    };
    
    float mass = 1.0f;
    
    body = cpBodyNew(mass,
                     cpMomentForPoly(mass, numVertices, verts,
                                     CGPointZero));
    
    cpSpace *space = [GameLayer sharedGameLayer].space;
    body->p = sprite.position;
    
    cpSpaceAddBody(space, body);
    
    cpShape *shape = cpPolyShapeNew(body, numVertices, verts,
                                    CGPointZero);
    shape->e = 0.4f;
    shape->u = 0.4f;
    cpShapeSetLayers(shape, CP_LAYER_2);
    cpSpaceAddShape(space, shape);
    
    // Store a reference to this node for use in callback functions
    body->data = (__bridge void*)self;
}

-(void) syncSpriteWithBody
{
    sprite.position = body->p;
    // Must invert the degree measure to match the body's angle
    sprite.rotation = -CC_RADIANS_TO_DEGREES(cpBodyGetAngle(body));
}

+(void) spawnEnemy
{
    Enemy *newEnemy = [self node];
    GameLayer *gameLayer = [GameLayer sharedGameLayer];
    [gameLayer addChild:newEnemy z:1];
}

@end
