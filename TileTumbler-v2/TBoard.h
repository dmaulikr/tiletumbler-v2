
#import "cocos2d.h"

#import "TTile.h"

#define TILE_DROP_DURATION 0.5

#define TILE_FADE_DURATION 0.5

/**
 * TBoard represents a Tile-Board. This handles the control of a group of
 * tiles and provides an interface for interacting with these tiles.
 *
 * @date 11/08/14
 * @author Ronan Turner
 */
@interface TBoard : CCNode {
  
  /* Represents when the board has had an alteration and requires
     updating */
  BOOL _invalidated;
  
  /* Have we set everything up yet? */
  BOOL _initialised;
  
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

#pragma mark Tile Accessing

/**
 * Attempts to retrieve the tile at the given point and return it.
 *
 * @note This method should be used wherever possible - avoid *walking* the
 *       _tiles array instead.
 *
 * @param point The index, in cartesian form (x,y) of the tile.
 *
 * @return Returns the tile at the given index or nil if invalid.
 */
-(TTile *) tileAtIndex:(CGPoint)point;

#pragma mark Tile Collision

/**
 * Checks and returns the tile that contains the given point. If no tile
 * contains the point, return nil.
 *
 * @param  point The touch-location, in world-space.
 * @return Returns a pointer to TTile, otherwise nil if there
 *         is no tile at the given location.
 */
-(TTile *) hitTestWithTouch:(CGPoint)point;

/**
 * Finds and returns the group of connected tiles, with origin at the
 * given point. Connected tiles are defined as a continuous group of
 * adjacent, similarly coloured tiles. 
 *
 * @note Can return an empty array if the point doesn't correspond to any tile
 *
 * @param point The position of origin of the group (usually the touch pos.)
 *
 * @return Returns an NSArray with all the connected tiles, if there are none
 *         this will simply be the tile found at the given point.
 */
-(NSArray *) groupTestWithTouch:(CGPoint)point;

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
