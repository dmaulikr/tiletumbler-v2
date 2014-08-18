
#import "cocos2d.h"
#import "cocos2d-ui.h"

#define UI_FONT @"CaviarDreams.ttf"
#define UI_FONT_SIZE 18

/**
 * The GameHeader class represents the header at the top of the GameScene.
 * This handles displaying score, pause icon and any other items like time.
 * It also has properties for callbacks on button clicks and methods to update
 * labels with given values.
 */
@interface GameHeader : CCNode {
  
  /* Calculated on init - the font-size multiplied by scale value */
  float _fontSize;
  
  CCLabelTTF *_score;
  
  CCLabelTTF *_info;
  
  CCButton *_pause;
  
  /* Handles drawing the background fill */
  CCDrawNode *_background;
}

@property (readonly, getter = scorePosition) CGPoint ScorePosition;

#pragma mark Creation

/**
 * Creates a standard header with default UI values and size initialised as
 * width:1 height:0.1, positioned at the top of the screen. Sizes are norms.
 *
 * @param sizePoints 
 */
+(GameHeader *) headerWithSize:(CGSize)sizePoints;

#pragma mark Button Changes

/**
 * Call this method to display a button labelled 'finish' where the info-label should be.
 * This is for Zen mode as there is no info label present.
 *
 * @note Calling this method auto-hides the info too
 */
-(void) displayFinish;

#pragma mark Label Changes

/**
 * Call this method to hide the information label at
 * the top-right.
 */
-(void) hideInfo;

/**
 * Alerts the GameHeader to update the score label with a new value.
 *
 * @param value The new score-value to assign
 */
-(void) updateScore:(int)value;

/**
 * Updates the information label to display a new value. Formats as a time value
 * if isTime is true.
 *
 * @param value   The value to display
 * @param isTime  If true, this value will be display in timer format.
 */
-(void) updateInfo:(int)value withTime:(BOOL)isTime;

#pragma mark Responders

/* This block is called whenever pause is clicked */
@property (nonatomic,copy) void (^onPause)();

/* This block is called if the finish button is clicked */
@property (nonatomic,copy) void (^onFinish)();

@end
