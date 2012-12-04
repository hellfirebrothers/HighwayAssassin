//
//  ControlsLayer.m
//  HighwayAssassin/
//
//  Created by Max on 12/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlsLayer.h"
#import "AssassinCar.h"
#import "GameLayer.h"

@interface ControlsLayer (PrivateMethods)
-(void) addFireButton;
@end

@implementation ControlsLayer
-(ControlsLayer *) init
{
    if (self == [super init]) {
        CCSprite *panel = [CCSprite spriteWithSpriteFrameName:@"panel.png"];
        panel.anchorPoint = CGPointZero;
        panel.position = CGPointZero;
        
        _panelHeight = [NSNumber numberWithFloat:panel.contentSize.height];
        [self addChild:panel z:0 tag:0];
        
        gunsFiring = NO;
        [self addFireButton];
        [self scheduleUpdate];
    }
    return self;
}

-(void) addFireButton
{
    float buttonRadius = 32;
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    BOOL useSkinnedButton = YES;
    if (useSkinnedButton) {
        CCSprite *idle = [CCSprite spriteWithSpriteFrameName:@"button.png"];
        CCSprite *press = [CCSprite spriteWithSpriteFrameName:@"button-active.png"];
        
        fireButton = [[SneakyButton alloc] initWithRect:CGRectZero];
        fireButton.isHoldable = YES;
        
        SneakyButtonSkinnedBase *skinFireButton = [[SneakyButtonSkinnedBase
                                                    alloc] init];
        skinFireButton.button = fireButton;
        skinFireButton.defaultSprite = idle;
        skinFireButton.pressSprite = press;
        skinFireButton.position = CGPointMake(screenSize.width - buttonRadius, buttonRadius);
        [self addChild:skinFireButton];
    } else {
        fireButton = [[SneakyButton alloc] initWithRect:CGRectZero];
        fireButton.radius = buttonRadius;
        fireButton.position = CGPointMake(screenSize.width - buttonRadius,
                                          buttonRadius);
        [self addChild:fireButton];
    }
}

-(void) update:(ccTime)delta
{
    if (fireButton.active && gunsFiring == NO) {
        GameLayer *gameLayer = [GameLayer sharedGameLayer];
        AssassinCar *car = (AssassinCar *)[gameLayer getChildByTag:GameSceneNodeAssassinCar];
        [car fireMachineGun];
        gunsFiring = YES;
    }
    
    if (!fireButton.active && gunsFiring == YES) {
        GameLayer *gameLayer = [GameLayer sharedGameLayer];
        AssassinCar *car = (AssassinCar *)[gameLayer getChildByTag:GameSceneNodeAssassinCar];
        [car stopMachineGun];
        gunsFiring = NO;
    }
}
@end
