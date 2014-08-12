
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "OptionLayer.h"

#import "TBoard.h"

#define UI_FONT @"CaviarDreams.ttf"

@interface IntroScene : CCScene {
  
  CCDrawNode *_background;
  
  CCLabelTTF *_titleText1;
  CCLabelTTF *_titleText2;
  
  CCLabelTTF *_button1;
  CCLabelTTF *_button2;
  
  OptionLayer *_options;
}

+ (IntroScene *)scene;
- (id)init;

@end