
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
  _invalidated = NO;
  
  [self createTiles];
  
  _initialised = YES;
  
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
  
  /* Next, we perform our standard iteration for initialising */
  for (int x = 0; x < _boardSize.width; x++) {
    
    for (int y = 0; y < _boardSize.height; y++) {
      
      /* Initialise our tile and set it's position and size */
      [self createTileForPoint:(CGPoint){.x=x,.y=y}];
    }
  }
}

/**
 * Constructs a tile for the given index into the board, sizes and places it into 
 * the appropriate location in the _tiles array and adds as a child.
 *
 * @param point The point to create the tile at.
 *
 * @return Returns a pointer to the created tile.
 */
-(TTile *) createTileForPoint:(CGPoint)point {
  
  int colourValue = 1 + (arc4random() % 4);
  TColour *colour = [TColour colourForNum:colourValue];
  
  TTile *tile = [TTile tileWithColour:colour];
  
  /* Add first, so that normalised scaling works */
  [self addChild:tile];
  
  int index = [self indexFromPoint:point];
  
  /* Only do replace if we've initialised everything (therefore _tiles will be populated
     to do a replace */
  if (_initialised) {
    [_tiles replaceObjectAtIndex:index withObject:tile];
  } else {
    [_tiles addObject:tile];
  }
  
  /* Anchor our tiles at lower left */
  [tile setAnchorPoint:ccp(0,0)];
  
  [tile setPositionType:CCPositionTypeNormalized];
  [tile setContentSizeType:CCSizeTypeNormalized];
  
  CGSize size = (CGSize){.width=1/_boardSize.width,.height=1/_boardSize.height};
  CGPoint pos = (CGPoint){.x=point.x*size.width, .y=point.y*size.height};
  
  [tile setPosition:pos];
  [tile setContentSize:size];
  
  /* Scale our texture to fit content size */
  [tile setScaleX:tile.contentSizeInPoints.width/tile.textureRect.size.width];
  [tile setScaleY:tile.contentSizeInPoints.height/tile.textureRect.size.height];
  
  return tile;
}

#pragma mark Tile Accessing

/**
 * Takes a given index into the board and returns the position it represents in
 * world-space.
 *
 * @param point The position on the board
 * @return Returns a position in world-space coordinates representing lower-left of the
 *         index.
 */
-(CGPoint) convertIndexToWorldSpace:(CGPoint)point {
  
  return (CGPoint){.x=(1/_boardSize.width)*point.x,
                   .y=(1/_boardSize.height)*point.y};
}

/**
 * @return Takes the given point-index and converts it to an integer index into _tiles.
 * 
 * @note Returns -1 if index is invalid.
 */
-(int) indexFromPoint:(CGPoint)point {
  
  if (![self validIndex:point]) return -1;
  
  return (int)point.x * _boardSize.height + (int)point.y;
}

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
 *
 * @note Can return [NSNull null] if that is what's at the index
 */
-(TTile*) tileAtIndex:(CGPoint)point {
  
  /* Index iterates from bottom-up then left-right */
  uint index = [self indexFromPoint:point];
  
  /* Invalid point */
  if (index == -1) return nil;
  
  return _tiles[index];
}

#pragma mark Tile Collision

-(TTile *) hitTestWithTouch:(CGPoint)point {
  
  for (TTile *tile in _tiles) {
    if (tile == (id)[NSNull null]) continue;
    
    if ([tile containsPoint:point]) return tile;
  }
  
  return nil;
}

-(NSArray *) groupTestWithTouch:(CGPoint)point {
  
  /* Initiate our recursive search */
  TTile *tile = [self hitTestWithTouch:point];
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
      
      if (adjTile == (id)[NSNull null]) continue;
      
      /* If we haven't searched for this tile already and the colour is equal, search! */
      if (![searched containsObject:adjTile] &&  adjTile.Colour == tile.Colour) {
        
        [self tileGroupAtTile:adjTile withSearched:searched];
      }
    }
  }
}

#pragma mark Board Updates

-(void) update:(CCTime)delta {
  
  /* If the board has been flagged as invalid, we are required to iterate over the
     columns, check for NULL values and replace tiles as appropriate. */
  if (_invalidated) {
    
    /* Proceed column-by-column */
    for (int x = 0; x < _boardSize.width; x++) {
      
      int nullCount = 0;
      
      for (int y = 0; y < _boardSize.height; y++) {
        
        CGPoint index = (CGPoint){.x=x,.y=y};
        int intIndex = [self indexFromPoint:index];
        
        TTile *tile = [self tileAtIndex:index];
        
        /* Null tile, record and continue */
        if (tile == (id)[NSNull null]) {
          
          nullCount++;
          continue;
          
        /* Otherwise, move down by null-count amounts */
        } else if (nullCount > 0) {
          
          /* Exchange our null and tile */
          [_tiles exchangeObjectAtIndex:intIndex-nullCount withObjectAtIndex:intIndex];
          
          CGPoint newPosition = (CGPoint){.x=x,.y=(y-nullCount)};
          newPosition = [self convertIndexToWorldSpace:newPosition];
          
          /* Create a move action to move towards the lower position */
          [tile stopAllActions];
          
          id moveTo = [CCActionMoveTo actionWithDuration:TILE_DROP_DURATION position:newPosition];
          [tile runAction:moveTo];
        }
      }
      
      /* If we found some null tiles, replace them here */
      if (nullCount > 0) {
        
        for (int y = _boardSize.height - nullCount; y < _boardSize.height; y++) {
          
          /* Create a new tile for this position */
          TTile *tile = [self createTileForPoint:(CGPoint){.x=x,.y=y}];
          
          /* Move the tile to be above the furthest tile we can see and move downwards
             like the rest */
          CGPoint target = (CGPoint){.x=x,.y=y};
          CGPoint upper = (CGPoint){.x=x,.y=y+nullCount};
          
          [tile setPosition:[self convertIndexToWorldSpace:upper]];
          
          id moveTo = [CCActionMoveTo actionWithDuration:TILE_DROP_DURATION
                                                position:[self convertIndexToWorldSpace:target]];
          
          [tile stopAllActions];
          [tile runAction:moveTo];
        }
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
  
  /* Replace all tiles with boxed nil */
  for (int i = 0; i < _tiles.count; i++) {
    [_tiles replaceObjectAtIndex:i withObject:[NSNull null]];
  }
  
  [self removeAllChildrenWithCleanup:YES];
  
  _invalidated = YES;
}

/**
 * Removes all the tiles in the given array from this board, also handles
 * any other requirements (such as move actions, fading etc)
 *
 * @param tiles The array of tiles to remove from the board
 */
-(void) removeTiles:(NSArray *)tiles {
  
  for (TTile *tile in tiles) {
    
    int index = [_tiles indexOfObject:tile];
    
    /* Remove from our containers: our children and _tiles array */
    [_tiles replaceObjectAtIndex:index withObject:[NSNull null]];
    
    /* Fade out our tile */
    id fadeAction = [CCActionFadeOut actionWithDuration:TILE_FADE_DURATION];
    id removeAction = [CCActionCallBlock actionWithBlock:^{
      [self removeChild:tile];
    }];
    
    [tile runAction:[CCActionSequence actionOne:fadeAction two:removeAction]];
   
    /* Set invalidated if we've removed any tiles */
    _invalidated = YES;
  }
}

@end