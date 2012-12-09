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
#import "CPDebugLayer.h"

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
        
        [self initPhysics];
        
        // Debug layer for chipmunk shapes
        CCLayer *debugLayer = [[CPDebugLayer alloc] initWithSpace:_space options:nil];
        [self addChild:debugLayer z:5]; // higher z than other layers
        
        // Add the Assassin Car
        AssassinCar *assassinCar = [AssassinCar node];
        
        [self addChild:assassinCar z:1 tag:GameSceneNodeAssassinCar];
        [self scheduleUpdate];
    }
    
    return self;
}

-(void) initPhysics
{
    _space = cpSpaceNew();
    _space->gravity = ccp(0, 0);
    
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    float boxWidth = screenSize.width;
    float boxHeight = screenSize.height;
    float panelHeight = screenSize.height / 5;
    
    // bottom
    walls[0] = cpSegmentShapeNew(_space->staticBody, ccp(0, panelHeight),
                                 ccp(boxWidth, panelHeight), 0.0f);
    
    // top
    walls[1] = cpSegmentShapeNew(_space->staticBody, ccp(0, boxHeight),
                                 ccp(boxWidth, boxHeight), 0.0f);
    
    // left
    walls[2] = cpSegmentShapeNew(_space->staticBody, ccp(0, panelHeight),
                                 ccp(0, boxHeight), 0.0f);
    cpShapeSetLayers(walls[2], CP_LAYER_1);
    
    // right
    walls[3] = cpSegmentShapeNew(_space->staticBody, ccp(boxWidth, panelHeight),
                                 ccp(boxWidth, boxHeight), 0.0f);
    cpShapeSetLayers(walls[3], CP_LAYER_1);
    
    CCLOG(@"CP_ALL_LAYERS is %d", CP_ALL_LAYERS);
    
    for (int i = 0; i < 4; i++) {
        walls[i]->e = 0.0f;
        walls[i]->u = 0.0f;
        cpSpaceAddStaticShape(_space, walls[i]);
    }
    
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
    difference.x *= -1;
    [car addToLocation:difference];
    
    lastTouchLocation = currentTouchLocation;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    lastTouchLocation = CGPointMake(0, 0);
    readyForTouch = YES;
}

-(void) update:(ccTime)delta
{
    const int iterations = 10;
    for (int i = 0; i < iterations; i++) {
        cpSpaceStep(self.space, 0.005f);
        cpSpaceEachBody(self.space, updateBodies, nil);
    }
}

void updateBodies(cpBody *body, void *data) {
    AssassinCar *car = (__bridge AssassinCar *)body->data;
    [car syncSpriteWithBody];
}

-(void) dealloc
{
	sharedGameLayer = nil;
    
    for (int i = 0; i < 4; i++) {
        cpShapeFree(walls[i]);
    }
    cpSpaceFree(self.space);
}

@end
