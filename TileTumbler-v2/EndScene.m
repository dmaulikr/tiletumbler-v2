
#import "EndScene.h"
#import "TColour.h"
#import "Utility.h"

#import "GameScene.h"
#import "IntroScene.h"

@implementation EndScene

+(EndScene*) sceneWithScore:(int)score {
  return [[self alloc] initWithScore:score];
}

-(instancetype) initWithScore:(int)score {
  
  self = [super init];
  if (!self) return nil;
  
  self.contentSize = [CCDirector sharedDirector].viewSize;
  _score = score;
  
  [self createBackground];
  [self createTitle];
  [self createScoreLabel];
  [self createButtons];
  
  self.userInteractionEnabled = YES;
  
  return self;
}

-(void) createBackground {
  
  CGSize size = self.contentSize;
  CCDrawNode *background = [CCDrawNode node];
  
  CGPoint *vertices = malloc(sizeof(CGPoint)*4);
  
  vertices[0] = (CGPoint){.x=0,.y=0};
  vertices[1] = (CGPoint){.x=0,.y=size.height};
  vertices[2] = (CGPoint){.x=size.width,.y=size.height};
  vertices[3] = (CGPoint){.x=size.width,.y=0};
  
  [background drawPolyWithVerts:vertices count:4 fillColor:[CCColor colorWithCcColor3b:ccBLACK] borderWidth:1 borderColor:[CCColor colorWithCcColor3b:ccWHITE]];
  
  [self addChild:background z:0];
}

-(void) createTitle {
  
  CCLabelTTF *title = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"ROUND OVER" withSize:28]];
  
  [title setColor:[TColour colourOne].color];
  
  [title setPositionType:CCPositionTypeNormalized];
  [title setPosition:(CGPoint){.x=0.5, .y=0.75}];
  
  [self addChild:title z:2];
}

-(void) createScoreLabel {
  
  NSString *scoreString = [Utility formatScore:_score];
  scoreString = [NSString stringWithFormat:@"SCORE: %@", scoreString];
  
  CCLabelTTF *score = [CCLabelTTF labelWithAttributedString:[Utility uiString:scoreString withSize:26]];
  
  [score setColor:[TColour colourThree].color];
  
  [score setPositionType:CCPositionTypeNormalized];
  [score setPosition:(CGPoint){.x=0.5, .y=0.5}];
  
  [self addChild:score z:2];
}

-(void) createButtons {
  
  playLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"PLAY AGAIN" withSize:22]];
  menuLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"MAIN MENU" withSize:22]];
  
  [playLabel setColor:[TColour colourTwo].color];
  [menuLabel setColor:[TColour colourFour].color];
  
  [playLabel setPositionType:CCPositionTypeNormalized];
  [menuLabel setPositionType:CCPositionTypeNormalized];
  
  [playLabel setPosition:(CGPoint){.x=0.5,.y=0.30}];
  [menuLabel setPosition:(CGPoint){.x=0.5,.y=0.20}];
  
  [self addChild:playLabel z:2];
  [self addChild:menuLabel z:2];
}

#pragma mark Touch Interaction

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  /* Custom test for label interaction, to be able to use NSAttributedString */
  if ([playLabel hitTestWithWorldPos:[touch locationInWorld]]) {
    
    /* Transition to GameScene */
    CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
    
    [[CCDirector sharedDirector] replaceScene:[GameScene scene] withTransition:trans];
  } else if ([menuLabel hitTestWithWorldPos:[touch locationInWorld]]) {
    
    /* Transition to Main Menu */
    CCTransition *trans = [CCTransition transitionCrossFadeWithDuration:0.8];
    
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene] withTransition:trans];
  }
}

@end
