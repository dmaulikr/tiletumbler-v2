
#import "AppDelegate.h"
#import "IntroScene.h"

#import <UIKit/UIKit.h>

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
#ifdef ANDROID
  [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenIPhone3GEmulationMode];
#endif
  
  /* Assign defaults if not exist */
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Background-Volume"] == nil) {
    [[NSUserDefaults standardUserDefaults] setFloat:0.5 forKey:@"Background-Volume"];
  }
  
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Effects-Volume"] == nil) {
    [[NSUserDefaults standardUserDefaults] setFloat:0.5 forKey:@"Effects-Volume"];
  }
  
  float bgVolume = [[NSUserDefaults standardUserDefaults] floatForKey:@"Background-Volume"];
  float fxVolume = [[NSUserDefaults standardUserDefaults] floatForKey:@"Effects-Volume"];
  
  /* Defaults to NO, which is appropriate */
  BOOL bgMuted = [[NSUserDefaults standardUserDefaults] boolForKey:@"Background-Muted"];
  BOOL fxMuted = [[NSUserDefaults standardUserDefaults] boolForKey:@"Effects-Muted"];
  
  /* Assign audio details */
  [OALSimpleAudio sharedInstance].bgMuted = bgMuted;
  [OALSimpleAudio sharedInstance].effectsMuted = fxMuted;
  
  [OALSimpleAudio sharedInstance].bgVolume = bgVolume;
  [OALSimpleAudio sharedInstance].effectsVolume = fxVolume;
  
  /* Play audio */
  [[OALSimpleAudio sharedInstance] playBg:@"bg.mp3" loop:YES];
  
  /* Setup Cocos */
	[self setupCocos2dWithOptions:@{
		CCSetupShowDebugStats: @(NO),
		CCSetupScreenOrientation: CCScreenOrientationPortrait
	}];
  
	return YES;
}

#ifdef ANDROID
- (void)buttonUpWithEvent:(UIEvent *)event
{
  switch (event.buttonCode)
  {
    case UIEventButtonCodeBack:
      exit(0);
      break;
    case UIEventButtonCodeMenu:
      exit(0);
      break;
    default:
      break;
  }
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}
#endif

-(CCScene *)startScene
{
	return [IntroScene scene];
}

@end
