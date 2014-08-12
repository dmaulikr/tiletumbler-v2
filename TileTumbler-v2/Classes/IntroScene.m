
#import "IntroScene.h"
#import "GameScene.h"
#import "EndScene.h"

#import "Utility.h"

@implementation IntroScene

#pragma mark - Create & Destroy

+(IntroScene *) scene
{
	return [[self alloc] init];
}

-(id) init {
  self = [super init];
  if (!self) return(nil);
  
  [self createBackground];
  [self createTitle];
  [self createMenu];
  [self createOptions];
  
  self.userInteractionEnabled = YES;
  
  return self;
}

-(void) createBackground {
  
  CGSize size = [CCDirector sharedDirector].viewSize;
  
  _background = [CCDrawNode node];
  
  /* Draw fill */
  CGPoint *verts = malloc(sizeof(CGPoint)*4);
  
  verts[0] = ccp(0,0);
  verts[1] = ccp(0,size.height);
  verts[2] = ccp(size.width,size.height);
  verts[3] = ccp(size.width,0);
  
  [_background drawPolyWithVerts:verts count:4 fillColor:[CCColor colorWithCcColor3b:ccBLACK] borderWidth:1 borderColor:[CCColor colorWithCcColor3b:ccWHITE]];
  
  [self addChild:_background z:0];
}

-(void) createTitle {
  
  _titleText1 = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"TILE" withSize:30]];
  _titleText2 = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"TUMBLER" withSize:30]];
  
  [_titleText1 setColor:[TColour colourOne].color];
  [_titleText2 setColor:[TColour colourOne].color];
  
  [_titleText1 setPositionType:CCPositionTypeNormalized];
  [_titleText1 setPosition:(CGPoint){.x=0.5, .y=0.75}];
  
  [_titleText2 setPositionType:CCPositionTypeNormalized];
  [_titleText2 setPosition:(CGPoint){.x=0.5, .y=0.67}];
  
  [self addChild:_titleText1 z:2];
  [self addChild:_titleText2 z:2];
}

-(void) createMenu {
  
  _button1 = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"PLAY" withSize:24]];
  _button2 = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"OPTIONS" withSize:24]];
  
  [_button1 setColor:[TColour colourThree].color];
  [_button2 setColor:[TColour colourTwo].color];
  
  [_button1 setPositionType:CCPositionTypeNormalized];
  [_button2 setPositionType:CCPositionTypeNormalized];
  
  [_button1 setPosition:(CGPoint){.x=0.5,.y=0.45}];
  [_button2 setPosition:(CGPoint){.x=0.5,.y=0.30}];
  
  [self addChild:_button1 z:2];
  [self addChild:_button2 z:2];
}

-(void) createOptions {
  
  _options = [OptionLayer layer];
  
  [_options setPosition:(CGPoint){.x=0,.y=0}];
  
  __weak IntroScene* weakSelf = self;
  _options.onReturn = ^() {
    [weakSelf optionsReturn];
  };
  
  /* Add our options but make invisible for the moment */
  [_options setVisible:NO];
  [self addChild:_options z:5];
}

#pragma mark Responders

-(void) optionsReturn {
  
  /* Hide options away again */
  [_options setVisible:NO];
}

#pragma mark Touch Interaction

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  /* Custom test for label interaction, to be able to use NSAttributedString */
  if ([_button1 hitTestWithWorldPos:[touch locationInWorld]]) {
    
    /* Transition to GameScene */
    CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
    
    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:trans];
  } else if ([_button2 hitTestWithWorldPos:[touch locationInWorld]]) {
    
    [_options setVisible:YES];
  }
}

@end
