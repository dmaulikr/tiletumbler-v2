
#import "cocos2d.h"

#import "TColour.h"

/* Our standard tile-sprite filename */
#define TILE_SPRITE @"TTile.png"

/**
 * TTile represents a Tile in our board. This is a simple class representing
 * only properties of the tile.
 *
 * @date 11/08/14
 * @author Ronan Turner
 */
@interface TTile : CCSprite

#pragma mark Creation

+(TTile *) tileWithColour:(TColour *)colour;

#pragma mark Properties

/* Pointer to our colour, TColour is a limited-instance class so comparisons
   are simple! */
@property (nonatomic,assign) TColour *Colour;

#pragma mark Point Interaction

/**
 * @return Returns true if this Tile contains the given point, false otherwise.
 */
-(BOOL) containsPoint:(CGPoint)point;

@end
