
#import "GCHelper.h"

#import <GameKit/GameKit.h>

@implementation GCHelper

#pragma mark Creation

static GCHelper *_sharedGCHelper=nil;
static GKLeaderboardViewController *_leaderboardView=nil;
static GKAchievementViewController *_achievementView=nil;

+(GCHelper*) sharedInstance
{
	if (!_sharedGCHelper)
		_sharedGCHelper = [[GCHelper alloc] init];
  
	return _sharedGCHelper;
}

-(id) init {
  
  self = [super init];
  if (!self) return nil;
  
  _Available = [self isGameCenterAvailable];
  
  if (_Available) {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(authenticationChanged)
               name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
  }
  
  return self;
}

#pragma mark Authentication

-(BOOL) Authenticated {
  return _userAuthenticated;
}

-(void) authenticate {
  
  /* Don't attempt authentication if Game Center not available */
  if (!self.Available) return;
  
  __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
    
    if (viewController != nil)
    {
      [[[CCDirector sharedDirector] view] addSubview:viewController.view];
    }
    else if (localPlayer.isAuthenticated)
    {
      NSLog(@"[GC]: Local Player Authenticated Already.");
    }
  };
}

-(void) authenticationChanged {
  
  _userAuthenticated = [GKLocalPlayer localPlayer].isAuthenticated;
}

#pragma mark Display Methods

-(void) displayAchievements {
  
  _achievementView = [GKAchievementViewController new];
  [_achievementView setViewState:GKGameCenterViewControllerStateAchievements];
  [_achievementView setAchievementDelegate:self];
  
  [[CCDirector sharedDirector] presentViewController:_achievementView animated:YES completion:^{
    NSLog(@"Achievements displayed.");
  }];
}

-(void) displayLeaderboards {
  
  _leaderboardView = [GKLeaderboardViewController new];
  [_leaderboardView setViewState:GKGameCenterViewControllerStateLeaderboards];
  [_leaderboardView setLeaderboardDelegate:self];
  
  [[CCDirector sharedDirector] presentViewController:_leaderboardView animated:YES completion:^{
    NSLog(@"Leaderboard displayed.");
  }];
}

#pragma mark GK Controller Protocol

/**
 * Called when 'Done' touched on the achievement page, dismisses achievement view controller.
 */
-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
  [_achievementView dismissViewControllerAnimated:YES completion:^{
    NSLog(@"Achievements dismissed.");
  }];
}

/**
 * Called when 'Done' touched on the leaderboard page, dismisses leaderboard view controller.
 */
-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
  [_leaderboardView dismissViewControllerAnimated:YES completion:^{
    NSLog(@"Leaderboard dismissed.");
  }];
}

#pragma mark Helper

/**
 * Apple's recommended method of checking for Game Center availability.
 *
 * @return Returns true if the game center library is available.
 */
-(BOOL) isGameCenterAvailable {
  
  // check for presence of GKLocalPlayer API
  Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
  
  // check if the device is running iOS 4.1 or later
  NSString *reqSysVer = @"4.1";
  NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
  BOOL osVersionSupported = ([currSysVer compare:reqSysVer
                                         options:NSNumericSearch] != NSOrderedAscending);
  
  return (gcClass && osVersionSupported);
}

@end
