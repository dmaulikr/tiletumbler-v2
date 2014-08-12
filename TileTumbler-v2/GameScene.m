
#import "GameScene.h"

@implementation GameScene

#pragma mark Create & Initialisation

+(GameScene *) scene {
  return [[self alloc] init];
}

-(instancetype) init {
  
  self = [super init];
  if (!self) return nil;
  
  [self createBoard];
  [self createHeader];
  
  _timer = INITIAL_TIME;
  
  self.userInteractionEnabled = YES;
  
  return self;
}

/**
 * Initialises a default Tile board. Handles creating it at appropriate
 * size based on device.
 */
-(void) createBoard {
  
  _board = [TBoard boardWithSize:(CGSize){.width=10,.height=14}];
  
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
  
  [_header updateScore:0];
  [_header updateTimer:300];
  
  __weak GameScene* weakSelf = self;
  _header.onPause = ^() {
    [weakSelf pauseChosen];
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
  
  [self initScoreChange:tiles.count];
}

#pragma mark Touch Interaction

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  _lastTouch = [touch locationInWorld];
  NSArray *group = [_board groupTestWithTouch:_lastTouch];
  
  [self groupTouched:group];
}

#pragma mark Game State

/**
 * Handles responding to the pause button being pressed
 */
-(void) pauseChosen {
  
  NSLog(@"Pause Chosen.");
}

/**
 * Handles all standard updates of the game - mostly managing the game
 * state and handling round over scenarios.
 */
-(void) update:(CCTime)delta {
  
  _timer -= delta;
  [_header updateTimer:(int)_timer];
}

/**
 * This method handles displaying the score change label and move
 * actions towards the score, then adding the score using a callback.
 *
 * @param scoreChange The score value to add.
 */
-(void) initScoreChange:(int)scoreChange {
  
  CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d", scoreChange] fontName:UI_FONT fontSize:UI_FONT_SIZE];
  
  [scoreLabel setPosition:_lastTouch];
  
  /* Create sequence of move / fade actions */
  CCActionMoveTo *moveTo = [CCActionMoveTo actionWithDuration:1 position:_header.ScorePosition];
  
  CCActionFadeTo *fadeTo = [CCActionFadeTo actionWithDuration:1 opacity:0.5];
  
  /* Create a callback to update score and remove label when done */
  CCActionCallBlock *callback = [CCActionCallBlock actionWithBlock:^{
    [self updateScore:scoreChange];
    [self removeChild:scoreLabel];
  }];
  
  /* Spawn the fade and move actions at the same time */
  CCActionSpawn *spawnActions = [CCActionSpawn actionOne:moveTo two:fadeTo];
  
  /* Call this sequence */
  [scoreLabel runAction:[CCActionSequence actions:spawnActions, callback, nil]];
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
