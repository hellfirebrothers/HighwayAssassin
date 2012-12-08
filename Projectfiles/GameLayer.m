//
//  GameScene.m
//  SpriteBatches
//
//  Created by Alexander Woods on 12.02.12
//
//

#import "GameLayer.h"
#import "TileMapBackground.h"
#import "AssassinCar.h"
#import "ControlsLayer.h"
#import "MuzzleFlashEffect.h"

@interface GameLayer (PrivateMethods)
@end

@implementation GameLayer

static GameLayer* sharedGameLayer;
+(GameLayer*) sharedGameLayer
{
	NSAssert(sharedGameLayer != nil, @"GameScene instance not yet initialized!");
	return sharedGameLayer;
}

+(id) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if ((self = [super init])) {
		sharedGameLayer = self;
        isTouchEnabled_ = YES;
        readyForTouch = YES;
        
        // Go ahead and load all the artwork right away
        CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        [frameCache addSpriteFramesWithFile:@"game-art.plist"];
        
        // Add the background
        background = [TileMapBackground node];
        [self addChild:background z:0 tag:GameSceneNodeTileMapBackground];
        
        // Add the Controls Layer
        ControlsLayer *controlsLayer = [ControlsLayer node];
        [self addChild:controlsLayer z:1 tag:GameSceneNodeControlsLayer];
        
        // Add the Assassin Car
        AssassinCar *assassinCar = [AssassinCar node];
        
        [self addChild:assassinCar z:1 tag:GameSceneNodeAssassinCar];
    }
    
    return self;
}

// Checks if the touch location was in an area that this layer wants to handle as input.
-(BOOL) isTouchForMe:(CGPoint)touchLocation
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    ControlsLayer *controlPanel = (ControlsLayer *)[self getChildByTag:GameSceneNodeControlsLayer];
    CGPoint location = [[CCDirector sharedDirector] convertToGL:touchLocation];
    CGRect streetBox = CGRectMake(0, controlPanel.panelHeight.floatValue, winSize.width,
                                  winSize.height - controlPanel.panelHeight.floatValue);
    
    return CGRectContainsPoint(streetBox, location);
}

-(void) registerWithTouchDispatcher {
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self
                                                            priority:0
                                                     swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (readyForTouch ) {
        lastTouchLocation = [touch locationInView:[touch view]];
        
        if ([self isTouchForMe:lastTouchLocation]) {
            NSLog(@"handling touch");
            readyForTouch = NO;
            return YES;
        }
    }
    
   return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    AssassinCar *car = (AssassinCar *)[self getChildByTag:GameSceneNodeAssassinCar];
    CGPoint currentTouchLocation = [touch locationInView:[touch view]];
    CGPoint difference = ccpSub(lastTouchLocation, currentTouchLocation);
    difference = ccpMult(difference, -1);
    [car addToLocation:difference];
    
    lastTouchLocation = currentTouchLocation;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    lastTouchLocation = CGPointMake(0, 0);
    readyForTouch = YES;
}

-(void) dealloc
{
	sharedGameLayer = nil;
}

@end
