
#import "cocos2d.h"

#import "TBoard.h"
#import "GameHeader.h"
#import "OptionLayer.h"

#define TILE_CONNECTIONS 3

#define INITIAL_TIME 10

/**
 * GameScene is our actual main scene, handling interaction with the board,
 * tracking of score and game times and displaying UI elements.
 */
@interface GameScene : CCScene {
  
  /* The header */
  GameHeader *_header;
  OptionLayer *_options;
  
  /* The game board */
  TBoard *_board;
  
  /* Holds our current score */
  int _score;
  
  /* Holds the number of seconds left in this round. */
  float _timer;
  BOOL _gamePaused;
  
  /* Holds the last position of our touch */
  CGPoint _lastTouch;
}

+(GameScene *) scene;

@end
