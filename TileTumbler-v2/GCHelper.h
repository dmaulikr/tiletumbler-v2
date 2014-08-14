
#import "cocos2d.h"

@interface GCHelper : NSObject {
  
  /* True if the local user is authenticated */
  BOOL _userAuthenticated;
}

/* Holds the current availability of the game-center, false means
   game-center is disabled */
@property (assign, readonly) BOOL Available;

/**
 * @return Returns a singleton for accessing the Game-center content.
 */
+(GCHelper*) sharedInstance;

/**
 * Asks Game Center to authenticate the local user.
 */
-(void) authenticate;

@end
