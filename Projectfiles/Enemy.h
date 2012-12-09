//
//  Enemy.h
//  HighwayAssassin
//
//  Created by Alexander Woods on 12/8/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Enemy : CCNode {
    CCSprite *sprite;
}

+(void) spawnEnemy;
@end
