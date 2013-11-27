//
//  Title.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/2/13.
//
//

#import "Title.h"
#import "HelloWorldLayer.h"
#import "LevelSelect.h"
#import "SimpleAudioEngine.h"
#import "High.h"
#import "Settings.h"
#import "StatLayer.h"

@implementation Title

-(id) init
{
    if ((self = [super init]))
    {
            // NSLogging Switch
            theLogs = TRUE;
        
            // Some variables to make positioning more easy
            size = [[CCDirector sharedDirector] winSize];
            screenCenter = ccp(size.width/2, size.height/2);

            // Background Sprite
            CCSprite *background = [CCSprite spriteWithFile:@"mainmenubg.png"];
            background.position = screenCenter;
            [self addChild:background z:-10000];
        
            // Play Button
            CCMenuItemImage *start = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start.png" target:self selector:@selector(unPause)];
            start.scale = 1.3;
            menu = [CCMenu menuWithItems:start, nil];
            menu.position = ccp(screenCenter.x,screenCenter.y);
            [self addChild:menu];
        
            // Sound Button
            CCMenuItemImage *sound = [CCMenuItemImage itemWithNormalImage:@"music.png" selectedImage:@"music.png" target:self selector:@selector(high)];
            sound.scale = 1.1;
            menu2 = [CCMenu menuWithItems:sound, nil];
            menu2.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
            [self addChild:menu2];
        
            // Settings Button
            CCMenuItemImage *settings = [CCMenuItemImage itemWithNormalImage:@"settings.png" selectedImage:@"settings.png" target:self selector:@selector(settings)];
            settings.scale = 1.1;
            menu3 = [CCMenu menuWithItems:settings, nil];
            menu3.position = ccp(screenCenter.x + 33,screenCenter.y / 5);
            [self addChild:menu3];
        
            // Have Everything Stop
            [self unscheduleAllSelectors];
            CCNode* node;
            CCARRAY_FOREACH([self children], node)
            {
                [node pauseSchedulerAndActions];
            }
            // Sounds
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"zoom.mp3"];
    }
    return self;
}

-(void) settings
{
    if (theLogs == TRUE) {
        NSLog(@"MGWU Button Clicked");
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:[Settings node]]];
}

-(void) high
{
    if (theLogs == TRUE) {
        NSLog(@"Leaderboards Button Clicked");
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"high"] == false) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"high"]; }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:[StatLayer node]]];
}

-(void) unPause
{
    if (theLogs == TRUE) {
        NSLog(@"Play Button Clicked");
    }
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:0.5f scene:[LevelSelect node]]];
}
-(void) dotsEffect:(CCSprite *) spriteToBeTheNextBigThing {
    if (theLogs == TRUE) {
        NSLog(@"Title Logo Dropped Down Correctly");
    }
    id dropdown = [CCMoveTo actionWithDuration:0.7f position:ccp(screenCenter.x, screenCenter.y * 1.4)];
    id jump = [CCJumpBy actionWithDuration:0.35f position:CGPointZero height:40 jumps:1];
    id repeatJump = [CCRepeat actionWithAction:jump times:1];
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:dropdown, repeatJump, nil]];
}
-(void) slideEffectRight:(CCMenu *) spriteToBeTheNextBigThing {
    if (theLogs == TRUE) {
        NSLog(@"The Start Button Slid from the Right");
    }
    id slide = [CCMoveTo actionWithDuration:0.7f position:ccp(screenCenter.x, screenCenter.y / 1.5)];
    if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
        slide = [CCMoveTo actionWithDuration:0.7f position:ccp(screenCenter.x - 30, screenCenter.y / 1.7)];
    }
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:slide, nil]];
    
}
-(void) slideEffectLeft:(CCMenu *) spriteToBeTheNextBigThing {
    if (theLogs == TRUE) {
        NSLog(@"The Leaderboard Button Slid from the Left");
    }
    id slide = [CCMoveTo actionWithDuration:0.7f position:ccp(screenCenter.x, screenCenter.y / 3.1)];
    if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
        slide = [CCMoveTo actionWithDuration:0.7f position:ccp(screenCenter.x - 30, screenCenter.y / 3.0)];
    }
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:slide, nil]];
    
}
@end