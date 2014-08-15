
#import "TileDropLayer.h"
#import "TTile.h"

@implementation TileDropLayer

+(TileDropLayer*) layerWithTime:(float)spawn minX:(float)minX maxX:(float)maxX shouldFlip:(BOOL)flip {
  return [[self alloc] initWithTime:spawn minX:minX maxX:maxX shouldFlip:flip];
}

-(instancetype) initWithTime:(float)spawn minX:(float)minX maxX:(float)maxX shouldFlip:(BOOL)flip {
  
  self = [super init];
  if (!self) return nil;
  
  // Default to full screen
  self.contentSize = [CCDirector sharedDirector].viewSize;
  
  _minX = minX;
  _maxX = maxX;
  _tryFlip = flip;
  _spawnTime = spawn;
  
  _timeTillSpawn = _spawnTime;
  
  return self;
}

-(void) spawnRandomTile {
  
  /* Calculate positioning */
  float xPos = _minX + CCRANDOM_0_1() * (_maxX - _minX);
  float yPos = 1.2;
  
  if (_tryFlip && arc4random() % 2 == 0) {
    xPos = 1 - xPos;
  }
  
  /* Spawn a tile */
  TTile *tile = [TTile tileWithColour:[TColour colourForNum:1 + arc4random() % 4]];
  
  [tile setPositionType:CCPositionTypeNormalized];
  [tile setPosition:(CGPoint){.x=xPos, .y=yPos}];
  
  [tile setAnchorPoint:(CGPoint){.x=0.5, .y=0}];
  
  [tile setContentSizeType:CCSizeTypeNormalized];
  
  // XXX: Access board size from elsewhere?
  CGSize size = (CGSize){.width=0.1,.height=1.0/14.0};
  [tile setContentSize:size];
  
  [self addChild:tile];
  
  /* Scale our texture to fit content size */
  [tile setScaleX:tile.contentSizeInPoints.width/tile.textureRect.size.width];
  [tile setScaleY:tile.contentSizeInPoints.height/tile.textureRect.size.height];
  
  /* Create actions */
  CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:4 position:(CGPoint){.x=0,.y=-yPos}];
  CCActionFadeOut *fade = [CCActionFadeOut actionWithDuration:7];
  CCActionSpawn *spawn = [CCActionSpawn actionOne:moveBy two:fade];
  
  CCActionCallBlock *remove = [CCActionCallBlock actionWithBlock:^{
    [self removeChild:tile];
  }];
  
  /* Set the actions in motion */
  [tile runAction:[CCActionSequence actionOne:spawn two:remove]];
}

-(void) update:(CCTime)delta {
  
  _timeTillSpawn -= delta;
  
  if (_timeTillSpawn <= 0) {
    
    [self spawnRandomTile];
    _timeTillSpawn = _spawnTime + CCRANDOM_MINUS1_1();
  }
}

@end