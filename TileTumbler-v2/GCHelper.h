
#import "cocos2d.h"

#import <GameKit/GameKit.h>

@interface GCHelper : NSObject <GKLeaderboardViewControllerDelegate,GKAchievementViewControllerDelegate> {
  
  /* True if the local user is authenticated */
  BOOL _userAuthenticated;
}

/* Holds true if the local player has authenticated. */
@property (readonly) BOOL Authenticated;

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

#pragma mark Display Methods

/**
 * Displays the leaderboards overlay and handles removing the overlay on completion.
 */
-(void) displayLeaderboards;

/**
 * Displays the achievements overlay and handles removal on completion.
 */
-(void) displayAchievements;

@end
