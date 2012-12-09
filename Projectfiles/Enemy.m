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
-(id) init {
    if (self = [super init]) {
        sprite = [CCSprite spriteWithSpriteFrameName:@"police.png"];
        CGSize carSize = [sprite contentSize];
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        [self addChild:sprite z:1];
        sprite.position = CGPointMake(-carSize.width * 0.5f, windowSize.height/2);
        CCAction *emerge = [CCMoveBy actionWithDuration:1
                                               position:ccp(carSize.width, 0)];
        [self runAction:emerge];
        [self scheduleUpdate];
    }
    
    return self;
}

+(void) spawnEnemy
{
    Enemy *newEnemy = [self node];
    GameLayer *gameLayer = [GameLayer sharedGameLayer];
    [gameLayer addChild:newEnemy];
}

-(void) update:(ccTime)delta
{
}
@end
