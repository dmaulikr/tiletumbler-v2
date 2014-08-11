
#import "IntroScene.h"

@implementation IntroScene

#pragma mark - Create & Destroy

+(IntroScene *) scene
{
	return [[self alloc] init];
}

-(id) init {
  self = [super init];
  if (!self) return(nil);
    
  return self;
}

@end
