//
//  TracerParticleEffect.m
//  HighwayAssassin
//
//  Created by Max on 12/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MuzzleFlashEffect.h"


@implementation MuzzleFlashEffect

-(id) init {
    return [self initWithTotalParticles:120];
}

-(id) initWithTotalParticles:(NSUInteger)numParticles
{
	self = [super initWithTotalParticles:numParticles];
	if (self)
	{
		// DURATION
		// most effects use infinite duration
		self.duration = kCCParticleDurationInfinity;
		// for timed effects use a number in seconds how long particles should be emitted
		//self.duration = 2.0f;
		// If the particle system runs for a fixed time, this will remove the particle system node from
		// its parent once all particles have died. Has no effect for infinite particle systems.
		self.autoRemoveOnFinish = YES;
        
		// MODE
		// particles are affected by gravity
		self.emitterMode = kCCParticleModeGravity;
		// particles move in a circle instead
		//self.emitterMode = kCCParticleModeRadius;
		
		// some properties must only be used with a specific emitterMode!
		if (self.emitterMode == kCCParticleModeGravity)
		{
			// sourcePosition determines the offset where particles appear. The actual
			// center of gravity is the node's position.
			self.sourcePosition = CGPointMake(0, 0);
			// gravity determines the particle's speed in the x and y directions
			self.gravity = CGPointMake(3000, 0);
			// radial acceleration affects how fast particles move depending on their distance to the emitter
			// positive radialAccel means particles speed up as they move away, negative means they slow down
			self.radialAccel = 0;
			self.radialAccelVar = 0;
			// tangential acceleration lets particles rotate around the emitter position,
			// and they speed up as they rotate around (slingshot effect)
			self.tangentialAccel = 0;
			self.tangentialAccelVar = 0;
			// speed is of course how fast particles move in general
			self.speed = 0;
			self.speedVar = 103.3f;
		}
		else if (self.emitterMode == kCCParticleModeRadius)
		{
			// the distance from the emitter position that particles will be spawned and sent out
			// in a radial (circular) fashion
			self.startRadius = 100;
			self.startRadiusVar = 0;
			// the end radius the particles move towards, if less than startRadius particles will move
			// inwards, if greater than startRadius particles will move outward
			// you can use the keyword kCCParticleStartRadiusEqualToEndRadius to create a perfectly circular rotation
			self.endRadius = 10;
			self.endRadiusVar = 0;
			// how fast the particles rotate around
			self.rotatePerSecond = 180;
			self.rotatePerSecondVar = 0;
		}
        
		// EMITTER POSITION
		// emitter position is at the center of the node (default)
		// this is where new particles will appear
		// The positionType determines if existing particles should be repositioned when the node is moving
		// (kCCPositionTypeGrouped) or if the particles should remain where they are (kCCPositionTypeFree).
		self.positionType = kCCPositionTypeGrouped;
		
		// PARTICLE SIZE
		// size of individual particles in pixels
		self.startSize = 5;
		self.startSizeVar = 0.0f;
		self.endSize = 5;
		self.endSizeVar = 0;
        
		// ANGLE (DIRECTION)
		// the direction in which particles are emitted, 0 means upwards
		self.angle = 360;
		self.angleVar = 360;
		
		// PARTICLE LIFETIME
		// how long each individual particle will "live" (eg. stay on screen)
		self.life = 0.0f;
		self.lifeVar = .07f;
		
		// PARTICLE EMISSION RATE
		// how many particles per second are created (emitted)
		// particle creation stops if self.particleCount >= self.totalParticles
		// you can use this to create short burst effects with pauses between each burst
		self.emissionRate = 1000;
		// normally set with initWithTotalParticles but you can change that number
        
		// PARTICLE COLOR
		// A valid startColor must be set! Otherwise the particles may be invisible. The other colors are optional.
		// These colors determine the color of the particle at the start and the end of its lifetime.
		startColor.r = 1.0f;
		startColor.g = 0.77f;
		startColor.b = 0.32f;
		startColor.a = 0.33f;
        
		startColorVar.r = 1.0f;
		startColorVar.g = 0.0f;
		startColorVar.b = 0.0f;
		startColorVar.a = 0.33f;
		
		endColor.r = 1.0f;
		endColor.g = 0.0f;
		endColor.b = 0.0f;
		endColor.a = 1.0f;
		
		endColorVar.r = 1.0f;
		endColorVar.g = 0.0f;
		endColorVar.b = 0.0f;
		endColorVar.a = 0.0f;
		
		// BLEND FUNC
		// blend func influences how transparent colors are calculated
		// the first parameter is for the source, the second for the target
		// available blend func parameters are:
		// GL_ZERO   GL_ONE   GL_SRC_COLOR   GL_ONE_MINUS_SRC_COLOR   GL_SRC_ALPHA
		// GL_ONE_MINUS_SRC_ALPHA   GL_DST_ALPHA   GL_ONE_MINUS_DST_ALPHA
		self.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_DST_ALPHA};
		// shortcut to set the blend func to: GL_SRC_ALPHA, GL_ONE
		//self.blendAdditive = YES;
		
		// PARTICLE TEXTURE
		self.texture = [[CCTextureCache sharedTextureCache] addImage:@"bullet.png"];
	}
	
	return self;
}

-(void) enable
{
    active = YES;
}

-(void) disable
{
    active = NO;
}
@end
