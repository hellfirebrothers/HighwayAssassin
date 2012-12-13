//
//  PhysicsSprite.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface PhysicsSprite : CCSprite {
}

@property cpBody *body;
@property cpShape *shape;
@property cpSpace *space;
@property int layers;

+(id) spriteWithSpriteFrame:(CCSpriteFrame *)spriteFrame mass:(float)mass;
+(id) spriteWithSpriteFrame:(CCSpriteFrame *)spriteFrame mass:(float)mass
                     layers:(int)layers;
-(void) updatePhysics;
void setLayers(cpBody *body, cpShape *shape, void *data);
@end
