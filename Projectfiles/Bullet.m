//
//  Bullet.m
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/16/12.
//
//

#import "Bullet.h"

@implementation Bullet
-(Bullet *) init
{
    self.type = GameObjectProjectile;
    if (self = [super init]) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                spriteFrameByName:@"bullet.png"];
        sprite = [PhysicsSprite spriteWithSpriteFrame:frame mass:0.1f isSensor:YES];
        sprite.visible = NO;
        [self addChild:sprite];
    }
    
    [self scheduleUpdate];
    return self;
}

-(void) fireFromPosition:(CGPoint)position withRotation:(float)rotation {
    sprite.position = position;
    sprite.visible = YES;
    
    float spriteWidth = sprite.contentSize.width;
    ccColor3B streakColor = ccc3(251, 193, 46);
    streak = [CCMotionStreak streakWithFade:.075f minSeg:1 width:spriteWidth/10
                                      color:streakColor textureFilename:@"bulletstreak.png"];
    CGPoint streakPosition = ccp(position.x - spriteWidth / 12, position.y);
    streak.position = streakPosition;
    [self addChild:streak];
}

-(void) goAway {
    [sprite removeAllChildrenWithCleanup:YES];
}

-(void) update:(ccTime)delta {
    float spriteWidth = sprite.contentSize.width;
    CGPoint spritePos = sprite.position;
    spritePos.x += 1500 * delta;
    CGPoint streakPos = ccp(spritePos.x - spriteWidth / 12, spritePos.y);
    sprite.position = spritePos;
    streak.position = streakPos;
}

-(void)handleCollisionWithEnemy:(PhysicsSprite *)enemy energyLost:(float)energyLost
{
    
}

-(void)handleCollisionWithPlayer:(PhysicsSprite *)player energyLost:(float)energyLost
{
    
}

-(void)handleCollisionWithProjectile:(PhysicsSprite *)projectile
{
    
}
@end
