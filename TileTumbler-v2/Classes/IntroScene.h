
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "TBoard.h"

@interface IntroScene : CCScene {
  TBoard *board;
}

+ (IntroScene *)scene;
- (id)init;

@end