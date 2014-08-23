
#import "EndScene.h"
#import "TColour.h"
#import "Utility.h"

#import "GameScene.h"
#import "IntroScene.h"

@implementation EndScene

+(EndScene*) sceneWithScore:(int)score forMode:(GameMode)mode {
  return [[self alloc] initWithScore:score forMode:mode];
}

-(instancetype) initWithScore:(int)score forMode:(GameMode)mode {
  
  self = [super init];
  if (!self) return nil;
  
  self.contentSize = [CCDirector sharedDirector].viewSize;
  
  _score = score;
  _mode = mode;
  
  /* Load previous high score from local storage */
  [self loadScore];
  [self saveScore];
  [self displayHighScore];
  
  [self createBackground];
  [self createTitle];
  [self createScoreLabel];
  [self createButtons];
  
  self.userInteractionEnabled = YES;
  
  return self;
}

-(void) createBackground {
  
  CGSize size = [CCDirector sharedDirector].viewSize;
  
  CCSprite *background = [CCSprite spriteWithImageNamed:@"Bg.png"];
  
  [background setScaleX:size.width / background.contentSize.width];
  [background setScaleY:size.height / background.contentSize.height];
  
  [background setPositionType:CCPositionTypeNormalized];
  [background setPosition:(CGPoint){.x=0.5, .y=0.5}];
  
  [self addChild:background z:0];
}

-(void) createTitle {
  
  CCLabelTTF *title = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"ROUND OVER" withSize:28]];
  
  [title setColor:[TColour colourOne].color];
  
  [title setPositionType:CCPositionTypeNormalized];
  [title setPosition:(CGPoint){.x=0.5, .y=0.8}];
  
  [self addChild:title z:2];
}

-(void) createScoreLabel {
  
  NSString *scoreString = [Utility formatScore:_score];
  scoreString = [NSString stringWithFormat:@"SCORE: %@", scoreString];
  
  CCLabelTTF *score = [CCLabelTTF labelWithAttributedString:[Utility uiString:scoreString withSize:26]];
  
  [score setColor:[TColour colourThree].color];
  
  [score setPositionType:CCPositionTypeNormalized];
  [score setPosition:(CGPoint){.x=0.5, .y=0.58}];
  
  [self addChild:score z:2];
}

-(void) createButtons {
  
  playLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"PLAY AGAIN" withSize:22]];
  menuLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"MAIN MENU" withSize:22]];
  
  [playLabel setColor:[TColour colourTwo].color];
  [menuLabel setColor:[TColour colourFour].color];
  
  [playLabel setPositionType:CCPositionTypeNormalized];
  [menuLabel setPositionType:CCPositionTypeNormalized];
  
  [playLabel setPosition:(CGPoint){.x=0.5,.y=0.25}];
  [menuLabel setPosition:(CGPoint){.x=0.5,.y=0.15}];
  
  [self addChild:playLabel z:2];
  [self addChild:menuLabel z:2];
}

/**
 * This method is called after loading the high score, it displays a new high
 * score message if the current score is greater than the known high score.
 */
-(void) displayHighScore {
  
  /* Assign to high score if score is greater */
  if (_score > _highScore) _highScore = _score;
  
  NSString *scoreString = [Utility formatScore:_highScore];
  scoreString = [NSString stringWithFormat:@"HIGHEST: %@", scoreString];
  
  CCLabelTTF *label = [CCLabelTTF labelWithAttributedString:[Utility uiString:scoreString withSize:21]];
  
  [label setPositionType:CCPositionTypeNormalized];
  [label setPosition:(CGPoint){.x=0.5, .y=0.45}];
  
  [label setColor:[TColour colourThree].color];
  
  [self addChild:label z:3];
}

#pragma mark Score State

/**
 * Loads the score, either from the user defaults or from the GameCenter if the
 * local player is authenticated. Compares this score to the current given for
 * displaying of high-score.
 */
-(void) loadScore {
  
  /* Get the leaderboard id */
  NSString *leaderboardId;
  
  switch (_mode) {
    case kModeTimed:
      leaderboardId = @"Timed.Tile.Total";
      break;
      
    case kModeTouch:
      leaderboardId = @"Touches.Tile.Total";
      break;
      
    case kModeZen:
      leaderboardId = @"Zen.Tile.Total";
      break;
      
    default:
      leaderboardId = @"Timed.Tile.Total";
      break;
  }
  
  /* Load the high score based on leaderboard id from local defaults, if not
   present, high score will be 0. */
  _highScore = [[NSUserDefaults standardUserDefaults] integerForKey:leaderboardId];
}

/**
 * Handles saving the current score to the game center leaderboards. Does so
 * based on game mode.
 */
-(void) saveScore {
  
  /* Only save a new high score - don't spam the leaderboards. */
  if (_score < _highScore) return;
  
  /* Get the leaderboard id */
  NSString *leaderboardId;
  
  switch (_mode) {
    case kModeTimed:
      leaderboardId = @"Timed.Tile.Total";
      break;
      
    case kModeTouch:
      leaderboardId = @"Touches.Tile.Total";
      break;
      
    case kModeZen:
      leaderboardId = @"Zen.Tile.Total";
      break;
      
    default:
      leaderboardId = @"Timed.Tile.Total";
      break;
  }
  
  /* Save the high score based on leaderboard id from local defaults */
  [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:leaderboardId];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark Touch Interaction

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  /* Custom test for label interaction, to be able to use NSAttributedString */
  if ([playLabel hitTestWithWorldPos:[touch locationInWorld]]) {
    
    /* Transition to GameScene */
    CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
    
    [[CCDirector sharedDirector] replaceScene:[ModeScene scene] withTransition:trans];
  } else if ([menuLabel hitTestWithWorldPos:[touch locationInWorld]]) {
    
    /* Transition to Main Menu */
    CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
    
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:trans];
  }
}

@end
