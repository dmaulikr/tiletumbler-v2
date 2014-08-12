
#import "cocos2d.h"

/**
 * The EndScene represents the game-over scene and the display of the final
 * score, allowing the user to select a new game or menu.
 */
@interface EndScene : CCScene {
  
  /* Current score dispalyed */
  int _score;
  
  /* Button-labels */
  CCLabelTTF *playLabel;
  CCLabelTTF *menuLabel;
}

+(EndScene*) sceneWithScore:(int)score;

@end
