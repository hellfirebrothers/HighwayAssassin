//
//  ScrollingBackground.m
//  HighwayAssassin
//
//  Created by Max on 12/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ScrollingBackground.h"


@implementation ScrollingBackground
-(ScrollingBackground *) init {
    if (self = [super init]) {
        // Create the initial background
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                      spriteFrameByName:@"street.png"];
        spriteBatch = [CCSpriteBatchNode batchNodeWithTexture:spriteFrame.texture];

        CCSprite *thisBackground = [CCSprite spriteWithSpriteFrame:spriteFrame];
        CGSize windowSize = [CCDirector sharedDirector].winSize;
        thisBackground.anchorPoint = CGPointMake(0, 0);
        thisBackground.position = CGPointMake(0, 0);
        
        [spriteBatch addChild:thisBackground z:0 tag:0];
        
        // Create an identical background adjacent to the first one
        CCSprite *nextBackground = [CCSprite spriteWithSpriteFrame:spriteFrame];
        nextBackground.anchorPoint = CGPointMake(0, 0);
        
        // Offset to avoid screen flicker (rounding error)
        nextBackground.position = CGPointMake(windowSize.width - 0.5f, 0);
        [spriteBatch addChild:nextBackground z:0 tag:1];
        
        [self addChild:spriteBatch];
        [self scheduleUpdate];
    }
    return self;
}

-(void) update:(ccTime)delta {
    float scrollSpeed = 6.0f;
    int windowWidth = [CCDirector sharedDirector].winSize.width;
    CGPoint pos;
    
    for (CCSprite *sprite in spriteBatch.children) {
        pos = sprite.position;
        pos.x -= scrollSpeed * (delta * 50.0f);
        if (pos.x < -windowWidth) {
            pos.x = windowWidth - 1.0f;
        }
        sprite.position = pos;
    }
}
@end
