
#import "cocos2d.h"

#import "TTile.h"

/**
 * TBoard represents a Tile-Board. This handles the control of a group of
 * tiles and provides an interface for interacting with these tiles.
 *
 * @date 11/08/14
 * @author Ronan Turner
 */
@interface TBoard : CCNode {
  
  /* Represents the size in tile-units of the board */
  CGSize _boardSize;
  
  /* Our collection of tiles. */
  NSMutableArray *_tiles;
}

#pragma mark Creation

/**
 * Creates and initialises a board with the given width/height of tiles.
 * These tiles will be initialised with a random colour.
 */
+(TBoard *) boardWithSize:(CGSize)size;

#pragma mark Tile Collision

/**
 * Checks and returns the tile that contains the given point. If no tile
 * contains the point, return TTileNotFound.
 *
 * @param  point The touch-location, in world-space.
 * @return Returns a pointer to TTile, otherwise nil if there
 *         is no tile at the given location.
 */
-(TTile *) tileAtPoint:(CGPoint)point;

#pragma mark Tile Removals

/**
 * Removes all the given tiles from this TBoard.
 *
 * @param tiles An array containing TTile pointers to remove.
 */
-(void) removeTiles:(NSArray *)tiles;

#pragma mark Event Callbacks

/* A block that is called when we have no more valid groups to remove */
@property (nonatomic,copy) void (^onNoGroups)();

@end
