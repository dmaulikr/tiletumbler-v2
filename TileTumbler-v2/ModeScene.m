
#import "ModeScene.h"
#import "GameScene.h"
#import "Utility.h"
#import "TColour.h"

@implementation ModeScene

#pragma mark Creation

+(ModeScene *) scene {
  return [[self alloc] init];
}

-(instancetype) init {
  
  self = [super init];
  if (!self) return nil;
  
  /* Initialise our mode information */
  _names = @[@"TIMED", @"TOUCHES", @"ZEN"];
  
  /* Touch and time limits, 0 represents unlimited */
  _times = @[@(60), @(0), @(0)];
  _touches = @[@(0), @(20), @(0)];
  
  [self initBackground];
  [self initLabels];
  [self initButtons];
  
  self.userInteractionEnabled = YES;
  
  return self;
}

-(void) initBackground {
  
  CCDrawNode *draw = [CCDrawNode node];
  CGSize size = [CCDirector sharedDirector].viewSize;
  
  CGPoint *vertices = malloc(sizeof(CGPoint)*4);
  
  vertices[0] = (CGPoint){.x=0, .y=0};
  vertices[1] = (CGPoint){.x=0, .y=size.height};
  vertices[2] = (CGPoint){.x=size.width, .y=size.height};
  vertices[3] = (CGPoint){.x=size.width, .y=0};
  
  [draw drawPolyWithVerts:vertices count:4 fillColor:[CCColor colorWithCcColor3b:ccBLACK] borderWidth:1 borderColor:[CCColor colorWithCcColor3b:ccWHITE]];
  
  CGPoint from = (CGPoint){.x=0.1*size.width, .y=0.66*size.height};
  CGPoint to = (CGPoint){.x=0.9*size.width, .y=0.66*size.height};
  
  [draw drawSegmentFrom:from to:to radius:1 color:[CCColor colorWithCcColor3b:ccWHITE]];
  
  from = (CGPoint){.x=0.1*size.width, .y=0.2*size.height};
  to = (CGPoint){.x=0.9*size.width, .y=0.2*size.height};
  
  [draw drawSegmentFrom:from to:to radius:1 color:[CCColor colorWithCcColor3b:ccWHITE]];
  
  [self addChild:draw z:0];
}

-(void) initLabels {
  
  /**** Title Label ****/
  CCLabelTTF *title = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"GAME MODE" withSize:30]];
  
  [title setPositionType:CCPositionTypeNormalized];
  [title setPosition:(CGPoint){.x=0.5, .y=0.88}];
  [title setColor:[TColour colourOne].color];
  
  [self addChild:title z:2];
  
  /**** Category Labels ****/
  _modeLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:_names[0] withSize:28]];
  
  [_modeLabel setPositionType:CCPositionTypeNormalized];
  [_modeLabel setPosition:(CGPoint){.x=0.5, .y=0.75}];
  [_modeLabel setColor:[TColour colourTwo].color];
  
  [self addChild:_modeLabel z:2];
  
  CCLabelTTF *labelTime = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"TIME LIMIT" withSize:28]];
  
  [labelTime setPositionType:CCPositionTypeNormalized];
  [labelTime setPosition:(CGPoint){.x=0.5, .y=0.58}];
  [labelTime setColor:[TColour colourTwo].color];
  
  [self addChild:labelTime z:2];
  
  CCLabelTTF *labelTouch = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"TOUCHES" withSize:28]];
  
  [labelTouch setPositionType:CCPositionTypeNormalized];
  [labelTouch setPosition:(CGPoint){.x=0.5, .y=0.37}];
  [labelTouch setColor:[TColour colourTwo].color];
  
  [self addChild:labelTouch z:2];
  
  /**** Descriptor Labels ****/
  _timeLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"60 seconds" withSize:23]];
  
  [_timeLabel setPositionType:CCPositionTypeNormalized];
  [_timeLabel setPosition:(CGPoint){.x=0.5, .y=0.49}];
  [_timeLabel setColor:[TColour colourThree].color];
  
  [self addChild:_timeLabel z:2];
  
  _touchLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"unlimited" withSize:23]];
  
  [_touchLabel setPositionType:CCPositionTypeNormalized];
  [_touchLabel setPosition:(CGPoint){.x=0.5, .y=0.28}];
  [_touchLabel setColor:[TColour colourThree].color];
  
  [self addChild:_touchLabel z:2];
}

-(void) initButtons {
  
  /* Arrow buttons + CONTINUE Label */
  _continueButton = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"CONTINUE" withSize:30]];
  
  [_continueButton setPositionType:CCPositionTypeNormalized];
  [_continueButton setPosition:(CGPoint){.x=0.5, .y=0.10}];
  [_continueButton setColor:[TColour colourOne].color];
  
  [self addChild:_continueButton z:2];
  
  CCSpriteFrame *left = [CCSpriteFrame frameWithImageNamed:@"ArrowLeft.png"];
  CCSpriteFrame *right = [CCSpriteFrame frameWithImageNamed:@"ArrowRight.png"];
  
  _leftButton = [CCButton buttonWithTitle:@"" spriteFrame:left];
  _rightButton = [CCButton buttonWithTitle:@"" spriteFrame:right];
  
  [_leftButton setPositionType:CCPositionTypeNormalized];
  [_rightButton setPositionType:CCPositionTypeNormalized];
  
  [_leftButton setPosition:(CGPoint){.x=0.2, .y=0.75}];
  [_rightButton setPosition:(CGPoint){.x=0.8, .y=0.75}];
  
  [_leftButton setTarget:self selector:@selector(buttonChosen:)];
  [_rightButton setTarget:self selector:@selector(buttonChosen:)];
  
  // Expand hit area for our small arrows
  _leftButton.hitAreaExpansion = 20;
  _rightButton.hitAreaExpansion = 20;
  
  [self addChild:_leftButton];
  [self addChild:_rightButton];
}

#pragma mark Responding

-(void) buttonChosen:(id)sender {
  
  if (sender == _leftButton) {
    _currentMode = (_currentMode+2) % 3;
  } else if (sender == _rightButton) {
    _currentMode = (_currentMode+1) % 3;
  }
  
  /* Update mode label */
  [_modeLabel setAttributedString:[Utility uiString:_names[_currentMode] withSize:28]];
  
  /* Update time and touch labels */
  int seconds = [_times[_currentMode] intValue];
  int touches = [_touches[_currentMode] intValue];
  
  NSString *secString = seconds == 0 ? @"unlimited" : [NSString stringWithFormat:@"%d seconds", seconds];
  NSString *touchString = touches == 0 ? @"unlimited" : [NSString stringWithFormat:@"%d touches", touches];
  
  [_timeLabel setAttributedString:[Utility uiString:secString withSize:23]];
  [_touchLabel setAttributedString:[Utility uiString:touchString withSize:23]];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  if ([_continueButton hitTestWithWorldPos:[touch locationInWorld]]) {
    
    /* Transition to game scene with attributes selected */
    CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
    
    GameModeType _mode = (GameModeType){.mode=(GameMode)_currentMode,
                                        .touches=[_touches[_currentMode] intValue],
                                        .seconds=[_times[_currentMode] intValue]};
    
    [[CCDirector sharedDirector] replaceScene:[GameScene sceneWithType:_mode] withTransition:trans];
  }
}

@end
