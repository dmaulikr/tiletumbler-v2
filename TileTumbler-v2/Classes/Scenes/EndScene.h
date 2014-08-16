
#import "cocos2d.h"

#import "ModeScene.h"

/**
 * The EndScene represents the game-over scene and the display of the final
 * score, allowing the user to select a new game or menu.
 */
@interface EndScene : CCScene {
  
  /* Score and Mode of the previous round */
  int _score;
  int _highScore;
  GameMode _mode;
  
  /* Button-labels */
  CCLabelTTF *playLabel;
  CCLabelTTF *menuLabel;
}

+(EndScene*) sceneWithScore:(int)score forMode:(GameMode)mode;

@end
