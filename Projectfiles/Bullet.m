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
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"bullet.png"];
        _sprite = [PhysicsSprite spriteWithSpriteFrame:frame mass:0.1f isSensor:YES];
        _sprite.visible = NO;
        [self addChild:_sprite];
    }
    
    [self scheduleUpdate];
    return self;
}

-(void) fireFromPosition:(CGPoint)position withRotation:(float)rotation {
    self.sprite.position = position;
    self.sprite.visible = YES;
    streak.visible = YES;
    float spriteWidth = self.sprite.contentSize.width;
    ccColor3B streakColor = ccc3(251, 193, 46);
    streak = [CCMotionStreak streakWithFade:.04f minSeg:1 width:spriteWidth/10
                                      color:streakColor textureFilename:@"bulletstreak.png"];
    CGPoint streakPosition = ccp(position.x - spriteWidth, position.y);
    streak.position = streakPosition;
    [self addChild:streak];
}

-(void) goAway {
    [self.sprite removeAllChildrenWithCleanup:YES];
}

-(void) update:(ccTime)delta {
    float spriteWidth = self.sprite.contentSize.width;
    CGPoint spritePos = self.sprite.position;
    CGSize windowSize = [CCDirector sharedDirector].winSize;
    spritePos.x += 1500 * delta;
    CGPoint streakPos = ccp(spritePos.x - spriteWidth / 12, spritePos.y);
    self.sprite.position = spritePos;
    streak.position = streakPos;
    
    if (self.sprite.position.x > windowSize.width) {
        [self removeFromParentAndCleanup:YES];
    }
    
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
