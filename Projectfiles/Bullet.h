//
//  Bullet.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/16/12.
//
//

#import "PhysicsSprite.h"
#import "CPGameObject.h"

@interface Bullet : CPGameObject  {
    CCMotionStreak *streak;
}

-(void) fireFromPosition:(CGPoint)position withRotation:(float)rotation;
-(void) goAway;

@property PhysicsSprite *sprite;

@end
