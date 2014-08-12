
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
  
  CCLabelTTF *_score;
  
  CCLabelTTF *_timer;
  
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

#pragma mark Label Changes

/**
 * Alerts the GameHeader to update the score label with a new value.
 *
 * @param value The new score-value to assign
 */
-(void) updateScore:(int)value;

/**
 * Updates the timer label to a new value.
 *
 * @param value The number of seconds left in the game
 */
-(void) updateTimer:(int)value;

#pragma mark Responders

/* This block is called whenever pause is clicked */
@property (nonatomic,copy) void (^onPause)();

@end
