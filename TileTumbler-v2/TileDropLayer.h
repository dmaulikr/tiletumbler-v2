
#import "cocos2d.h"

/**
 * This class is an aesthetic class that represents
 * randomly spawning tiles that appear and drop to the
 * bottom of the screen then fade away.
 */
@interface TileDropLayer : CCNode {
  
  /* The spawn time, times will be +/- 1 from this time. */
  float _spawnTime;
  
  /* The min/max x-values to spawn a tile at. */
  float _minX;
  float _maxX;
  
  /* Should we randomly flip the x-coordinate to other
     side of the screen? */
  BOOL _tryFlip;
  
  /* Countdown timer for spawning tiles */
  float _timeTillSpawn;
}

/**
 * This method can be custom called to spawn a random tile,
 * not interfering with the timing of the object.
 */
-(void) spawnRandomTile;

/**
 * Creates a new tile layer to spawn random tiles.
 *
 * @param spawn The average time of each time
 * @param minX  The minimum-x position in normalized points
 * @param maxX  The maximum-x position in normalized points
 * @param flip  If we should attempt to flip the x-coord 
 *              at times, allowing for symmetry.
 */
+(TileDropLayer *) layerWithTime:(float)spawn minX:(float)minX maxX:(float)maxX shouldFlip:(BOOL)flip;

@end
