
#import "Utility.h"

@implementation Utility

+(NSAttributedString*) uiString:(NSString*)string withSize:(int)size {
  
  /* If we haven't loaded this custom font yet */
  if (![UIFont fontWithName:@"CaviarDreams.ttf" size:12]) {
    
    // Make CCLabelTTF class do the work for us!
    [CCLabelTTF labelWithString:@"" fontName:@"CaviarDreams.ttf" fontSize:12];
  }
  
  NSMutableAttributedString *attributedString;
  attributedString = [[NSMutableAttributedString alloc] initWithString:string];
  
  /* Kerning */
  [attributedString addAttribute:NSKernAttributeName value:@2 range:NSMakeRange(0, string.length)];
  
  /* Font attribute */
  [attributedString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"CaviarDreams" size:size]
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

@end
