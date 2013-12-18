//
//  Settings.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/29/13.
//
//

#import "Settings.h"
#import "Title.h"
#import "HelloWorldLayer.h"
#import "LevelSelect.h"
#import "Title.h"
#import "About.h"

@implementation Settings

-(id) init
{
    if ((self = [super init]))
    {
        // Some variables to make positioning more easy
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = ccp(size.width/2, size.height/2);
        
        CCSprite *background = [CCSprite spriteWithFile:@"level9bg.png"];
        background.position = screenCenter;
        [self addChild:background z:-1000];
        
        CCLabelTTF *settings = [CCLabelTTF labelWithString:@"SETTINGS" fontName:@"HelveticaNeue-UltraLight" fontSize:55];
        settings.position = ccp(screenCenter.x, screenCenter.y * 1.65);
        [self addChild:settings];
        
        CCMenuItemImage *reset = [CCMenuItemImage itemWithNormalImage:@"resetdata.png" selectedImage:@"resetdata-sel.png" target:self selector:@selector(resetGameData)];
        reset.scale = 1.1f;
        
        CCMenuItemImage *about = [CCMenuItemImage itemWithNormalImage:@"about.png" selectedImage:@"about-sel.png" target:self selector:@selector(about)];
        about.scale = 1.1f;

        CCMenuItemImage *rateus = [CCMenuItemImage itemWithNormalImage:@"rate.png" selectedImage:@"rate-sel.png" target:self selector:@selector(rate)];
        rateus.scale = 1.1f;

        menu = [CCMenu menuWithItems:reset, about, rateus, nil];
        [menu alignItemsVerticallyWithPadding:5];
        menu.position = ccp(screenCenter.x,screenCenter.y);
        [self addChild:menu];
        
        CCMenuItemImage *back3 = [CCMenuItemImage itemWithNormalImage:@"arrow.png" selectedImage:@"arrow-sel.png" target:self selector:@selector(goHome)];
        back3.position = ccp(screenCenter.x, screenCenter.y - 190);
        back3.scale = 1.1f;
        CCMenu *backmenu3 = [CCMenu menuWithItems:back3, nil];
        backmenu3.position = CGPointZero;
        [self addChild:backmenu3];
        
        [self unscheduleUpdate];
        [self unscheduleAllSelectors];
    }
    return self;
}

- (void)resetGameData
{
    alert = [[UIAlertView alloc] init];
    [alert setTitle:@"Are you positive?"];
    [alert setMessage:@"All progress and coins will be lost. This action cannot be reversed."];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"No"];
    [alert show];
}

-(void) selfDestruct
{
    // Reset all game data
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tutorialcompleted"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"boss"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"endless"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"coins"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"score"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"targetHit"];
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"leveldata"];
}

-(void) goHome {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFadeTR transitionWithDuration:0.5f scene:[Title node]]];
}
-(void) about {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionProgressRadialCW transitionWithDuration:0.5f scene:[About node]]];
}
-(void) rate {
    NSURL *ituneslink = [NSURL URLWithString:@"https://www.appstore.com/center"];
    [[UIApplication sharedApplication] openURL:ituneslink];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == (UIAlertView *)alert) {
        if (buttonIndex == 0)
        {
            [self performSelector:@selector(selfDestruct) withObject:nil afterDelay:0.6];
        }
        else if (buttonIndex == 1)
        {
        }
    }
    
    if (alertView == (UIAlertView *)FBalert) {
        if (buttonIndex == 0)
        {
            //            [self selfDestruct];
        }
    }
}


@end
