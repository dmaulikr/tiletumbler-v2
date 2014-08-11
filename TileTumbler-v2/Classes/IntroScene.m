
#import "IntroScene.h"

@implementation IntroScene

#pragma mark - Create & Destroy

+(IntroScene *) scene
{
	return [[self alloc] init];
}

-(id) init {
  self = [super init];
  if (!self) return(nil);
  
  // Test our TBoard
  board = [TBoard boardWithSize:(CGSize){.width=10,.height=14}];
  
  [board setContentSizeType:CCSizeTypeNormalized];
  [board setContentSize:(CGSize){.width=1,.height=1}];
  
  [board setPositionType:CCPositionTypeNormalized];
  [board setPosition:ccp(0,0)];
  
  [self addChild:board];
  
  self.userInteractionEnabled = YES;
  
  return self;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  TTile *tile;
  
  if ((tile = [board tileAtPoint:[touch locationInWorld]])) {
    tile.Colour = [TColour colourThree];
  }
}

@end
