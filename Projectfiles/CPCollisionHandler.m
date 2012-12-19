//
//  CPCollisionHandler.m
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/18/12.
//
//

#import "CPCollisionHandler.h"
#import "PhysicsSprite.h"
#import "AssassinCar.h"
#import "Enemy.h"
#import "Bullet.h"

@interface CPCollisionHandler()
@property cpSpace *space;
@end

@implementation CPCollisionHandler

-(id) initWithSpace:(cpSpace *)space
{
    if (self = [super init]) {
        _space = space;
        cpSpaceAddCollisionHandler(_space, 0, 0, &contactBegin, NULL, &postSolve, &contactEnd, NULL);
    }
    
    return self;
}

+(id) CollisionHandlerWithSpace:(cpSpace *)space
{
    return [[self alloc] initWithSpace:space];
}

static void postSolve(cpArbiter *arbiter, cpSpace *space, void *data) {
    // If this gets called, we know both objects are simulated (not sensors)
    // so we don't handle projectile collisions here.
    if (cpArbiterIsFirstContact(arbiter)) {
        cpBody *bodyA;
        cpBody *bodyB;
        cpArbiterGetBodies(arbiter, &bodyA, &bodyB);
        
            
        PhysicsSprite *spriteA = (__bridge PhysicsSprite *)bodyA->data;
        PhysicsSprite *spriteB = (__bridge PhysicsSprite *)bodyB->data;
       
        if (spriteA != nil && spriteB != nil) {
            CPGameObject *nodeA = (CPGameObject *) [spriteA parent];
            CPGameObject *nodeB = (CPGameObject *) [spriteB parent];
            
            float keLost = cpArbiterTotalKE(arbiter);
            
            switch (nodeA.type | nodeB.type) {
                case PlayerEnemyCollision:
                    if (nodeA.type == GameObjectPlayer) {
                        [nodeA handleCollisionWithEnemy:spriteB energyLost:keLost];
                        [nodeB handleCollisionWithPlayer:spriteA energyLost:cpArbiterTotalKE(arbiter)];
                    } else {
                        [nodeB handleCollisionWithEnemy:spriteA energyLost:keLost];
                        [nodeA handleCollisionWithPlayer:spriteB energyLost:keLost];
                    }
                    break;
                case PlayerPlayerCollision:
                    [nodeA handleCollisionWithPlayer:spriteB energyLost:keLost];
                    [nodeB handleCollisionWithPlayer:spriteA energyLost:keLost];
                    break;
                case EnemyEnemyCollision:
                    [nodeA handleCollisionWithEnemy:spriteB energyLost:keLost];
                    [nodeB handleCollisionWithEnemy:spriteA energyLost:keLost];
                    break;
            }
        }
    }
}

static int contactBegin(cpArbiter *arbiter, struct cpSpace *space, void *data) {
    // This callback is called for sensors and simulated objects
    if (cpArbiterIsFirstContact(arbiter)) {
        cpBody *bodyA;
        cpBody *bodyB;
        cpArbiterGetBodies(arbiter, &bodyA, &bodyB);
        
        PhysicsSprite *spriteA = (__bridge PhysicsSprite *)bodyA->data;
        PhysicsSprite *spriteB = (__bridge PhysicsSprite *)bodyB->data;
        
        if (spriteA != nil && spriteB != nil) {
            CPGameObject *nodeA = (CPGameObject *) [spriteA parent];
            CPGameObject *nodeB = (CPGameObject *) [spriteB parent];
            
            if (nodeA.type == GameObjectProjectile || nodeB.type == GameObjectProjectile) {
                switch (nodeA.type | nodeB.type) {
                    case EnemyProjectileCollision:
                        if (nodeA.type == GameObjectEnemy) {
                            [nodeA handleCollisionWithProjectile:spriteB];
                            [nodeB handleCollisionWithEnemy:spriteA energyLost:0];
                        } else {
                            [nodeB handleCollisionWithProjectile:spriteA];
                            [nodeA handleCollisionWithEnemy:spriteB energyLost:0];
                        }
                        break;
                    case PlayerProjectileCollision:
                        if (nodeA.type == GameObjectPlayer) {
                            [nodeA handleCollisionWithProjectile:spriteB];
                            [nodeB handleCollisionWithEnemy:spriteA energyLost:0];
                        } else {
                            [nodeB handleCollisionWithProjectile:spriteA];
                            [nodeA handleCollisionWithEnemy:spriteB energyLost:0];
                        }
                        break;
                    case ProjectileProjectileCollision:
                        [nodeA handleCollisionWithProjectile:spriteB];
                        [nodeB handleCollisionWithProjectile:spriteA];
                        break;
                }
            }
        }
    }
    return YES;
}

static void contactEnd(cpArbiter *arbiter, cpSpace *space, void *data) {
    
}
@end
