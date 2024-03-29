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
#import "Enemy.h"
#import "ControlsLayer.h"
#import "MuzzleFlashEffect.h"
#import "CPDebugLayer.h"
#import "PhysicsSprite.h"
#import "Bullet.h"
#import "CPCollisionHandler.h"

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
        //CCLayer *debugLayer = [[CPDebugLayer alloc] initWithSpace:_space options:nil];
        //[self addChild:debugLayer z:5]; // higher z than other layers
        
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
    walls[0]->e = 1.0;
    walls[0]->u = 1.0;
    
    // top
    walls[1] = cpSegmentShapeNew(_space->staticBody, ccp(0, boxHeight),
                                 ccp(boxWidth, boxHeight), 0.0f);
    walls[1]->e = 1.0;
    walls[1]->u = 1.0;
    
    // left
    walls[2] = cpSegmentShapeNew(_space->staticBody, ccp(0, panelHeight),
                                 ccp(0, boxHeight), 0.0f);
    walls[2]->e = 0;
    walls[2]->u = 0;
    cpShapeSetLayers(walls[2], CP_LAYER_1);
    
    // right
    walls[3] = cpSegmentShapeNew(_space->staticBody, ccp(boxWidth, panelHeight),
                                 ccp(boxWidth, boxHeight), 0.0f);
    walls[3]->e = 0;
    walls[3]->u = 0;
    cpShapeSetLayers(walls[3], CP_LAYER_1);
    
    for (int i = 0; i < 4; i++) {
        cpSpaceAddStaticShape(_space, walls[i]);
    }
    
    CPCollisionHandler *collisionHandler = [CPCollisionHandler CollisionHandlerWithSpace:_space];
    [self addChild:collisionHandler];
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
    PhysicsSprite *sprite = (__bridge PhysicsSprite *)body->data;
    [sprite updatePhysics];
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
