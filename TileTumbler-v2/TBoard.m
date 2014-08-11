
#import "TBoard.h"

@implementation TBoard

#pragma mark Creation

+(TBoard *) boardWithSize:(CGSize)size {
  
  return [[self alloc] initWithSize:size];
}

-(instancetype) initWithSize:(CGSize)size {
  
  self = [super init];
  if (!self) return nil;
  
  /* Assign our size */
  _boardSize = size;
  
  /* Set our content size to be fullscreen */
  self.contentSize = [CCDirector sharedDirector].viewSize;
  _tiles = [NSMutableArray array];
  
  [self createTiles];
  
  return self;
}

-(instancetype) init {
  
  NSAssert(false, @"TBoard initialised outwith standard method.");
  return nil;
}

#pragma mark Board Initialisation

/**
 * Create tiles will randomly initialise all the tiles for our board, it
 * assumes the size assigned in _boardSize to be our desired size.
 *
 * @note Removes and cleans up *all* tiles in _tiles!
 */
-(void) createTiles {
  
  /* Firstly, clear the entire board */
  [self clearBoard];
  
  /* Normalised sizing */
  float xWidth = 1 / _boardSize.width;
  float yWidth = 1 / _boardSize.height;
  
  CGSize size = (CGSize){.width = xWidth, .height = yWidth};
  
  /* Next, we perform our standard iteration for initialising */
  for (int x = 0; x < _boardSize.width; x++) {
    float xPos = xWidth * (float)x;
    
    for (int y = 0; y < _boardSize.height; y++) {
      float yPos = yWidth * (float)y;
      
      int colourValue = 1 + (arc4random() % 4);
      TColour *colour = [TColour colourForNum:colourValue];
      
      /* Initialise our tile and set it's position and size */
      TTile *tile = [TTile tileWithColour:colour];
      
      /* Add first, so that normalised scaling works */
      [self addChild:tile];
      [_tiles addObject:tile];
      
      /* Anchor our tiles at lower left */
      [tile setAnchorPoint:ccp(0,0)];
      
      [tile setPositionType:CCPositionTypeNormalized];
      [tile setContentSizeType:CCSizeTypeNormalized];
      
      [tile setPosition:ccp(xPos, yPos)];
      [tile setContentSize:size];
      
      /* Scale our texture to fit content size */
      [tile setScaleX:tile.contentSizeInPoints.width/tile.textureRect.size.width];
      [tile setScaleY:tile.contentSizeInPoints.height/tile.textureRect.size.height];
    }
  }
}

#pragma mark Tile Collision

-(TTile *) tileAtPoint:(CGPoint)point {
  
  for (TTile *tile in _tiles) {
    if ([tile containsPoint:point]) return tile;
  }
  
  return nil;
}

#pragma mark Destroy

/**
 * The task of this method is to remove all current tiles, actions and any
 * state related things from the Board, essentially a clean-slate.
 */
-(void) clearBoard {
  
  [self removeAllChildrenWithCleanup:YES];
  [_tiles removeAllObjects];
}

@end