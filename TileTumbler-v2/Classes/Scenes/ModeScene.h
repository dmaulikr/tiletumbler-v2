
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "TileDropLayer.h"

/**
 * Represents our potential game-modes, used in struct
 * to pass game mode information
 */
typedef enum {
  kModeZen=2,
  kModeTimed=0,
  kModeTouch=1
} GameMode;

struct GameModeType {
  GameMode mode;
  
  // Holds touch limit for this mode
  int touches;
  
  // Holds seconds limit for this mode
  int seconds;
};
typedef struct GameModeType GameModeType;

/**
 * ModeScene displays a selection between the various
 * game modes we can use and displays information, allowing
 * cycling through and picking one.
 */
@interface ModeScene : CCScene {
  
  /* Mode names */
  NSArray *_names;
  
  /* Time limits */
  NSArray *_times;
  
  /* Touch limits */
  NSArray *_touches;
  
  /* Stores the current game mode as an index */
  int _currentMode;
  
  /* Labels for display */
  CCLabelTTF *_modeLabel;
  CCLabelTTF *_timeLabel;
  CCLabelTTF *_touchLabel;
  
  /* Makeshift button from label to use kerning */
  CCLabelTTF *_continueButton;
  
  /* Buttons for cycling game modes */
  CCButton *_leftButton;
  CCButton *_rightButton;
}

#pragma mark Creation

+(ModeScene*) scene;

/**
 * Callback for a button being clicked on.
 */
-(void) buttonChosen:(id)sender;

@end
