/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "AppDelegate.h"

@implementation AppDelegate

-(void) initializationComplete
{
#ifdef KK_ARC_ENABLED
	CCLOG(@"ARC is enabled");
#else
	CCLOG(@"ARC is either not available or not enabled");
#endif
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [director stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [director startAnimation];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
    [director pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
    [director resume];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Setup Mixpanel
    [self setupMixpanel];
    return YES;
}

- (void)setupMixpanel {
    // Initialize Mixpanel
    Mixpanel *mixpanel = [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    // Identify
    NSString *mixpanelUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"MixpanelUUID"];
    if (!mixpanelUUID) {
        mixpanelUUID = [[NSUUID UUID] UUIDString];
        [[NSUserDefaults standardUserDefaults] setObject:mixpanelUUID forKey:@"MixpanelUUID"];
    }
    [mixpanel identify:mixpanelUUID];
    // Register Super Properties
    NSDictionary *properties = @{@"APIVersion": @"1.2", @"date" : [NSDate date], @"language" : @"en"};
    [mixpanel registerSuperProperties:properties];
    // No survey on start
    mixpanel.showSurveyOnActive = NO;
}

-(id) alternateView
{
	return nil;
}

@end
