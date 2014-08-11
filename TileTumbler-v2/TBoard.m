
#import "TBoard.h"

/* Returns true if x <= y <= z */
#define WITHIN(x,y,z) x <= y && y <= z

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

#pragma mark Tile Accessing

/**
 * @return Returns true if this point contains a valid 'board index' which 
 *         points to an (x,y) of a tile in the board.
 */
-(BOOL) validIndex:(CGPoint)point {
  
  return point.x < _boardSize.width
          && point.y < _boardSize.height
          && point.x >= 0
          && point.y >= 0;
}

/**
 * @return Returns the tile contained at the given index into the board.
 */
-(TTile*) tileAtIndex:(CGPoint)point {
  
  if (![self validIndex:point]) return nil;
  
  /* Index iterates from bottom-up then left-right */
  uint index = (int)point.x * _boardSize.height + (int)point.y;
  return _tiles[index];
}

#pragma mark Tile Collision

-(TTile *) tileAtPoint:(CGPoint)point {
  
  for (TTile *tile in _tiles) {
    if ([tile containsPoint:point]) return tile;
  }
  
  return nil;
}

-(NSArray *) tileGroupAtPoint:(CGPoint)point {
  
  /* Initiate our recursive search */
  TTile *tile = [self tileAtPoint:point];
  if (tile == nil) return [NSArray array];
  
  NSMutableArray *group = [NSMutableArray array];
  [self tileGroupAtTile:tile withSearched:group];
  
  /* Return an immutable NSArray from our group */
  return [NSArray arrayWithArray:group];
}

/**
 * This is our hidden, inside implementation of the recursive searching for tiles. Asks
 * for an array to add valid adjacent tiles to and a starting tile to initiate the search
 * from.
 *
 * @param tile      The central tile to begin searching adjacents for.
 * @param searched  An array both containing the current searched tiles and a place to 
 *                  store our found adjacent tiles in.
 */
-(void) tileGroupAtTile:(TTile *)tile withSearched:(NSMutableArray *)searched {
  
  /* Add our search tile to the array */
  [searched addObject:tile];
  
  /* Find our index of the given tile */
  uint intIndex = [_tiles indexOfObject:tile];
  CGPoint index = (CGPoint){.x=intIndex / (int)_boardSize.height,
                            .y=intIndex % (int)_boardSize.height};
  
  /* Create an array of all possible adjacent indices */
  NSArray *adjacents = @[[NSValue valueWithCGPoint:(CGPoint){.x=index.x-1,.y=index.y}],
                         [NSValue valueWithCGPoint:(CGPoint){.x=index.x+1,.y=index.y}],
                         [NSValue valueWithCGPoint:(CGPoint){.x=index.x,.y=index.y+1}],
                         [NSValue valueWithCGPoint:(CGPoint){.x=index.x,.y=index.y-1}]];
  
  /* Iterate over possible indices and add if the adjacent tile is the same colour */
  for (NSValue *pointVal in adjacents) {
    CGPoint adjPoint = [pointVal CGPointValue];
    
    /* Ensure valid bounds for our index */
    if ([self validIndex:adjPoint]) {
      
      TTile *adjTile = [self tileAtIndex:adjPoint];
      
      /* If we haven't searched for this tile already and the colour is equal, search! */
      if (![searched containsObject:adjTile] &&  adjTile.Colour == tile.Colour) {
        
        [self tileGroupAtTile:adjTile withSearched:searched];
      }
    }
  }
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

/**
 * Removes all the tiles in the given array from this board, also handles
 * any other requirements (such as move actions, fading etc)
 *
 * @param tiles The array of tiles to remove from the board
 */
-(void) removeTiles:(NSArray *)tiles {
  
  for (TTile *tile in tiles) {
    
    /* Remove from our containers: our children and _tiles array */
    if (tile.parent == self) [self removeChild:tile];
    [_tiles removeObject:tile];
  }
}

@end