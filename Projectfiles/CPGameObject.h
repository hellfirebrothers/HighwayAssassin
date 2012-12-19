//
//  CCGameObject.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/18/12.
//
//

#import <Foundation/Foundation.h>
#import "PhysicsSprite.h"

typedef enum
{
    GameObjectPlayer = 0x0001,
    GameObjectEnemy = 0x0010,
    GameObjectProjectile = 0x0100,
} GameObjectType;

@interface CPGameObject : CCNode
-(void)handleCollisionWithEnemy:(PhysicsSprite *)enemy energyLost:(float)energyLost;
-(void)handleCollisionWithPlayer:(PhysicsSprite *)player energyLost:(float)energyLost;
-(void)handleCollisionWithProjectile:(PhysicsSprite *)projectile;

@property GameObjectType type;
@end
