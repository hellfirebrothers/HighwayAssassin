//
//  CPCollisionHandler.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/18/12.
//
//

#import "CCNode.h"
#import "chipmunk.h"
#import "CPGameObject.h"

typedef enum {
    PlayerEnemyCollision = GameObjectEnemy | GameObjectPlayer,
    PlayerProjectileCollision = GameObjectPlayer | GameObjectProjectile,
    EnemyProjectileCollision = GameObjectEnemy | GameObjectProjectile,
    PlayerPlayerCollision = GameObjectPlayer,
    EnemyEnemyCollision = GameObjectEnemy,
    ProjectileProjectileCollision = GameObjectProjectile
} CollisionType;

@interface CPCollisionHandler : CCNode {
}
+(id) CollisionHandlerWithSpace:(cpSpace *)space;
static int contactBegin(cpArbiter *arbiter, struct cpSpace *space, void *data);
static void postSolve(cpArbiter *arbiter, cpSpace *space, void *data);
static void contactEnd(cpArbiter *arbiter, cpSpace *space, void *data);

@end
