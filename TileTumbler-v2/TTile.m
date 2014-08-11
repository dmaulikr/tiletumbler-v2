
#import "TTile.h"

@implementation TTile

#pragma mark Creation

+(TTile *) tileWithColour:(TColour *)colour {
  
  return [[self alloc] initWithColour:colour];
}

-(instancetype) initWithColour:(TColour *)colour {
  
  self = [super initWithImageNamed:TILE_SPRITE];
  if (!self) return nil;
  
  /* Assign our colour */
  self.Colour = colour;
  
  return self;
}

-(instancetype) init {
  
  NSAssert(false, @"TTile initialised outwith standard method.");
  return nil;
}

#pragma mark Setters

-(void) setColour:(TColour *)Colour {
  
  _Colour = Colour;
  
  // Assign the colour
  [self setColor:Colour.color];
}

#pragma mark Point Interaction

-(BOOL) containsPoint:(CGPoint)point {
  
  /* Super class handles conversion between node-spaces */
  return [self hitTestWithWorldPos:point];
}

@end
