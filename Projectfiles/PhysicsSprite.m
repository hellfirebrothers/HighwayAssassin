//
//  PhysicsSprite.m
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PhysicsSprite.h"
#import "GameLayer.h"


@implementation PhysicsSprite
+(id) spriteWithSpriteFrame:(CCSpriteFrame *)spriteFrame mass:(float)mass isSensor:(bool)isSensor
{
    PhysicsSprite *sprite = [super spriteWithSpriteFrame:spriteFrame];
    
    CGSize spriteSize = sprite.contentSize;
    
    const int numVertices = 4;
    float halfSpriteWidth = spriteSize.width / 2;
    float halfSpriteHeight = spriteSize.height / 2;
    
    CGPoint verts[] =
    {
        ccp(-halfSpriteWidth, -halfSpriteHeight),
        ccp(-halfSpriteWidth, halfSpriteHeight),
        ccp(halfSpriteWidth, halfSpriteHeight),
        ccp(halfSpriteWidth, -halfSpriteHeight)
    };
    
    sprite.body = cpBodyNew(mass,
                     cpMomentForPoly(mass, numVertices, verts,
                                     CGPointZero));
    

    
    sprite.shape = cpPolyShapeNew(sprite.body, numVertices, verts,
                                    CGPointZero);

    sprite.shape->e = 0.4f;
    sprite.shape->u = 0.4f;
    
    sprite.layers = CP_ALL_LAYERS;
    
    sprite.body->data = (__bridge void *)sprite;
    
    if (isSensor) {
        // Sensor shapes call collision call backs, but they aren't simulated
        // (so we don't add them to the space)
        sprite.shape->sensor = YES;
    }
    // If it's not a sensor shape, we want to simulate collisions
    sprite.space = [GameLayer sharedGameLayer].space;
    cpSpaceAddBody(sprite.space, sprite.body);
    cpSpaceAddShape(sprite.space, sprite.shape);
    
    return sprite;
}

+(id) spriteWithSpriteFrame:(CCSpriteFrame *)spriteFrame mass:(float)mass
                      layers:(int)layers isSensor:(bool)isSensor
{
    PhysicsSprite *sprite = [PhysicsSprite spriteWithSpriteFrame:spriteFrame mass:mass isSensor:isSensor];
    sprite.layers = layers;
    cpBodyEachShape(sprite.body, setLayers, sprite.body->data);
    return sprite;
}

void setLayers(cpBody *body, cpShape *shape, void *data) {
    PhysicsSprite *sprite = (__bridge PhysicsSprite *)data;
    cpShapeSetLayers(shape, sprite.layers);
}

-(void) setPosition:(CGPoint)position {
    [super setPosition:position];
    cpBodySetPos(self.body, position);
}

-(void) setRotation:(float)rotation {
    [super setRotation:rotation];
    cpBodySetAngle(self.body, -CC_DEGREES_TO_RADIANS(rotation));
}


-(CGPoint) position {
    return cpBodyGetPos(self.body);
}

-(float) rotation {
    return -CC_RADIANS_TO_DEGREES(cpBodyGetAngle(self.body));
}

-(void) updatePhysics {
    self.position = cpBodyGetPos(self.body);
    self.rotation = -CC_RADIANS_TO_DEGREES(cpBodyGetAngle(self.body));
}

-(void) dealloc {
    cpSpaceRemoveBody(self.space, self.body);
    cpSpaceRemoveShape(self.space, self.shape);
    cpBodyFree(self.body);
    cpShapeFree(self.shape);
}

@end
