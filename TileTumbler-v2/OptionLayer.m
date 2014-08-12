
#import "OptionLayer.h"

#import "TColour.h"
#import "Utility.h"

@implementation OptionLayer

#pragma mark Creation 

+(OptionLayer*) layer {
  return [[self alloc] init];
}

-(instancetype) init {
  
  self = [super init];
  if (!self) return nil;
  
  /* Set fullscreen */
  self.contentSize = [CCDirector sharedDirector].viewSize;
  
  [self createBackground];
  [self createTitle];
  [self createLabels];
  [self createToggles];
  [self createSliders];
  
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
  
  [background drawPolyWithVerts:vertices count:4 fillColor:[CCColor colorWithCcColor3b:ccBLACK] borderWidth:0 borderColor:[CCColor clearColor]];
  
  /* draw separator line */
  CGPoint pointFrom =  (CGPoint){.x=0.1 * size.width, .y=0.6 * size.height};
  CGPoint pointTo = (CGPoint){.x=0.9 * size.width, .y=0.6 * size.height};
  
  [background drawSegmentFrom:pointFrom to:pointTo radius:1 color:[CCColor colorWithCcColor3b:ccWHITE]];
  
  [self addChild:background z:0];
}

-(void) createTitle {
  
  titleLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"VOLUME" withSize:30]];
  
  [titleLabel setPositionType:CCPositionTypeNormalized];
  [titleLabel setPosition:(CGPoint){.x=0.5,.y=0.9}];
  
  [titleLabel setColor:[TColour colourOne].color];
  
  [self addChild:titleLabel z:1];
}

-(void) createLabels {
  
  CCLabelTTF *musicLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"MUSIC" withSize:23]];
  CCLabelTTF *fxLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"EFFECTS" withSize:23]];
  
  [musicLabel setColor:[TColour colourTwo].color];
  [fxLabel setColor:[TColour colourThree].color];
  
  [musicLabel setAnchorPoint:(CGPoint){.x=0, .y=0.5}];
  [fxLabel setAnchorPoint:(CGPoint){.x=0, .y=0.5}];
  
  [musicLabel setPositionType:CCPositionTypeNormalized];
  [fxLabel setPositionType:CCPositionTypeNormalized];
  
  [musicLabel setPosition:(CGPoint){.x=0.1, .y=0.78}];
  [fxLabel setPosition:(CGPoint){.x=0.1, .y=0.68}];
 
  [self addChild:musicLabel z:2];
  [self addChild:fxLabel z:2];
  
  /* Copy the labels and set them up for lower down ones too */
  musicLabel = [CCLabelTTF labelWithAttributedString:musicLabel.attributedString];
  fxLabel = [CCLabelTTF labelWithAttributedString:fxLabel.attributedString];
  
  [musicLabel setColor:[TColour colourTwo].color];
  [fxLabel setColor:[TColour colourThree].color];
  
  [musicLabel setAnchorPoint:(CGPoint){.x=0.5, .y=0.5}];
  [fxLabel setAnchorPoint:(CGPoint){.x=0.5, .y=0.5}];
  
  [musicLabel setPositionType:CCPositionTypeNormalized];
  [fxLabel setPositionType:CCPositionTypeNormalized];
  
  [musicLabel setPosition:(CGPoint){.x=0.5, .y=0.5}];
  [fxLabel setPosition:(CGPoint){.x=0.5, .y=0.3}];
  
  [self addChild:musicLabel z:2];
  [self addChild:fxLabel z:2];
  
  /* Return label */
  returnLabel = [CCLabelTTF labelWithAttributedString:[Utility uiString:@"RETURN" withSize:28]];
  
  [returnLabel setPositionType:CCPositionTypeNormalized];
  [returnLabel setPosition:(CGPoint){.x=0.5,.y=0.08}];
  
  [returnLabel setColor:[TColour colourOne].color];
  
  [self addChild:returnLabel z:1];
  
}

-(void) createToggles {
  
  /* Set toggle states */
  _musicOn = YES;
  _fxOn = YES;
  
  /* Load toggle sprite frames */
  CCSpriteFrame *toggleOn = [CCSpriteFrame frameWithImageNamed:@"ToggleOn.png"];
  CCSpriteFrame *toggleOff = [CCSpriteFrame frameWithImageNamed:@"ToggleOn.png"];
  
  _musicOn = ![OALSimpleAudio sharedInstance].bgMuted;
  _fxOn = ![OALSimpleAudio sharedInstance].effectsMuted;
  
  /* Create toggle sprites */
  musicToggle = [CCButton buttonWithTitle:@"" spriteFrame:_musicOn ? toggleOn : toggleOff];
  fxToggle = [CCButton buttonWithTitle:@"" spriteFrame:_fxOn ? toggleOn : toggleOff];
  
  [musicToggle setAnchorPoint:(CGPoint){.x=1,.y=0.5}];
  [fxToggle setAnchorPoint:(CGPoint){.x=1,.y=0.5}];
  
  [musicToggle setPositionType:CCPositionTypeNormalized];
  [fxToggle setPositionType:CCPositionTypeNormalized];
  
  [musicToggle setPosition:(CGPoint){.x=0.9,.y=0.78}];
  [fxToggle setPosition:(CGPoint){.x=0.9,.y=0.68}];
  
  __weak OptionLayer* weakSelf = self;
  [musicToggle setBlock:^(id sender) {
    
    [weakSelf toggleBackgroundAudio];
  }];
  
  [fxToggle setBlock:^(id sender) {
    
    [weakSelf toggleFxAudio];
  }];
  
  [self addChild:musicToggle z:2];
  [self addChild:fxToggle z:2];
}

-(void) createSliders {
  
  CCSpriteFrame *sliderBackground = [CCSpriteFrame frameWithImageNamed:@"SliderBg.png"];
  CCSpriteFrame *sliderTack = [CCSpriteFrame frameWithImageNamed:@"SliderTack.png"];
  
  /* Create the music slider first */
  musicSlider = [[CCSlider alloc] initWithBackground:sliderBackground andHandleImage:sliderTack];
  
  [self addChild:musicSlider z:2];
  
  [musicSlider setAnchorPoint:(CGPoint){.x=0.5, .y=0.5}];
  
  [musicSlider setPositionType:CCPositionTypeNormalized];
  [musicSlider setPosition:(CGPoint){.x=0.5, .y=0.42}];
  
  [musicSlider setSliderValue:[OALSimpleAudio sharedInstance].bgVolume];
  
  [musicSlider setBlock:^(id sender) {
    
    CCSlider *slider = (CCSlider*) sender;
    
    [OALSimpleAudio sharedInstance].bgVolume = slider.sliderValue;
  }];
  
  /* Volume icons */
  CCSpriteFrame *volMin = [CCSpriteFrame frameWithImageNamed:@"VolMin.png"];
  CCSpriteFrame *volMax = [CCSpriteFrame frameWithImageNamed:@"VolMax.png"];
  
  CCSprite *volMinS = [CCSprite spriteWithSpriteFrame:volMin];
  CCSprite *volMaxS = [CCSprite spriteWithSpriteFrame:volMax];
  
  [volMinS setPositionType:CCPositionTypeNormalized];
  [volMaxS setPositionType:CCPositionTypeNormalized];
  
  [volMinS setPosition:(CGPoint){.x=0.1, .y=0.42}];
  [volMaxS setPosition:(CGPoint){.x=0.9, .y=0.42}];
  
  [self addChild:volMinS z:2];
  [self addChild:volMaxS z:2];
  
  /* Fx Slider */
  fxSlider = [[CCSlider alloc] initWithBackground:sliderBackground andHandleImage:sliderTack];
  
  [self addChild:fxSlider z:2];
  
  [fxSlider setAnchorPoint:(CGPoint){.x=0.5, .y=0.5}];
  
  [fxSlider setPositionType:CCPositionTypeNormalized];
  [fxSlider setPosition:(CGPoint){.x=0.5, .y=0.22}];
  
  [fxSlider setSliderValue:[OALSimpleAudio sharedInstance].effectsVolume];
  
  [fxSlider setBlock:^(id sender) {
    
    CCSlider *slider = (CCSlider*) sender;
    
    [OALSimpleAudio sharedInstance].effectsVolume = slider.sliderValue;
  }];
  
  /* Volume icons */
  volMinS = [CCSprite spriteWithSpriteFrame:volMin];
  volMaxS = [CCSprite spriteWithSpriteFrame:volMax];
  
  [volMinS setPositionType:CCPositionTypeNormalized];
  [volMaxS setPositionType:CCPositionTypeNormalized];
  
  [volMinS setPosition:(CGPoint){.x=0.1, .y=0.22}];
  [volMaxS setPosition:(CGPoint){.x=0.9, .y=0.22}];
  
  [self addChild:volMinS z:2];
  [self addChild:volMaxS z:2];
}

#pragma mark Touch Interaction

/**
 * Custom touch interaction to detect clicking on RETURN label, this is
 * so we can use Kerning on the label text.
 */
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  
  /* Return selected - call block! */
  if ([returnLabel hitTestWithWorldPos:[touch locationInWorld]]) {
    self.onReturn();
  }
}

#pragma mark Sound Changes

-(void) toggleBackgroundAudio {
  
  [OALSimpleAudio sharedInstance].bgMuted = !_musicOn;
  _musicOn = !_musicOn;
  
  NSString *newFrame = _musicOn ? @"ToggleOn.png" : @"ToggleOff.png";
  
  [musicToggle setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:newFrame] forState:CCControlStateNormal];
}

-(void) toggleFxAudio {
  
  [OALSimpleAudio sharedInstance].effectsMuted = !_fxOn;
  _fxOn = !_fxOn;
  
  NSString *newFrame = _fxOn ? @"ToggleOn.png" : @"ToggleOff.png";
  
  [fxToggle setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:newFrame] forState:CCControlStateNormal];
}

@end
