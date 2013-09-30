//
//  LevelSelect.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/3/13.
//
//


/*
 
 
 This is stuff I have to do before I sleep today:
 
 I have to set up all the scenes and optimize them for mostly every device
 I have to set up the level select menus and make them appear correctly
 I have to change some of the gameplay graphics including the target
 I have to make the level generation process as easy as possible
 I have to make some pre-made patterns that can be used again in combos
 I have to remove the MGWU SDK unless I actually have a need for it
 
 
 
 */

#import "LevelSelect.h"
#import "HelloWorldLayer.h"
#import "Title.h"
#import "Scene.h"
//#import "Level2.h"

@implementation LevelSelect

-(id) init
{
    if ((self = [super init]))
    {
        CGSize screen = [[CCDirector sharedDirector] screenSize];
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        glClearColor(255, 255, 255, 255);
        [self unscheduleAllSelectors];
        
        // have everything stop
        CCNode* node;
        CCARRAY_FOREACH([self children], node)
        {
            [node pauseSchedulerAndActions];
        }
        
        CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"Endless Mode" fontName:@"HelveticaNeue-Light" fontSize:30];
        gameOver.position = CGPointMake(160, 300);
        [self addChild:gameOver z:100 tag:100];
        
        CCLabelTTF* bosstag = [CCLabelTTF labelWithString:@"Level Select" fontName:@"HelveticaNeue-Light" fontSize:30];
        bosstag.position = CGPointMake(160, 50);
        [self addChild:bosstag z:100 tag:100];
        
        CCTintTo* tint = [CCTintTo actionWithDuration:0 red:10 green:0 blue:0];
        [gameOver runAction:tint];
        CCTintTo* tint2 = [CCTintTo actionWithDuration:0 red:10 green:0 blue:0];
        [bosstag runAction:tint2];
        
        CCSprite* background = [CCSprite spriteWithFile:@"back31.png"];
        background.position = ccp(screen.width/2,screen.height/2);
        [self addChild:background];
                
        CCMenuItem *endlessMode = [CCMenuItemImage itemWithNormalImage:@"endless.png" selectedImage:@"endless.png" target:self selector:@selector(level1)];
        endlessMode.position = ccp(screenSize.width/2, (screenSize.height/4) *3);
        CCMenu *endlessModeMenu = [CCMenu menuWithItems:endlessMode, nil];
        endlessModeMenu.position = CGPointZero;
        [self addChild:endlessModeMenu];
        
        CCMenuItem *bossMode = [CCMenuItemImage itemWithNormalImage:@"bossmode.png" selectedImage:@"bossmode.png" target:self selector:@selector(level2)];
        bossMode.position = ccp(screenSize.width/2, screenSize.height/4);
        CCMenu *bossModeMenu = [CCMenu menuWithItems:bossMode, nil];
        bossModeMenu.position = CGPointZero;
        [self addChild:bossModeMenu];
        
        CCMenuItem *backButton = [CCMenuItemImage itemWithNormalImage:@"back.png" selectedImage:@"back-sel.png" target:self selector:@selector(unPause)];
        backButton.position = ccp(screenSize.width / 14, screenSize.height / 1.05);
        backButton.scale = 0.5;
        CCMenu *backButtonMenu = [CCMenu menuWithItems:backButton, nil];
        backButtonMenu.position = CGPointZero;
        [self addChild:backButtonMenu];
        
    }
    return self;
}

-(void) level2
{
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInR transitionWithDuration:0.5f scene:[Scene node]]];
}

-(void) setDimensionsInPixelsOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height
{
    spriteToSetDimensions.scaleX = width/[spriteToSetDimensions boundingBox].size.width;
    spriteToSetDimensions.scaleY = height/[spriteToSetDimensions boundingBox].size.height;
}

-(void) level1
{
    NSNumber *leveldata = [NSNumber numberWithInteger:1];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInB transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

-(void) obama
{
    NSNumber *leveldata = [NSNumber numberWithInteger:3];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

-(void) unPause
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5f scene:[Title node]]];
}


@end
