
#import "TColour.h"

@implementation TColour

#pragma mark Creation

/* Our static references to colours */
static TColour *_colourOne=nil;
static TColour *_colourTwo=nil;
static TColour *_colourThree=nil;
static TColour *_colourFour=nil;

+(TColour *) colourOne
{
	if (!_colourOne) {
    // XXX: Change this to initialise w/ colours read from elsewhere
		_colourOne = [[TColour alloc] initWithColour:[CCColor colorWithCcColor3b:ccc3(222, 199, 99)]];
  }
  
	return _colourOne;
}

+(TColour *) colourTwo
{
	if (!_colourTwo) {
    // XXX: Change this to initialise w/ colours read from elsewhere
		_colourTwo = [[TColour alloc] initWithColour:[CCColor colorWithCcColor3b:ccc3(82, 178, 165)]];
  }
  
	return _colourTwo;
}

+(TColour *) colourThree
{
	if (!_colourThree) {
    // XXX: Change this to initialise w/ colours read from elsewhere
		_colourThree = [[TColour alloc] initWithColour:[CCColor colorWithCcColor3b:ccc3(206, 48, 123)]];
  }
  
	return _colourThree;
}

+(TColour *) colourFour
{
	if (!_colourFour) {
    // XXX: Change this to initialise w/ colours read from elsewhere
		_colourFour = [[TColour alloc] initWithColour:[CCColor colorWithCcColor3b:ccc3(115, 93, 189)]];
  }
  
	return _colourFour;
}

-(instancetype) initWithColour:(CCColor *)colour {
  
  self = [super init];
  if (!self) return nil;
  
  self.color = colour;
  
  return self;
}

+(TColour *) colourForNum:(int)num {
  
  switch (num) {
    case 1:
      return [self colourOne];
      break;
      
    case 2:
      return [self colourTwo];
      break;
      
    case 3:
      return [self colourThree];
      break;
      
    case 4:
      return [self colourFour];
      break;
      
    default:
      NSLog(@"[Warning]: Unknown value sent to TColour:colourForNum");
      return [self colourOne];
      break;
      
  }
}

+(id)alloc
{
	NSAssert(_colourOne == nil || _colourTwo == nil || _colourThree == nil || _colourFour == nil, @"Attempted to allocate too many instances of TColour.");
	return [super alloc];
}

@end
