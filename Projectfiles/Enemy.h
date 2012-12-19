//
//  Enemy.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"
#import "CPGameObject.h"

@class GameLayer;
@class PhysicsSprite;

typedef enum {
    EnemyStatePursuing,
    EnemyStateAttacking,
    EnemyStateSwerving,
    EnemyStateMax
} EnemyState;

typedef enum {
    EnemyTypePolice,
    EnemyTypeGeneric,
} EnemyType;

@interface Enemy : CPGameObject  {
    CCAnimation *animation;
    PhysicsSprite *sprite;
    EnemyState enemyState;
    GameLayer *gameLayer;
    int hitPoints;
}

+(void) spawnEnemyOfType:(EnemyType)enemyType;
-(void) takeDamage:(float)damage;
@end
