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
        size = [[CCDirector sharedDirector] winSize];
        CGSize screensize = [[CCDirector sharedDirector] screenSizeInPixels];
        screenCenter = CGPointMake(size.width/2, size.height/2);
        
//        CCSprite* background = [CCSprite spriteWithFile:@"targeted.png"];
        
        CCSprite *background = [CCSprite spriteWithFile:@"blank.png"];
        background.position = screenCenter;
        [self addChild:background z:-10000];
        
        
        if(screensize.height == 1136)
        {
            //            glClearColor(255, 255, 255, 255);
            [self unscheduleAllSelectors];
            
            // have everything stop
            CCNode* node;
            CCARRAY_FOREACH([self children], node)
            {
                [node pauseSchedulerAndActions];
            }
                        
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"zoom.mp3"];
            
            // add a play button
            CCSprite *playButton = [CCSprite spriteWithFile:@"startButton.png"];
            CCSprite *playButtonSel = [CCSprite spriteWithFile:@"startButton-sel.png"];
            playMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:playButton selectedSprite:playButtonSel disabledSprite:nil target:self selector:@selector(unPause)];
            
            // add a quit button
            CCSprite *leaderboardButton = [CCSprite spriteWithFile:@"leaderButton.png"];
            CCSprite *leaderboardButtonSel = [CCSprite spriteWithFile:@"leaderButton-sel.png"];
            leaderMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:leaderboardButton selectedSprite:leaderboardButtonSel disabledSprite:nil target:self selector:@selector(high)];
            
            menu = [CCMenu menuWithItems:playMenuItem, leaderMenuItem, nil];
            [menu alignItemsHorizontallyWithPadding:2.0f];
            menu.position = ccp(screenCenter.x, screenCenter.y / 1.2);
            [self addChild:menu];
        }
        else{
            //        glClearColor(0.91,0.92, 0.91, 1.0);
            [self unscheduleAllSelectors];
            
            // have everything stop
            CCNode* node;
            CCARRAY_FOREACH([self children], node)
            {
                [node pauseSchedulerAndActions];
            }
            
            // This is where I can code my stuff
            
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"zoom.mp3"];
            // add the labels shown during game over
            CGSize screenSize = [[CCDirector sharedDirector] winSize];
            
            // add a play button
            CCSprite *playButton = [CCSprite spriteWithFile:@"startButton.png"];
            CCSprite *playButtonSel = [CCSprite spriteWithFile:@"startButton-sel.png"];
            playMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:playButton selectedSprite:playButtonSel disabledSprite:nil target:self selector:@selector(unPause)];
            
            // add a quit button
            CCSprite *leaderboardButton = [CCSprite spriteWithFile:@"leaderButton.png"];
            CCSprite *leaderboardButtonSel = [CCSprite spriteWithFile:@"leaderButton-sel.png"];
            leaderMenuItem = [[CCMenuItemSprite alloc] initWithNormalSprite:leaderboardButton selectedSprite:leaderboardButtonSel disabledSprite:nil target:self selector:@selector(high)];
            
            menu = [CCMenu menuWithItems:playMenuItem, leaderMenuItem, nil];
            [menu alignItemsVerticallyWithPadding:20.0f];
            menu.position = ccp(screenCenter.x, screenCenter.y / 2.2);
            [self addChild:menu];
            
            
//            CCLabelTTF* play = [CCMenuItemImage itemFromNormalImage:@"play.png" selectedImage:@"play-sel.png" target:self selector:@selector(unPause)];
//            play.position = ccp(160, 200);
//            CCMenu *playmenu = [CCMenu menuWithItems:play, nil];
//            playmenu.position = CGPointZero;
//            [self addChild:playmenu];
//            play.scale = 0;
//            id bossscale = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
//            [play runAction:bossscale];
//            
//            CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"highscores.png" selectedImage:@"highscores-sel.png" target:self selector:@selector(high)];
//            highscore.position = ccp(80, 60);
//            CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
//            starMenu.position = CGPointZero;
//            [self addChild:starMenu];
//            highscore.scale = 0;
//            id menuscale = [CCScaleTo actionWithDuration:0.7f scale:1.0f];
//            [highscore runAction:menuscale];
//            
//            CCLabelTTF *mgwu = [CCMenuItemImage itemFromNormalImage:@"mgwu.png" selectedImage:@"mgwu-sel.png" target:self selector:@selector(mgwu)];
//            mgwu.position = ccp(240, 60);
//            CCMenu *mgmenu = [CCMenu menuWithItems:mgwu, nil];
//            mgmenu.position = CGPointZero;
//            [self addChild:mgmenu];
//            mgwu.scale = 0;
//            id mmenuscale = [CCScaleTo actionWithDuration:0.7f scale:1.0f];
//            [mgwu runAction:mmenuscale];
            
        CCSprite* title = [CCSprite spriteWithFile:@"title_logo.png"];
        title.position = ccp(screenCenter.x,screenCenter.y * 3);
        [self dotsEffect:title];
        [self addChild:title];

//if([[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying] == false)
//{
//            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"techno.mp3" loop:YES];
//}

//            bluemove = [CCSprite spriteWithFile:@"Glowing_Blue_Orb.png"];
//            bluemove.scale = 0.1;
//            bluemove.position = ccp(250,450);
//            [self addChild:bluemove];
//
//            orangemove = [CCSprite spriteWithFile:@"shield.png"];
//            orangemove.scale = 0.05;
//            orangemove.position = ccp(245,365);
//            [self addChild:orangemove];
//
//            id moveAction = [CCMoveTo actionWithDuration:1 position:ccp(290,365)];
//            id moveActionBack = [CCMoveTo actionWithDuration:1 position:ccp(245,365)];
//            id delayTimeAction = [CCDelayTime actionWithDuration:1];
//            id delayTime2 = [CCDelayTime actionWithDuration:2];
//            CCSequence *act =[CCSequence actions:moveAction,delayTimeAction,moveActionBack,delayTimeAction,nil];
//            CCRepeatForever *repeat = [CCRepeatForever actionWithAction:act];
//            [orangemove runAction:repeat];
//            id makeblueball = [CCCallFunc actionWithTarget:self selector:@selector(makeblueball)];
//            id makeblueball2 = [CCCallFunc actionWithTarget:self selector:@selector(makeblueball2)];
//
//            id moveBlueLeft = [CCMoveTo actionWithDuration:2 position:ccp(250,345)];
//            id removeMySprite = [CCCallFuncND actionWithTarget:bluemove selector:@selector(removeFromParentAndCleanup:) data:(void*)NO];
//            [bluemove runAction:[CCSequence actions:moveBlueLeft,removeMySprite,nil]];
//
//            CCSequence *spawnBlue = [CCSequence actions:makeblueball,delayTime2,makeblueball2,delayTime2,nil];
//            CCRepeatForever *repblue = [CCRepeatForever actionWithAction:spawnBlue];
//            [self runAction:repblue];
        }
    }
    return self;
}


-(void) makeblueball
{
    bluemove = [CCSprite spriteWithFile:@"Glowing_Blue_Orb.png"];
    bluemove.scale = 0.1;
    bluemove.position = ccp(250,450);
    [self addChild:bluemove];
    
    id fadein = [CCFadeIn actionWithDuration:0.5];
    id delay = [CCDelayTime actionWithDuration:1];
    id fadeout = [CCFadeOut actionWithDuration:0.5];
    
    id moveBlueLeft = [CCMoveTo actionWithDuration:2 position:ccp(250,345)];
    id removeMySprite = [CCCallFuncND actionWithTarget:bluemove selector:@selector(removeFromParentAndCleanup:) data:(void*)NO];
    [bluemove runAction:[CCSequence actions:moveBlueLeft,removeMySprite,nil]];
    [bluemove runAction:[CCSequence actions:fadein,delay,fadeout, nil]];
}

-(void) makeblueball2
{
    bluemove = [CCSprite spriteWithFile:@"Glowing_Blue_Orb.png"];
    bluemove.scale = 0.1;
    bluemove.position = ccp(280,450);
    [self addChild:bluemove];
    
    id fadein = [CCFadeIn actionWithDuration:0.5];
    id delay = [CCDelayTime actionWithDuration:1];
    id fadeout = [CCFadeOut actionWithDuration:0.5];
    
    id moveBlueLeft = [CCMoveTo actionWithDuration:2 position:ccp(280,345)];
    id removeMySprite = [CCCallFuncND actionWithTarget:bluemove selector:@selector(removeFromParentAndCleanup:) data:(void*)NO];
    [bluemove runAction:[CCSequence actions:moveBlueLeft,removeMySprite,nil]];
    [bluemove runAction:[CCSequence actions:fadein,delay,fadeout, nil]];
}

-(void) mgwu
{
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
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"high"] == false)
    {
        [MGWU showMessage:@"Achievement Get!      You found a bug!" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"high"];
    }
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:[StatLayer node]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"zoom.mp3"];
}

-(void) unPause
{
    //    [[CCDirector sharedDirector] popSceneWithTransition:
    //       [CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:0.5f scene:[LevelSelect node]]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"zoom.mp3"];
}
-(void) dotsEffect:(CCSprite *) spriteToBeTheNextBigThing {
    id dropdown = [CCMoveTo actionWithDuration:0.5f position:ccp(screenCenter.x, screenCenter.y * 1.4)];
    id jump = [CCJumpBy actionWithDuration:0.35f position:CGPointZero height:40 jumps:1];
    id repeatJump = [CCRepeat actionWithAction:jump times:1];
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:dropdown, repeatJump, nil]];
}

-(void) slideEffect:(CCSprite *) spriteToBeTheNextBigThing {
    id dropdown = [CCMoveTo actionWithDuration:0.5f position:ccp(screenCenter.x, screenCenter.y * 1.4)];
    id jump = [CCJumpBy actionWithDuration:0.35f position:CGPointZero height:40 jumps:1];
    id repeatJump = [CCRepeat actionWithAction:jump times:1];
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:dropdown, repeatJump, nil]];
}
@end