
#import "GameHeader.h"
#import "Utility.h"

@implementation GameHeader

#pragma mark Accessors

/**
 * @return Returns the centre position of the score label
 */
-(CGPoint) scorePosition {
  
  return [_score convertToWorldSpace:[_score positionInPoints]];
}

#pragma mark Creation

+(GameHeader *) headerWithSize:(CGSize)sizePoints {
  return [[self alloc] initWithSize:sizePoints];
}

-(instancetype) initWithSize:(CGSize)sizePoints {
  
  self = [super init];
  if (!self) return nil;
  
  // Assign our size
  [self setContentSize:sizePoints];
  
  // Create our background
  [self createBackground];
  
  // Create our score label
  [self createScoreLabel];
  
  // Create our timer label
  [self createTimerLabel];
  
  // Create our pause button
  [self createPauseButton];
  
  return self;
}

/**
 * Initialises and assigns the tools to draw our background. Currently uses
 * a CCDrawNode object to draw the background.
 */
-(void) createBackground {
  
  CGSize sizePoints = self.contentSizeInPoints;
  
  _background = [CCDrawNode node];
  
  /* Draw fill */
  CGPoint *verts = malloc(sizeof(CGPoint)*4);
  
  verts[0] = (CGPoint){.x=0,.y=1};
  verts[1] = (CGPoint){.x=0,.y=sizePoints.height};
  verts[2] = (CGPoint){.x=sizePoints.width,.y=sizePoints.height};
  verts[3] = (CGPoint){.x=sizePoints.width,.y=1};
  
  [_background drawPolyWithVerts:verts count:4 fillColor:[CCColor colorWithCcColor3b:ccBLACK] borderWidth:0 borderColor:[CCColor clearColor]];
  
  /* Draw lower stroke */
  [_background drawSegmentFrom:ccp(0,0) to:ccp(sizePoints.width,1) radius:1 color:[CCColor colorWithWhite:1 alpha:1]];
  
  [self addChild:_background z:0];
  
  free(verts);
}

/**
 * Creates and positions the score label at the left side of the header-bar.
 */
-(void) createScoreLabel {
  
  CGPoint anchor = (CGPoint){.x=0,.y=0.5};
  CGPoint pos = (CGPoint){.x=0.05,.y=0.5};
  
  _score = [CCLabelTTF labelWithString:@"" fontName:UI_FONT fontSize:UI_FONT_SIZE];
  
  [self addChild:_score];
  
  /* Assign position and anchor point */
  [_score setPositionType:CCPositionTypeNormalized];
  [_score setPosition:pos];
  
  [_score setAnchorPoint:anchor];
}

/**
 * Creates and positions the timer label at the right-side of the header-bar.
 */
-(void) createTimerLabel {
  
  CGPoint anchor = (CGPoint){.x=1,.y=0.5};
  CGPoint pos = (CGPoint){.x=0.95,.y=0.5};
  
  _timer = [CCLabelTTF labelWithString:@"" fontName:UI_FONT fontSize:UI_FONT_SIZE];
  
  [self addChild:_timer];
  
  /* Assign position and anchor point */
  [_timer setPositionType:CCPositionTypeNormalized];
  [_timer setPosition:pos];
  
  [_timer setAnchorPoint:anchor];
}

/**
 * Creates a pause button and assigns it's action to the call-block property,
 * and positions it at the centre of the header bar.
 */
-(void) createPauseButton {
  
  CGPoint pos = (CGPoint){.x=0.5,.y=0.5};
  
  _pause = [CCButton buttonWithTitle:@"PAUSE" fontName:UI_FONT fontSize:UI_FONT_SIZE];
  
  [self addChild:_pause];
  
  /* Assign position and callback */
  [_pause setPositionType:CCPositionTypeNormalized];
  [_pause setPosition:pos];
  
  __weak GameHeader* weakSelf = self;
  [_pause setBlock:^(id sender) {
    weakSelf.onPause();
  }];
}

#pragma mark Label Changes

-(void) updateScore:(int)value {
  
  [_score setAttributedString:[Utility uiString:[Utility formatScore:value] withSize:UI_FONT_SIZE]];
}

-(void) updateTimer:(int)value {

  [_timer setAttributedString:[Utility uiString:[Utility formatTime:value] withSize:UI_FONT_SIZE]];
}

#pragma mark String Functions

@end
