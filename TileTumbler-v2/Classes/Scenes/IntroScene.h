
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "OptionLayer.h"
#import "TileDropLayer.h"

#import "TBoard.h"

#define UI_FONT @"CaviarDreams.ttf"

#define TILE_SPAWN 2

@interface IntroScene : CCScene {
  
  CCSprite *_background;
  
  CCLabelTTF *_titleText1;
  CCLabelTTF *_titleText2;
  
  CCLabelTTF *_button1;
  CCLabelTTF *_button2;
  
  OptionLayer *_options;
  
  /* Spawns random tiles as a background */
  TileDropLayer *_dropLayer;
}

+ (IntroScene *)scene;
- (id)init;

@end