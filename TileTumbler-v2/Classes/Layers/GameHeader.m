
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
  
  // Calculate scaled font size
  _fontSize = [Utility scaledFont:UI_FONT_SIZE];
  
  // Assign our size
  [self setContentSize:sizePoints];
  
  // Create our background
  [self createBackground];
  
  // Create our score label
  [self createScoreLabel];
  
  // Create our timer label
  [self createInfoLabel];
  
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
  
  _score = [CCLabelTTF labelWithString:@"" fontName:UI_FONT fontSize:_fontSize];
  
  [self addChild:_score];
  
  /* Assign position and anchor point */
  [_score setPositionType:CCPositionTypeNormalized];
  [_score setPosition:pos];
  
  [_score setAnchorPoint:anchor];
}

/**
 * Creates and positions the label at the right-side of the header-bar that contains our
 * information - i.e touch limit or time
 */
-(void) createInfoLabel {
  
  CGPoint anchor = (CGPoint){.x=1,.y=0.5};
  CGPoint pos = (CGPoint){.x=0.95,.y=0.5};
  
  _info = [CCLabelTTF labelWithString:@"" fontName:UI_FONT fontSize:_fontSize];
  
  [self addChild:_info];
  
  /* Assign position and anchor point */
  [_info setPositionType:CCPositionTypeNormalized];
  [_info setPosition:pos];
  
  [_info setAnchorPoint:anchor];
}

/**
 * Creates a pause button and assigns it's action to the call-block property,
 * and positions it at the centre of the header bar.
 */
-(void) createPauseButton {
  
  CGPoint pos = (CGPoint){.x=0.5,.y=0.5};
  
  _pause = [CCButton buttonWithTitle:@"PAUSE" fontName:UI_FONT fontSize:_fontSize+2];
  
  [self addChild:_pause];
  
  /* Assign position and callback */
  [_pause setPositionType:CCPositionTypeNormalized];
  [_pause setPosition:pos];
  
  __weak GameHeader* weakSelf = self;
  [_pause setBlock:^(id sender) {
    weakSelf.onPause();
  }];
}

-(void) createFinishButton {
 
  CGPoint anchor = (CGPoint){.x=1, .y=0.5};
  CGPoint pos = (CGPoint){.x=0.95,.y=0.5};
  
  _pause = [CCButton buttonWithTitle:@"END" fontName:UI_FONT fontSize:_fontSize+2];
  
  [self addChild:_pause];
  
  /* Assign position and callback */
  [_pause setAnchorPoint:anchor];
  [_pause setPositionType:CCPositionTypeNormalized];
  [_pause setPosition:pos];
  
  __weak GameHeader* weakSelf = self;
  [_pause setBlock:^(id sender) {
    weakSelf.onFinish();
  }];
}

#pragma mark Buttons

-(void) displayFinish {
  
  [self createFinishButton];
  [self hideInfo];
}

#pragma mark Label Changes

-(void) hideInfo {
  
  [_info setVisible:NO];
}

-(void) updateScore:(int)value {
  
  [_score setAttributedString:[Utility uiString:[Utility formatScore:value] withSize:_fontSize]];
}

-(void) updateInfo:(int)value withTime:(BOOL)isTime {
  
  NSString *text = isTime ? [Utility formatTime:value] : [NSString stringWithFormat:@"%d", value];
  [_info setAttributedString:[Utility uiString:text withSize:_fontSize]];
}

#pragma mark String Functions

@end
