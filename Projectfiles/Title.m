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
#import "Scene.h"

@implementation Title


-(id) init
{
    if ((self = [super init]))
    {
            int numTimesPlayed = [[NSUserDefaults standardUserDefaults] objectForKey:@"numTimesPlayed"];
            numTimesPlayed++;
            [[NSUserDefaults standardUserDefaults] setInteger:numTimesPlayed forKey:@"numTimesPlayed"];
        
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
            CCMenuItemImage *start = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start-sel.png" target:self selector:@selector(unPause)];
            menu = [CCMenu menuWithItems:start, nil];
            menu.position = ccp(screenCenter.x,screenCenter.y);
            [self addChild:menu];
        
        
            // Sound Button
            if([[NSUserDefaults standardUserDefaults] integerForKey:@"numTimesPlayed"] == 0) {
                [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"musicon"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                sound = [CCMenuItemImage itemWithNormalImage:@"music.png" selectedImage:@"music-sel.png" target:self selector:@selector(turnOffSound)];
                sound.scale = 1.1;
                menu2 = [CCMenu menuWithItems:sound, nil];
                menu2.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
                [self addChild:menu2];
                NSLog(@"reset");
            } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicon"] == TRUE) {
                sound = [CCMenuItemImage itemWithNormalImage:@"music.png" selectedImage:@"music-sel.png" target:self selector:@selector(turnOffSound)];
                sound.scale = 1.1;
                menu2 = [CCMenu menuWithItems:sound, nil];
                menu2.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
                [self addChild:menu2];
            } else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"musicon"] == FALSE) {
                soundOff = [CCMenuItemImage itemWithNormalImage:@"music-not.png" selectedImage:@"music-not-sel.png" target:self selector:@selector(turnOnSound)];
                soundOff.scale = 1.1;
                menutwo = [CCMenu menuWithItems:soundOff, nil];
                menutwo.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
                [self addChild:menutwo];
            }
        
            // Settings Button
            CCMenuItemImage *settings = [CCMenuItemImage itemWithNormalImage:@"settings.png" selectedImage:@"settings-sel.png" target:self selector:@selector(settings)];
            settings.scale = 1.1;
            menu3 = [CCMenu menuWithItems:settings, nil];
            menu3.position = ccp(screenCenter.x + 33,screenCenter.y / 5);
            [self addChild:menu3];
            
            endless = [CCMenuItemImage itemWithNormalImage:@"endless-sel.png" selectedImage:@"endless-sel.png" target:self selector:@selector(endlessSelected)];
            endlessMenu = [CCMenu menuWithItems:endless, nil];
            endlessMenu.position = ccp(screenCenter.x - 95,screenCenter.y);
            [self addChild:endlessMenu];
        
            level = [CCMenuItemImage itemWithNormalImage:@"level.png" selectedImage:@"level-sel.png" target:self selector:@selector(levelSelected)];
            levelMenu = [CCMenu menuWithItems:level, nil];
            levelMenu.position = ccp(screenCenter.x + 95,screenCenter.y);
            [self addChild:levelMenu];
        
            // Sounds
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"select.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"complete.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"correct.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"correctv2.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"died.mp3"];
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"musicon"] == TRUE) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
            }
    }
    return self;
}
-(void) turnOnSound {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"musicon"];
    [[NSUserDefaults standardUserDefaults] synchronize];// Add this
    [self removeChild:soundOff cleanup:YES];
    [self removeChild:menutwo cleanup:YES];
    sound = [CCMenuItemImage itemWithNormalImage:@"music.png" selectedImage:@"music-sel.png" target:self selector:@selector(turnOffSound)];
    sound.scale = 1.1;
    menu2 = [CCMenu menuWithItems:sound, nil];
    menu2.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
    [self addChild:menu2];
}
-(void) turnOffSound {
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"musicon"];
    [[NSUserDefaults standardUserDefaults] synchronize];// Add this
    [self removeChild:sound cleanup:YES];
    [self removeChild:menu2 cleanup:YES];
    soundOff = [CCMenuItemImage itemWithNormalImage:@"music-not.png" selectedImage:@"music-not-sel.png" target:self selector:@selector(turnOnSound)];
    soundOff.scale = 1.1;
    menutwo = [CCMenu menuWithItems:soundOff, nil];
    menutwo.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
    [self addChild:menutwo];
}
-(void) endlessSelected {
    [self removeChild:endless cleanup:YES];
    [self removeChild:endlessMenu cleanup:YES];
    [self removeChild:level cleanup:YES];
    [self removeChild:levelMenu cleanup:YES];
    endless = [CCMenuItemImage itemWithNormalImage:@"endless-sel.png" selectedImage:@"endless-sel.png" target:self selector:@selector(endlessSelected)];
    endlessMenu = [CCMenu menuWithItems:endless, nil];
    endlessMenu.position = ccp(screenCenter.x - 95,screenCenter.y);
    [self addChild:endlessMenu];
    level = [CCMenuItemImage itemWithNormalImage:@"level.png" selectedImage:@"level-sel.png" target:self selector:@selector(levelSelected)];
    levelMenu = [CCMenu menuWithItems:level, nil];
    levelMenu.position = ccp(screenCenter.x + 95,screenCenter.y);
    [self addChild:levelMenu];
    isEndlessMode = TRUE;
    isLevelMode = FALSE;
}
-(void) levelSelected {
    [self removeChild:endless cleanup:YES];
    [self removeChild:endlessMenu cleanup:YES];
    [self removeChild:level cleanup:YES];
    [self removeChild:levelMenu cleanup:YES];
    level = [CCMenuItemImage itemWithNormalImage:@"level-sel.png" selectedImage:@"level-sel.png" target:self selector:@selector(levelSelected)];
    levelMenu = [CCMenu menuWithItems:level, nil];
    levelMenu.position = ccp(screenCenter.x + 95,screenCenter.y);
    [self addChild:levelMenu];
    endless = [CCMenuItemImage itemWithNormalImage:@"endless.png" selectedImage:@"endless-sel.png" target:self selector:@selector(endlessSelected)];
    endlessMenu = [CCMenu menuWithItems:endless, nil];
    endlessMenu.position = ccp(screenCenter.x - 95,screenCenter.y);
    [self addChild:endlessMenu];
    isEndlessMode = FALSE;
    isLevelMode = TRUE;
}
-(void) settings
{
    if (theLogs == TRUE) {
        NSLog(@"MGWU Button Clicked");
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[Settings node]]];
}
-(void) unPause
{
    NSLog(@"Play Button Clicked");
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"musicon"] == TRUE) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    if (isLevelMode == TRUE) {
        [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration:0.5f scene:[Scene node]]];
    } else if (isEndlessMode == TRUE) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    }
//    [[CCDirector sharedDirector] replaceScene:
//     [CCTransitionSlideInR transitionWithDuration:0.5f scene:[LevelSelect node]]];
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