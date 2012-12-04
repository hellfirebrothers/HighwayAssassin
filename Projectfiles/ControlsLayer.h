//
//  ControlsLayer.h
//  HighwayAssassin
//
//  Created by Max on 12/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "MuzzleFlashEffect.h"

@class AssassinCar;

@interface ControlsLayer : CCLayer {
    SneakyButton *fireButton;
    bool gunsFiring;
}

@property(strong, nonatomic) NSNumber *panelHeight;

@end
