
#import "GameScene.h"
#import "EndScene.h"
#import "IntroScene.h"

#import "Utility.h"

@implementation GameScene

#pragma mark Create & Initialisation

+(GameScene *) sceneWithType:(GameModeType)type {
  return [[self alloc] initWithType:type];
}

-(instancetype) initWithType:(GameModeType)type {
  
  self = [super init];
  if (!self) return nil;
  
  _mode = type.mode;
  _timer = type.seconds;
  _touchLimit = type.touches;
  
  [self createBoard];
  [self createHeader];
  
  self.userInteractionEnabled = YES;
  
#ifdef ANDROID
  UISystemInterfaceVisibilityStyle style = UISystemInterfaceVisibilityStyleLowProfile;
  [UIApplication sharedApplication].systemInterfaceVisibilityStyle = style;
#endif
  
  return self;
}

/**
 * Initialises a default Tile board. Handles creating it at appropriate
 * size based on device.
 */
-(void) createBoard {
  
  _board = [TBoard boardWithSize:[Utility computeBoardSize]];
  
  [_board setContentSizeType:CCSizeTypeNormalized];
  [_board setContentSize:(CGSize){.width=1,.height=1}];
  
  [_board setPositionType:CCPositionTypeNormalized];
  [_board setPosition:ccp(0,0)];
  
  [self addChild:_board z:0];
}

/**
 * Initialises a header interface object and assigns appropriate values
 * to it's labels and callbacks
 */
-(void) createHeader {
  
  CGSize headerSize = (CGSize){.width=1*self.contentSizeInPoints.width,
                .height=(1/(float)_board.TileHeight)*self.contentSizeInPoints.height};
  _header = [GameHeader headerWithSize:headerSize];
  
  [_header updateScore:_score];
  
  /* Display information label differently based on game mode */
  if (_mode == kModeTimed) {
    [_header updateInfo:_timer withTime:YES];
  } else if (_mode == kModeTouch) {
    [_header updateInfo:_touchLimit withTime:NO];
  } else {
    [_header displayFinish];
  }
  
  __weak GameScene* weakSelf = self;
  _header.onPause = ^() {
    [weakSelf pauseChosen];
  };
  _header.onFinish = ^() {
    /* End the game */
    [weakSelf finishChosen];
  };
  
  [_header setPositionType:CCPositionTypeNormalized];
  [_header setPosition:(CGPoint){.x=0,.y=1-(1/(float)_board.TileHeight)}];
  
  [self addChild:_header z:1];
}

#pragma mark Board Interaction

/**
 * This method handles responding to the event of the user touching a tile
 * that is a member of the connected group of tiles, tiles.
 *
 * @param tiles The tile group that the user has selected.
 */
-(void) groupTouched:(NSArray *)tiles {
  
  /* If we don't have enough tiles in the group, return */
  if (tiles.count < TILE_CONNECTIONS) return;
  
  /* Otherwise, remove the tiles and add to score */
  [_board removeTiles:tiles];
  [[OALSimpleAudio sharedInstance] playEffect:@"tile-hit.mp3"];
  
  [self initScoreChange:(int)tiles.count];
}

#pragma mark Touch Interaction

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  /* Don't process the touch if game end reached */
  if (_gameEnded) return;
  
  _lastTouch = [touch locationInWorld];
  NSArray *group = [_board groupTestWithTouch:_lastTouch];
  
  [self groupTouched:group];
  
  /* Updates if game mode is touch based */
  if (_mode == kModeTouch) {
    
    /* Only increase touch limit if we touched a group of min. number or more. */
    if (group.count >= TILE_CONNECTIONS) {
      _touchLimit--;
    }
    
    if (_touchLimit <= 0) {
      
      _gameEnded = YES;
    }
    
    [_header updateInfo:_touchLimit withTime:NO];
  }
}

#pragma mark Game State

/**
 * Handles responding when finish pressed on UI Header
 */
-(void) finishChosen {
  
  _gameEnded = YES;
  
  /* If we don't have any score-change labels, transition immediately, otherwise score-change
     label will do so when finished. */
  if (![self getChildByName:@"change" recursively:NO]) {
    [self transitionToEnd];
  }
}

/**
 * Handles responding to the pause button being pressed
 */
-(void) pauseChosen {
  
  if (_options == nil) {
    
    _options = [OptionLayer layerWithMenu:YES];
    
    [_options setPosition:(CGPoint){.x=0,.y=0}];
    
    __weak GameScene* weakSelf = self;
    _options.onReturn = ^() {
      [weakSelf optionsReturn];
    };
    
    [self addChild:_options z:5];
  }
  
  [_options setVisible:YES];
  _gamePaused = YES;
}

-(void) optionsReturn {
  
  /* Hide options away again and resume */
  [_options setVisible:NO];
  _gamePaused = NO;
}

/**
 * Transitions from this scene to the EndScene, used when the game has been ended.
 */
-(void) transitionToEnd {
  
  CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
  
  [[CCDirector sharedDirector] replaceScene:[EndScene sceneWithScore:_score forMode:_mode] withTransition:trans];
}

/**
 * Handles all standard updates of the game - mostly managing the game
 * state and handling round over scenarios.
 */
-(void) update:(CCTime)delta {
  
  if (_gamePaused) return;
  if (_gameEnded) return;
  
  /* Updates if game-mode is timed */
  if (_mode == kModeTimed) {
    
    _timer -= delta;
    
    if (_timer <= 0) {
      
      _gameEnded = YES;
      
      /* If we have no running score change actions, call timer-ended, otherwise the
         score change will do it when it finishes. */
      if (![self getChildByName:@"change" recursively:NO]) {
        
        [self transitionToEnd];
      }
    }
    
    [_header updateInfo:_timer withTime:YES];
  }
}

/**
 * This method handles displaying the score change label and move
 * actions towards the score, then adding the score using a callback.
 *
 * @param scoreChange The score value to add.
 */
-(void) initScoreChange:(int)scoreChange {
  
  CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d", scoreChange] fontName:UI_FONT fontSize:[Utility scaledFont:UI_FONT_SIZE]];
  scoreLabel.name = @"change";
  
  [scoreLabel setPosition:_lastTouch];
  
  /* Create sequence of move / fade actions */
  CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:1 position:_header.ScorePosition];
  
  CCActionFadeTo *fadeTo = [CCActionFadeTo actionWithDuration:1 opacity:0.5];
  
  /* Create a callback to update score and remove label when done */
  CCActionCallBlock *callback = [CCActionCallBlock actionWithBlock:^{
    [self updateScore:scoreChange];
    [self removeChild:scoreLabel];
    
    if (_gameEnded && ![self getChildByName:@"change" recursively:NO]) {
      [self transitionToEnd];
    }
  }];
  
  /* Spawn the fade and move actions at the same time */
  CCActionSpawn *spawnActions = [CCActionSpawn actionOne:moveTo two:fadeTo];
  
  CCActionSequence *seq = [CCActionSequence actions:spawnActions, callback, nil];
  
  /* Call this sequence */
  [scoreLabel runAction:seq];
  [self addChild:scoreLabel z:2];
}

/**
 * Adds the given value to the score and handles any appropriate response
 * required.
 *
 * @param scoreChange the value to add to the score
 */
-(void) updateScore:(int)scoreChange {
  
  _score += scoreChange;
  [_header updateScore:_score];
}

@end
