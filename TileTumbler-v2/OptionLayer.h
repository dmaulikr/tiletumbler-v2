
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "TileDropLayer.h"

/**
 * The OptionLayer is a node that displays various sliders and toggle-
 * buttons that allow for customisations. This is displayed when the user
 * selects Pause and when Options are selected from the main menu.
 */
@interface OptionLayer : CCNode {
  
  CCLabelTTF *titleLabel;
  CCLabelTTF *returnLabel;
  CCLabelTTF *menuLabel;
  BOOL _showMenu;
  
  /* Toggle Area */
  CCButton *musicToggle;
  BOOL _musicOn;
  
  CCButton *fxToggle;
  BOOL _fxOn;
  
  /* Slider Area */
  CCSlider *musicSlider;
  CCSlider *fxSlider;
}

#pragma mark Creation

/* Creates and initialises a standard layer */
+(OptionLayer*) layerWithMenu:(BOOL)showMenu;

#pragma mark Callback Events

/* Block called when return is selected */
@property (nonatomic,copy) void (^onReturn)();

@end
