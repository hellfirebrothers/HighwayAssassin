//
//  Enemy.m
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "GameLayer.h"
#import "CCAnimationHelper.h"
#import "AssassinCar.h"
#import "PhysicsSprite.h"

@implementation Enemy
-(Enemy *) init {
    
    return [self initEnemyOfType:EnemyTypeGeneric];
}

-(void) updatePhysics
{
}

-(id) initEnemyOfType:(EnemyType)enemyType
{
    self = [super init];
    if (enemyType == EnemyTypePolice) {
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"police.png"];
        sprite = [PhysicsSprite spriteWithSpriteFrame:spriteFrame mass:2.0f layers:CP_LAYER_2];
        
        CGSize carSize = sprite.contentSize;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CGPoint pos = ccp(-carSize.width, screenSize.height / 2);
        sprite.position = pos;
        
        [self addChild:sprite];
        
        // Start with 100 hp for debugging
        hitPoints = 100;
        
        // Animation stuff
        animation = [CCAnimation animationWithFrame:@"police" frameCount:2 delay:.25f];
        CCAction *animationAction = [CCRepeatForever actionWithAction:
                                     [CCAnimate actionWithAnimation:animation]];
        id emerge = [CCMoveBy actionWithDuration:.5f position:ccp(carSize.width, 0)];
        [sprite runAction:emerge];
        [sprite runAction:animationAction];
        
        // Start pursuing the Assassin Car right away
        enemyState = EnemyStatePursuing;
        [self scheduleUpdate];
    }
    
    if (enemyType == EnemyTypeGeneric) {
        /*CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"enemy.png"];
        sprite = [PhysicsSprite spriteWithSpriteFrame:spriteFrame mass:1.0f layers:CP_LAYER_2];
        CGSize carSize = sprite.contentSize;
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        CGPoint pos = ccp(carSize.width * 3, screenSize.height / 2);
        sprite.position = pos;
        [self addChild:sprite]; */
    }
    
    gameLayer = [GameLayer sharedGameLayer];
    
    return self;
}

+(void) spawnEnemyOfType:(EnemyType)enemyType
{
    GameLayer *gameLayer = [GameLayer sharedGameLayer];
    Enemy *newEnemy = [[self alloc] initEnemyOfType:enemyType];
    [gameLayer addChild:newEnemy z:1];
}

-(void) update:(ccTime)delta
{
    switch (enemyState) {
        case EnemyStatePursuing:
        {
            AssassinCar *assassin = (AssassinCar *)[gameLayer getChildByTag:GameSceneNodeAssassinCar];
            CGPoint pos = sprite.position;
            CGPoint targetPos = assassin.position;
            targetPos.x -= sprite.contentSize.width * 1.5;
            float distance = ccpDistance(pos, targetPos);
            float T = distance / 64.0f;
            CGPoint seekPosition = ccpAdd(targetPos, ccpMult(assassin.velocity, T));
            [self seek:seekPosition distance:distance];
            if (distance < sprite.contentSize.width / 2)
            {
                enemyState = EnemyStateAttacking;
            }
           
            break;
        }
        case EnemyStateAttacking:
        {
            cpBodyApplyImpulse(sprite.body, ccp(128, 0), CGPointZero);
            enemyState = EnemyStatePursuing;
            break;
        }
            
        default:
            break;
    }
    
    cpFloat rotationMagnitude = abs(sprite.rotation);
    
    // simulate corrective steering if past an arbitrary angle
    if (rotationMagnitude > 10 && enemyState != EnemyStateSwerving) {
        enemyState = EnemyStateSwerving;
        [self steerCorrectively];
        cpBodySetAngVel(sprite.body, 0);
    }
}



-(void) seek:(CGPoint)position distance:(float)distance
{
    float slowingDistance = sprite.contentSize.width * 2;
    CGPoint deltaPos = ccpSub(position, sprite.position);
    CGPoint desiredVelocity = ccpNormalize(deltaPos);
    
    if (distance > slowingDistance) {
        desiredVelocity = ccpMult(desiredVelocity, 64.0f);
    } else {
        desiredVelocity = ccpMult(desiredVelocity, distance/slowingDistance * 64.0f);
    }
    
    CGPoint steeringForce = ccpSub(desiredVelocity, sprite.body->v);
    sprite.body->v = ccpAdd(sprite.body->v, ccpMult(steeringForce, 1 / sprite.body->m));
}


-(void) steerCorrectively
{
    float swerveAngle = -CC_RADIANS_TO_DEGREES(cpBodyGetAngVel(sprite.body)) * .5f;
    id swerveUp = [CCRotateTo actionWithDuration:.25f angle:swerveAngle];
    id swerveDown = [CCRotateTo actionWithDuration:.25f angle:-swerveAngle];
    id center = [CCRotateTo actionWithDuration:.25f angle:0];
    id endSwerve = [CCCallBlock actionWithBlock: ^{
        sprite.rotation = 0;
        enemyState = EnemyStatePursuing;
    }];
    
    id sequence = [CCSequence actions:swerveUp, swerveDown, center, endSwerve, nil];
    [sprite runAction:sequence];
}

-(void) dealloc
{
    cpBodyFree(sprite.body);
}

/*static int contactBegin(cpArbiter *arbiter, struct cpSpace *space, void *data)
{
    BOOL processCollision = YES;
    
    cpBody *bodyA;
    cpBody *bodyB;
    cpArbiterGetBodies(arbiter, &bodyA, &bodyB);
    
    PhysicsSprite *spriteA = (__bridge PhysicsSprite *)bodyA->data;
    PhysicsSprite *spriteB = (__bridge PhysicsSprite *)bodyB->data;
} */

@end
