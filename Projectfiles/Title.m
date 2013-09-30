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
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            screenCenter = ccp(size.width/2, size.height/2);
        
            // Background Sprite
            CCSprite *background = [CCSprite spriteWithFile:@"blank.png"];
            background.position = screenCenter;
            [self addChild:background z:-10000];
        
            // Have Everything Stop
            [self unscheduleAllSelectors];
            CCNode* node;
            CCARRAY_FOREACH([self children], node)
            {
                [node pauseSchedulerAndActions];
            }
        
            // Sounds
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"zoom.mp3"];
        
            // Title Logo - Bulls Eye
            myTitleLogo = [CCSprite spriteWithFile:@"logo.png"];
            myTitleLogo.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:myTitleLogo z:10000];
            [self dotsEffect:myTitleLogo];
        
//            // Add and Display the Start Button
//            CCSprite *startButton = [CCSprite spriteWithFile:@"startButton.png"];
//            CCSprite *startButtonSel = [CCSprite spriteWithFile:@"startButton-sel.png"];
//            startButton.scale = 1.0;
//            startButtonSel.scale = 1.0;
//            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
//                startButton.scale = 1.5;
//                startButtonSel.scale = 1.5;
//            }
//            playMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:startButton selectedSprite:startButtonSel disabledSprite:nil target:self selector:@selector(unPause)];
//            // Start Menu
//            menu = [CCMenu menuWithItems:playMenuItem, nil];
//            [menu alignItemsHorizontally];
//            menu.position = ccp(screenCenter.x * 5, screenCenter.y / 1.5);
////            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
////                menu.position = ccp(menu.position.x - 400, screenCenter.y / 1.7);
////            }
//            [self slideEffectRight:menu];
//            [self addChild:menu];
//        
//            // Add and Display the Leaderboard Button
//            CCSprite *leaderboardButton = [CCSprite spriteWithFile:@"leaderButton.png"];
//            CCSprite *leaderboardButtonSel = [CCSprite spriteWithFile:@"leaderButton-sel.png"];
//            leaderboardButton.scale = 1.0;
//            leaderboardButtonSel.scale = 1.0;
//            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
//                leaderboardButton.scale = 1.5;
//                leaderboardButtonSel.scale = 1.5;
//            }
//            leaderMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:leaderboardButton selectedSprite:leaderboardButtonSel disabledSprite:nil target:self selector:@selector(high)];
//            // Leaderboard Menu
//            menu2 = [CCMenu menuWithItems:leaderMenuItem, nil];
//            [menu2 alignItemsHorizontally];
//            menu2.position = ccp(screenCenter.x / 5, screenCenter.y / 3.1);
//            [self slideEffectLeft:menu2];
//            [self addChild:menu2];
        
        
        CCMenuItemImage *start = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start-sel.png" target:self selector:@selector(unPause)];
        start.scale = 1.1;
        
        CCMenuItemImage *about = [CCMenuItemImage itemWithNormalImage:@"about.png" selectedImage:@"about-sel.png" target:self selector:@selector(high)];
        about.scale = 1.1;
        
        CCMenuItemImage *settings = [CCMenuItemImage itemWithNormalImage:@"settings.png" selectedImage:@"settings-sel.png" target:self selector:@selector(high)];
        settings.scale = 1.1;
        
        CCMenu *playMenu = [CCMenu menuWithItems:start, about, settings, nil];
        [playMenu alignItemsVerticallyWithPadding:5];
        playMenu.position = ccp(screenSize.width/2, screenSize.height/3.5);
        [self addChild:playMenu];
        
        CCSprite *opaqueBG = [CCSprite spriteWithFile:@"background1.png"];
        opaqueBG.position = screenCenter;
        [self addChild:opaqueBG z:-4];

            // First Ball - The One on the Left
            CCSprite *firstBall = [CCSprite spriteWithFile:@"cyan.png"];
            firstBall.scale = .3;
            [firstBall setAnchorPoint:ccp(.5,0)];
            [firstBall setPosition:ccp(size.width*.2,size.height*.1)];
            [self addChild:firstBall z:-5];
            // List of Actions for the Ball Dropping
            CCJumpBy *dropTheBall = [CCJumpBy actionWithDuration:2 position:CGPointZero height:screenSize.height / 3 jumps:1];
            CCEaseOut *squeze1 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.1] rate:2];
            CCEaseIn *expand1 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.3] rate:2];
            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
                squeze1 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.8 scaleY:.4] rate:2];
                expand1 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.8 scaleY:.8] rate:2];
            }
            CCSequence *ballDropSequence = [CCSequence actions: dropTheBall, squeze1, expand1, nil];
            CCRepeatForever* repeatJump = [CCRepeatForever actionWithAction:ballDropSequence];
            [firstBall runAction:repeatJump];

            // Second Ball - The One on the Right
            CCSprite *secondBall = [CCSprite spriteWithFile:@"cyan.png"];
            secondBall.scale = .3;
            [secondBall setAnchorPoint:ccp(.5,0)];
            [secondBall setPosition:ccp(size.width*.8,size.height*.1)];
            [self addChild:secondBall z:-5];
            // List of Actions for the Ball Dropping
            CCJumpBy *dropTheBall2 = [CCJumpBy actionWithDuration:1.1 position:CGPointZero height:screenSize.height / 3 jumps:1];
            CCEaseOut *squeze2 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.1] rate:2];
            CCEaseIn *expand2 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.3] rate:2];
            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
                squeze2 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.8 scaleY:.4] rate:2];
                expand2 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.8 scaleY:.8] rate:2];
            }
            CCSequence *ballDropSequence2 = [CCSequence actions: dropTheBall2, squeze2, expand2, nil];
            CCRepeatForever* repeatJump2 = [CCRepeatForever actionWithAction:ballDropSequence2];
            [secondBall runAction:repeatJump2];
        
            // This is the OLD code for the bouncing of the ball
            // Fix the bouncing problems and/or write better code
            //        CCJumpTo *jumping1 = [CCJumpTo actionWithDuration:2 position:ccp(size.width*.4,size.height*.1) height:size.height*.5 jumps:1];
            //        CCEaseOut *squezing1 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.1] rate:2];
            //        CCEaseIn *expanding1 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.3] rate:2];
            //        
            //        CCJumpTo *jumping2 = [CCJumpTo actionWithDuration:2 position:ccp(size.width*.5,size.height*.1) height:size.height*.5 jumps:1];
            //        CCEaseOut *squezing2 = [CCEaseOut actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.1] rate:2];
            //        CCEaseIn *expanding2 = [CCEaseIn actionWithAction:[CCScaleTo actionWithDuration:.1 scaleX:.3 scaleY:.3] rate:2];
            //        
            //        CCSequence *ballDropSeq = [CCSequence actions: jumping1, squezing1, expanding1, jumping2, squezing2, expanding2, nil];
            //        CCRepeatForever *repeatJumps = [CCRepeatForever actionWithAction:ballDropSeq];
            //        [ballDrop runAction:repeatJumps];
        
            // Other Device Optimizations (Like iPad, iPhone 5, etc.)
            if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
                // First Ball - The One on the Left
                firstBall.scale = .8;
                // Second Ball - The One on the Right
                secondBall.scale = .8;
                // Menu Scale
            }
    }
    return self;
}

-(void) mgwu
{
    if (theLogs == TRUE) {
        NSLog(@"MGWU Button Clicked");
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"data"] == false)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:@"coins"];
        [MGWU showMessage:@"Achievement Get!      Clearing the data" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"data"];
    }
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [MGWU displayCrossPromo];
    [[SimpleAudioEngine sharedEngine] playEffect:@"zoom.mp3"];
}

-(void) high
{
    if (theLogs == TRUE) {
        NSLog(@"Leaderboards Button Clicked");
    }
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"high"] == false) {
        [MGWU showMessage:@"Achievement Get!      You found a bug!" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"high"]; }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:[StatLayer node]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"zoom.mp3"];
}

-(void) unPause
{
    if (theLogs == TRUE) {
        NSLog(@"Play Button Clicked");
    }
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:0.5f scene:[LevelSelect node]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"zoom.mp3"];
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