//
//  Bullet.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/16/12.
//
//

#import "PhysicsSprite.h"

@interface Bullet : CCNode {
    CCSprite *sprite;
    CCMotionStreak *streak;
}

-(void) fireFromPosition:(CGPoint)position withRotation:(float)rotation;
-(void) goAway;
@end
