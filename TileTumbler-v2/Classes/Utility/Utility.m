
#import "Utility.h"

@implementation Utility

+(NSAttributedString*) uiString:(NSString*)string withSize:(int)size {
  
  /* If we haven't loaded this custom font yet */
  if (![UIFont fontWithName:@"Caviar Dreams" size:12]) {
    
    // Make CCLabelTTF class do the work for us!
    [CCLabelTTF labelWithString:@"" fontName:@"CaviarDreams.ttf" fontSize:12];
  }
  
  NSMutableAttributedString *attributedString;
  attributedString = [[NSMutableAttributedString alloc] initWithString:string];
  
  /* Kerning */
  [attributedString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, string.length)];
  
  /* Font attribute */
  [attributedString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"Caviar Dreams" size:[Utility scaledFont:size]]
                           range:NSMakeRange(0, string.length)];
  
  return attributedString;
}

+(NSString*) formatTime:(int)timeRemaining {
  
  uint minutes = floor((float)timeRemaining / 60);
  uint seconds = timeRemaining - (minutes * 60);
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  
  [numberFormatter setPositiveFormat:@"00"];
  
  NSString *secondString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]];
  
  NSString *timeString = [NSString stringWithFormat:@"%d:%@", minutes, secondString];
  
  if (minutes == 0) {
    
    [numberFormatter setPositiveFormat:@"##s"];
    
    secondString = [numberFormatter stringFromNumber:[NSNumber numberWithInt:seconds]];
    timeString = secondString;
  }
  
  return timeString;
}

+(NSString*) formatScore:(int)value {
  
  NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
  [numberFormatter setPositiveFormat:@"#,###,###"];
  
  return [numberFormatter stringFromNumber:[NSNumber numberWithInt:value]];
}

/**
 * Sprite scale calculates a scale value based on the calculated
 * board width. The scale is 1.X where X is the number of extra
 * tiles in the board-width.
 *
 * @return Returns the value of the sprite scale.
 */
+(float) spriteScale {
  
  CGSize _board = [Utility computeBoardSize];
  
  float scale = 1 + ((_board.width - 10) / 10.0);
  
  return scale;
}

/* Simply scales the font size by the sprite scale value */
+(float) scaledFont:(float)size {
  
  return [self spriteScale] * size;
}

/**
 * Board size is calculated using a base value of 10 tiles wide, then
 * identifying the extra space we have and deciding how many tiles
 * to place.
 *
 * Height is determined as the same width/height ratio as the device
 * itself.
 */
+(CGSize) computeBoardSize {
  
  CGSize viewSize = [CCDirector sharedDirector].viewSizeInPixels;
  
  /* The ratio of height to width */
  float ratio = viewSize.height / viewSize.width;
  
  float tilesWide = 10 + ((int)viewSize.width % 320) / 32.0;
  float tilesHigh = tilesWide * ratio;
  
  return (CGSize){.width=(int)tilesWide, .height=(int)ceil(tilesHigh)};
}

+(CCSprite*) createSeparatorFrom:(CGPoint)from To:(CGPoint)to {
  
  CCSprite *separator = [CCSprite spriteWithImageNamed:@"Separator.png"];
  
  [separator setPosition:(CGPoint){.x=from.x, .y=from.y}];
  
  [separator setAnchorPoint:(CGPoint){.x=0, .y=0.5}];
  
  [separator setScaleX:(to.x - from.x) / separator.contentSize.width];
  
  return separator;
}

@end
