
#import "AppDelegate.h"
#import "IntroScene.h"

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[self setupCocos2dWithOptions:@{
		CCSetupShowDebugStats: @(NO),
		CCSetupScreenOrientation: CCScreenOrientationPortrait
	}];
	
	return YES;
}

-(CCScene *)startScene
{
	return [IntroScene scene];
}

@end
