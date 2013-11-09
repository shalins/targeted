//
//  LevelSelect.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/3/13.
//
//

#import "Scene.h"
#import "HelloWorldLayer.h"
#import "Title.h"
#import "LevelSelect.h"
//#import "Level2.h"

@implementation Scene

-(id) init
{
    if ((self = [super init]))
    {
        glClearColor(255, 255, 255, 255);
        [self unscheduleAllSelectors];
        
        // have everything stop
        CCNode* node;
        CCARRAY_FOREACH([self children], node)
        {
            [node pauseSchedulerAndActions];
        }
        
        // add the labels shown during game over
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
                
        CCLabelTTF* bosstag = [CCLabelTTF labelWithString:@"Level Select" fontName:@"HelveticaNeue-Light" fontSize:40];
        bosstag.position = CGPointMake(160, 440);
        [self addChild:bosstag z:100 tag:100];
        
        CCTintTo* tint = [CCTintTo actionWithDuration:0.1 red:0 green:0 blue:255];
        //[gameOver runAction:tint];
        CCTintTo* tint2 = [CCTintTo actionWithDuration:0.1 red:0 green:0 blue:255];
        [bosstag runAction:tint2];
        
        CCSprite* background = [CCSprite spriteWithFile:@"yellowback.png"];
        background.position = ccp(160,240);
        [self addChild:background];
        
        CCMenuItemFont *playAgain = [CCMenuItemFont itemFromString: @"back" target:self selector:@selector(unPause)];
        CCMenuItemFont *restart = [CCMenuItemFont itemFromString: @"Endless Mode" target:self selector:@selector(level1)];
        CCMenuItemFont *quit = [CCMenuItemFont itemFromString: @"Scene Selection" target:self selector:@selector(level2)];
        CCMenuItemFont *obama = [CCMenuItemFont itemFromString: @"Level 3" target:self selector:@selector(obama)];

        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 0)
        {
            CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            highscore.position = ccp(80, 390);
            CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
            starMenu.position = CGPointZero;
            [self addChild:starMenu];
            
            CCLabelTTF *boss = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            boss.position = ccp(240, 390);
            CCMenu *moreMenu = [CCMenu menuWithItems:boss, nil];
            moreMenu.position = CGPointZero;
            [self addChild:moreMenu];
            
            CCLabelTTF *back = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back.position = ccp(80, 240);
            //back.scale = 0.5;
            CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
            backmenu.position = CGPointZero;
            [self addChild:backmenu];
            
            CCLabelTTF *back2 = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back2.position = ccp(240, 240);
            //back2.scale = 0.5;
            CCMenu *backmenu2 = [CCMenu menuWithItems:back2, nil];
            backmenu2.position = CGPointZero;
            [self addChild:backmenu2];
        }
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 1)
        {
            CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"bigblue.png" selectedImage:@"bigblue.png" target:self selector:@selector(level1)];
            highscore.position = ccp(80, 390);
            CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
            starMenu.position = CGPointZero;
            [self addChild:starMenu];
            
            CCLabelTTF *boss = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            boss.position = ccp(240, 390);
            CCMenu *moreMenu = [CCMenu menuWithItems:boss, nil];
            moreMenu.position = CGPointZero;
            [self addChild:moreMenu];
            
            CCLabelTTF *back = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back.position = ccp(80, 240);
            //back.scale = 0.5;
            CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
            backmenu.position = CGPointZero;
            [self addChild:backmenu];
            
            CCLabelTTF *back2 = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back2.position = ccp(240, 240);
            //back2.scale = 0.5;
            CCMenu *backmenu2 = [CCMenu menuWithItems:back2, nil];
            backmenu2.position = CGPointZero;
            [self addChild:backmenu2];
        }
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 2)
        {
            CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"bigblue.png" selectedImage:@"bigblue.png" target:self selector:@selector(level1)];
            highscore.position = ccp(80, 390);
            CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
            starMenu.position = CGPointZero;
            [self addChild:starMenu];
            
            CCLabelTTF *boss = [CCMenuItemImage itemFromNormalImage:@"alienblue.png" selectedImage:@"alienblue.png" target:self selector:@selector(level2)];
            boss.position = ccp(240, 390);
            CCMenu *moreMenu = [CCMenu menuWithItems:boss, nil];
            moreMenu.position = CGPointZero;
            [self addChild:moreMenu];
            
            CCLabelTTF *back = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back.position = ccp(80, 240);
            //back.scale = 0.5;
            CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
            backmenu.position = CGPointZero;
            [self addChild:backmenu];
            
            CCLabelTTF *back2 = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back2.position = ccp(240, 240);
            //back2.scale = 0.5;
            CCMenu *backmenu2 = [CCMenu menuWithItems:back2, nil];
            backmenu2.position = CGPointZero;
            [self addChild:backmenu2];
        }
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 3)
        {
            CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"bigblue.png" selectedImage:@"bigblue.png" target:self selector:@selector(level1)];
            highscore.position = ccp(80, 390);
            CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
            starMenu.position = CGPointZero;
            [self addChild:starMenu];
            
            CCLabelTTF *boss = [CCMenuItemImage itemFromNormalImage:@"alienblue.png" selectedImage:@"alienblue.png" target:self selector:@selector(level2)];
            boss.position = ccp(240, 390);
            CCMenu *moreMenu = [CCMenu menuWithItems:boss, nil];
            moreMenu.position = CGPointZero;
            [self addChild:moreMenu];
            
            CCLabelTTF *back = [CCMenuItemImage itemFromNormalImage:@"blubama.png" selectedImage:@"blubama.png" target:self selector:@selector(obama)];
            back.position = ccp(80, 240);
            //back.scale = 0.5;
            CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
            backmenu.position = CGPointZero;
            [self addChild:backmenu];
            
            CCLabelTTF *back2 = [CCMenuItemImage itemFromNormalImage:@"locked.png" selectedImage:@"locked.png" target:self selector:@selector(locked)];
            back2.position = ccp(240, 240);
            //back2.scale = 0.5;
            CCMenu *backmenu2 = [CCMenu menuWithItems:back2, nil];
            backmenu2.position = CGPointZero;
            [self addChild:backmenu2];
        }
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] >= 4)
        {
            CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"bigblue.png" selectedImage:@"bigblue.png" target:self selector:@selector(level1)];
            highscore.position = ccp(80, 390);
            CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
            starMenu.position = CGPointZero;
            [self addChild:starMenu];
            
            CCLabelTTF *boss = [CCMenuItemImage itemFromNormalImage:@"alienblue.png" selectedImage:@"alienblue.png" target:self selector:@selector(level2)];
            boss.position = ccp(240, 390);
            CCMenu *moreMenu = [CCMenu menuWithItems:boss, nil];
            moreMenu.position = CGPointZero;
            [self addChild:moreMenu];
            
            CCLabelTTF *back = [CCMenuItemImage itemFromNormalImage:@"blubama.png" selectedImage:@"blubama.png" target:self selector:@selector(obama)];
            back.position = ccp(80, 240);
            //back.scale = 0.5;
            CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
            backmenu.position = CGPointZero;
            [self addChild:backmenu];
            
            CCLabelTTF *back2 = [CCMenuItemImage itemFromNormalImage:@"blueblossom.png" selectedImage:@"blueblossom.png" target:self selector:@selector(rose)];
            back2.position = ccp(240, 240);
            //back2.scale = 0.5;
            CCMenu *backmenu2 = [CCMenu menuWithItems:back2, nil];
            backmenu2.position = CGPointZero;
            [self addChild:backmenu2];
        }
        
        CCLabelTTF *back3 = [CCMenuItemImage itemFromNormalImage:@"back.png" selectedImage:@"back-sel.png" target:self selector:@selector(unPause)];
        back3.position = ccp(160, 80);
        back3.scale = 0.5;
        CCMenu *backmenu3 = [CCMenu menuWithItems:back3, nil];
        backmenu3.position = CGPointZero;
        [self addChild:backmenu3];

    }
    return self;
}
-(void) level1
{
    NSNumber *leveldata = [NSNumber numberWithInteger:1];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level2
{
    NSNumber *leveldata = [NSNumber numberWithInteger:2];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) obama
{
    NSNumber *leveldata = [NSNumber numberWithInteger:3];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

-(void) rose
{
    NSNumber *leveldata = [NSNumber numberWithInteger:4];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

-(void) locked
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"cheater"] == false)
    {
        [MGWU showMessage:@"Achievement Get!      That level is locked!" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"cheater"];
    }
}

-(void) unPause
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5f scene:[LevelSelect node]]];
}
@end