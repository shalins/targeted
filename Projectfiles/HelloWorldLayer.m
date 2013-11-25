/*
 * Copyright (c) 2010-2011 Shalin Shah.
 */

#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "Player.h"
#import "Dead.h"
#import "LevelSelect.h"
#import "StoreLayer.h"

@implementation HelloWorldLayer

int playerWidth = 41.6;
int playerHeight = 78.6;
int bossWidth = 190/2;
int bossHeight = 265/2;
int thetemporalint = 180;
int fromNumber;
int toNumber;
id movePlayer;
int omganothertemportalint;
bool bwooo = false;
int gameSegment;
int framespast;
int secondspast;
int stagespast;
int wowanothertemportalint;
int coins;
CCMotionStreak* streak;
NSMutableDictionary *initialBoss;

-(id) init
{
    if ((self = [super init]))
    {
        // get screen center and screen size
        screenCenter = [CCDirector sharedDirector].screenCenter;
        screenSize = [[CCDirector sharedDirector] winSize];
        level1bg = [CCSprite spriteWithFile:@"level1bg.png"];
        level2bg = [CCSprite spriteWithFile:@"level2bg.png"];
        level3bg = [CCSprite spriteWithFile:@"level3bg.png"];
        level4bg = [CCSprite spriteWithFile:@"level4bg.png"];
        level5bg = [CCSprite spriteWithFile:@"level5bg.png"];
        level6bg = [CCSprite spriteWithFile:@"level6bg.png"];
        level7bg = [CCSprite spriteWithFile:@"level7bg.png"];
        level8bg = [CCSprite spriteWithFile:@"level8bg.png"];
        level9bg = [CCSprite spriteWithFile:@"level9bg.png"];
        level1bg.position = screenCenter;
        level2bg.position = screenCenter;
        level3bg.position = screenCenter;
        level4bg.position = screenCenter;
        level5bg.position = screenCenter;
        level6bg.position = screenCenter;
        level7bg.position = screenCenter;
        level8bg.position = screenCenter;
        level9bg.position = screenCenter;

        targetHit = false;
        [[NSUserDefaults standardUserDefaults] setBool:targetHit forKey:@"targetHit"];
        //        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        //        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hex.mp3" loop:YES];
        deathanimation = true;
        glClearColor(255,255,255,255);
        continueCost = 1;
        coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
        redtint = 0;
        greentint = 0;
        bluetint = 255;
        wowanothertemportalint = 180;
        NSNumber *leveldata = [[NSUserDefaults standardUserDefaults] objectForKey:@"leveldata"];
        level = [leveldata intValue];
        NSLog(@"Level %i", level);
        flashTheThing = FALSE;
        shootThePowerup = FALSE;
        isItSlow = false;
        shieldon = false;
        framespast = 0;
        secondspast = 0;
        gameSegment = 0;
        bosstime = true;
        isTimeWarped = false;
        thetemporalint = 180;
        omganothertemportalint = 180;
        intScore = 0;
        bullets = [[NSMutableArray alloc] init];
        fireBalls = [[NSMutableArray alloc] init];
        smileyFaces = [[NSMutableArray alloc] init];
        smallerBallers = [[NSMutableArray alloc] init];
        slowDowners = [[NSMutableArray alloc] init];
        flowerbullets = [[NSMutableArray alloc] init];
        fakebullets = [[NSMutableArray alloc] init];
        powerups = [[NSMutableArray alloc] init];
        initialBoss = [[NSMutableDictionary alloc] init];
        director = [CCDirector sharedDirector];
        glClearColor(255, 255, 255, 255);
        // initialize player sprite
        player = [CCSprite spriteWithFile:@"orange.png"];
        player.scale = 0.15;
        player.position = ccp(screenCenter.x,screenCenter.y - 40);
        [self addChild:player z:9001];
        [self schedule:@selector(updateCoins)];
        [self scheduleUpdate];
        [self pause];
        pausebutton = [CCSprite spriteWithFile:@"pause.png"];
        pausebutton.position = ccp(screenSize.width - 15,screenSize.height - 15);
        pausebutton.scale = 1;
//        [self addChild:pausebutton];
        blocker = [CCSprite spriteWithFile:@"blocker.png"];
        blocker.position = ccp(screenCenter.x,screenCenter.y * 1.3);
        blocker.scale = 0.8;
        // This shows the score
        //        [self initScore];        
        // If it's not endless mode
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"endless"] == false) {
            if(level == 1) {
                bosstime = true;
                stagespast = 5;
            }
            if(level == 2) {
                bosstime = true;
                stagespast = 10;
            }
            if(level == 3) {
                bosstime = true;
                stagespast = 15;
            }
            if(level == 4) {
                bosstime = true;
                stagespast = 20;
            }
            if(level == 5) {
                bosstime = true;
                stagespast = 25;
            }
            if(level == 6) {
                bosstime = true;
                stagespast = 30;
            }
            if(level == 7) {
                bosstime = true;
                stagespast = 35;
            }
            if(level == 8) {
                bosstime = true;
                stagespast = 40;
            }
            if(level == 9) {
                bosstime = true;
                stagespast = 45;
            }
        }        
        // Set up Tutorial
        tut = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:30];
        tut.position = screenCenter;
        [self addChild:tut z:10000];
        tut.visible = FALSE;
        // The setup for the game
        [self initBoss];
    }
    return self;
}
-(void)update:(ccTime)delta
{
    // Remove all the bullets after they move off the screen
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        CCSprite* shalinbullet = [bullets objectAtIndex:i];        
        if(shalinbullet.position.x > screenSize.width + 50) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i];        }
        if(shalinbullet.position.x < (screenSize.width / 10) - 50) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i];        }
        if(shalinbullet.position.y < -20) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i]; }
        if(shalinbullet.position.y > screenCenter.y * 3) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i]; }
    }
    for(NSUInteger i = 0; i < [smileyFaces count]; i++) {
        CCSprite* shalinbullet = [smileyFaces objectAtIndex:i];
        if(shalinbullet.position.x > screenSize.width + 50) {
            Bullet *temp = [smileyFaces objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smileyFaces removeObjectAtIndex:i];        }
        if(shalinbullet.position.x < (screenSize.width / 10) - 50) {
            Bullet *temp = [smileyFaces objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smileyFaces removeObjectAtIndex:i];        }
        if(shalinbullet.position.y < -20) {
            Bullet *temp = [smileyFaces objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smileyFaces removeObjectAtIndex:i]; }
        if(shalinbullet.position.y > screenCenter.y * 3) {
            Bullet *temp = [smileyFaces objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smileyFaces removeObjectAtIndex:i]; }
    }
    for(NSUInteger i = 0; i < [smallerBallers count]; i++) {
        CCSprite* shalinbullet = [smallerBallers objectAtIndex:i];
        if(shalinbullet.position.x > screenSize.width + 50) {
            Bullet *temp = [smallerBallers objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smallerBallers removeObjectAtIndex:i];        }
        if(shalinbullet.position.x < (screenSize.width / 10) - 50) {
            Bullet *temp = [smallerBallers objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smallerBallers removeObjectAtIndex:i];        }
        if(shalinbullet.position.y < -20) {
            Bullet *temp = [smallerBallers objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smallerBallers removeObjectAtIndex:i]; }
        if(shalinbullet.position.y > screenCenter.y * 3) {
            Bullet *temp = [smallerBallers objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [smallerBallers removeObjectAtIndex:i]; }
    } for(NSUInteger i = 0; i < [slowDowners count]; i++) {
        CCSprite* shalinbullet = [slowDowners objectAtIndex:i];
        if(shalinbullet.position.x > screenSize.width + 50) {
            Bullet *temp = [slowDowners objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [slowDowners removeObjectAtIndex:i];        }
        if(shalinbullet.position.x < (screenSize.width / 10) - 50) {
            Bullet *temp = [slowDowners objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [slowDowners removeObjectAtIndex:i];        }
        if(shalinbullet.position.y < -20) {
            Bullet *temp = [slowDowners objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [slowDowners removeObjectAtIndex:i]; }
        if(shalinbullet.position.y > screenCenter.y * 3) {
            Bullet *temp = [slowDowners objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [slowDowners removeObjectAtIndex:i]; }
    }
    // Remove the level labels after they leave the screen
    if (LevelTag.position.y > screenCenter.y * 10) {
        [self removeChild:LevelTag cleanup:YES];
    }
    if(bosstime == false) {
        if(framespast == 300) {
            if(stagespast > -1) {
                [self returnBullet];
                for(NSUInteger i = 0; i < [bullets count]; i++) {
                    Bullet *temp = [bullets objectAtIndex:i];
                    [self removeChild:temp cleanup:YES];
                    int randomtemp = arc4random() % 10;
                    if(randomtemp == 5) {}
                }
                [bullets removeAllObjects];
                attacktype = 0;
                framespast = 0;
                stagespast++;
                bosstime = true;
            }
        }
    }
    if(bosstime == false) {
        if(stagespast > 3) {
            bosstime = true;
            stagespast = 5;
        }
    }
    [self grabTouchCoord];
    [streak setPosition:player.position];
    
    framespast++;
    secondspast = framespast / 60;
    
    [self bossAttack];
    [self detectCollisions];
    KKInput* input = [KKInput sharedInput];
    if ([input isAnyTouchOnNode:pausebutton touchPhase:KKTouchPhaseAny]) {
        [self pause];
    }
}
//-(void) initScore {
//    label = [CCLabelTTF labelWithString:@"0" fontName:@"HelveticaNeue-Light" fontSize:24];
//    label.position = ccp(5,463);
//    label.anchorPoint = ccp(0.0,0.5);
//    label.color = ccc3(0, 0, 0);
//    [self addChild: label];
//}
-(void) startTutorial {
    // Uses NSUserDefaults so doesn't appear twice
    if(framespast == 10) {
        tut = [CCLabelTTF labelWithString:@"Tap to move" fontName:@"Helvetica" fontSize:30];
        tut.position = ccp(screenCenter.x,screenCenter.y);
        tut.color = ccc3(0, 0, 0);
        [self addChild:tut];
    }
    if(framespast == 300) {
        [self shootBulletwithPos:1 angle:260 xpos:0 ypos:0];
        [self removeChild:tut];
        tut = [CCLabelTTF labelWithString:@"Avoid these" fontName:@"Helvetica" fontSize:30];
        tut.position = ccp(screenCenter.x,screenCenter.y);
        tut.color = ccc3(0, 0, 0);
        [self addChild:tut];
        
    }
    if(framespast == 580) {
        [self shootBulletwithPosShield:1 angle:260 xpos:0 ypos:0];
        [self removeChild:tut];
        tut = [CCLabelTTF labelWithString:@"These are shields" fontName:@"Helvetica" fontSize:30];
        tut.position = ccp(screenCenter.x,screenCenter.y);
        tut.color = ccc3(0, 0, 0);
        [self addChild:tut];
    }
    if(framespast == 750) {
        [self shootBulletwithPosShield:1 angle:260 xpos:0 ypos:0];
        [self removeChild:tut];
        tut = [CCLabelTTF labelWithString:@"Drag into target" fontName:@"Helvetica" fontSize:30];
        tut.position = ccp(screenCenter.x,screenCenter.y);
        tut.color = ccc3(0, 0, 0);
        [self addChild:tut];
    }
}
/* -------------------------------------------------------------------------------- */
/*    GAMEPLAY                                                                      */
/* -------------------------------------------------------------------------------- */
-(void) bossAttack {
    if(bosstime == true) {
        if (blocker.parent == nil) {
            [self addChild:blocker];
        }
        if(level == 1) {
            if(gameSegment == 0) {
                [self startTutorial];
            }
            if(gameSegment == 1) {
                [self removeChild:tut];
                [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"tutorialcompleted"];
                if(((framespast % 100) ==0) || ![initialBoss objectForKey:@1.1]) {
                    [initialBoss setObject:@TRUE forKey:@1.1];
                    [self shootBullet:1 angle:270];
                }
            }
            if(gameSegment == 2) {
                if((framespast % 155) ==0 || ![initialBoss objectForKey:@1.2]) {
                    if (shootThePowerup == FALSE) {
                        [self shootSlowDownMissile];
                        shootThePowerup = TRUE; }
                    [initialBoss setObject:@TRUE forKey:@1.2];
                    [self shootBullet:1 angle:230];
                    [self shootBullet:2 angle:270];
                    [self shootBullet:1 angle:310];
                }
            }
            if(gameSegment == 3) {
                if((framespast % 75) ==0 || ![initialBoss objectForKey:@1.3]) {
                    [initialBoss setObject:@TRUE forKey:@1.3];
                    [self shootBullet:3 angle:300];
                    [self shootBullet:3 angle:240];
                }
                for(NSUInteger i = 0; i < [bullets count]; i++) {
                    NSInteger j = i;
                    projectile = [bullets objectAtIndex:j];
                }
            }
            if(gameSegment == 4) {
                if((framespast % 30) ==0 || ![initialBoss objectForKey:@1.4]) {
                    [initialBoss setObject:@TRUE forKey:@1.4];
                    [self shootBullet:3 angle:180];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 30;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment == 5) {
                if((framespast % 75) ==0 || ![initialBoss objectForKey:@1.5]) {
                    [initialBoss setObject:@TRUE forKey:@1.5];
                    [self shootBullet:1 angle:270];
                    [self shootBullet:1 angle:270];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + (arc4random() % 90)-45;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment == 6) {
                if((framespast % 75) ==0 || ![initialBoss objectForKey:@1.6]) {
                    if (shootThePowerup == TRUE) {
                        [self shootMiniMeMissile];
                        shootThePowerup = FALSE; }
                    [initialBoss setObject:@TRUE forKey:@1.6];
                    [self shootBullet:3 angle:thetemporalint];
                    thetemporalint = thetemporalint + 15;
                    [self shootBullet:3 angle:thetemporalint];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        [[bullets objectAtIndex:j] changeAngle:[[bullets objectAtIndex:j] getAngle] + 5];
                    }
                }
            }
            if(gameSegment == 7) {
                if((framespast % 125) ==0 || ![initialBoss objectForKey:@1.7]) {
                    [initialBoss setObject:@TRUE forKey:@1.7];
                    [self shootBullet:2 angle:180];
                    [self shootBullet:2 angle:240];
                    [self shootBullet:2 angle:260];
                    [self shootBullet:2 angle:280];
                    [self shootBullet:2 angle:300];
                    [self shootBullet:2 angle:360];
                }
            }
        }
        if(level == 2) {
            if(gameSegment ==0) {
                if((framespast % 100) == 0 || ![initialBoss objectForKey:@2.0]) {
                    [initialBoss setObject:@TRUE forKey:@2.0];
                    int tempInt = (arc4random() % 90) + 240;
                    [self shootBullet:3 angle:tempInt];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 70) == 0 || ![initialBoss objectForKey:@2.1]) {
                    if (shootThePowerup == FALSE) {
                        [self shootSlowDownMissile];
                        shootThePowerup = TRUE; }
                    [initialBoss setObject:@TRUE forKey:@2.1];
                    [self shootBulletwithPos:2 angle:270 xpos:0 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:240 xpos:-50 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:300 xpos:50 ypos:screenCenter.y *0.5];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 70) == 0 || ![initialBoss objectForKey:@2.2]) {
                    [initialBoss setObject:@TRUE forKey:@2.2];
                    [self shootBulletwithPos:2 angle:270 xpos:0 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:240 xpos:100 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:300 xpos:-100 ypos:screenCenter.y *0.5];
                }
            }
            if(gameSegment ==3) {
                if((framespast % 150) == 0 || ![initialBoss objectForKey:@2.3]) {
                    [initialBoss setObject:@TRUE forKey:@2.3];
                    [self makeDownvote:-100];
                    [self makeDownvote:0];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 70) == 0 || ![initialBoss objectForKey:@2.4]) {
                    [initialBoss setObject:@TRUE forKey:@2.4];
                    [self shootBulletwithPos:2 angle:270 xpos:100 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:271 xpos:-100 ypos:screenCenter.y *0.5];
                    for(NSUInteger i = 0; i < [bullets count];i++) {
                        if([[bullets objectAtIndex:i] getAngle] > 270) {
                            [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] + 15];
                        }
                        else {
                            [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                        }
                    }
                }
            }
            if(gameSegment ==5) {
                if((framespast % 70) == 0 || ![initialBoss objectForKey:@2.5]) {
                    [initialBoss setObject:@TRUE forKey:@2.5];
                    [self shootBulletwithPos:2 angle:300 xpos:-100 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:240 xpos:100 ypos:screenCenter.y *0.5];
                }
                if((framespast % 180) == 0) {
                    [self makeDownvote:-65];
                }
            }
        }
        if(level == 3) {
            if(gameSegment ==0) {
                if((framespast % 450) == 0) {
                    [self makeFace];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 70) == 0 || ![initialBoss objectForKey:@3.1]) {
                    [initialBoss setObject:@TRUE forKey:@3.1];
                    [self shootBulletwithPosSmiley:3 angle:270 xpos:0 ypos:0];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 400) == 0 || ![initialBoss objectForKey:@3.2]) {
                    if (shootThePowerup == TRUE) {
                        [self shootMiniMeMissile];
                        shootThePowerup = FALSE; }
                    [initialBoss setObject:@TRUE forKey:@3.2];
                    [self laughoutloud];
                }
            }
            if(gameSegment ==3) {
                if((framespast % 100) == 0 || ![initialBoss objectForKey:@3.3]) {
                    [initialBoss setObject:@TRUE forKey:@3.3];
                    [self shootBulletwithPos:4 angle:275 xpos:0 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:4 angle:250 xpos:0 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:4 angle:300 xpos:0 ypos:screenCenter.y *0.5];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@3.4]) {
                    [initialBoss setObject:@TRUE forKey:@3.4];
                    [self shootBulletwithPosMult:4 angle:40 xpos:1/10 ypos:1/10];
                }
            }
            if(gameSegment ==5) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@3.5]) {
                    [initialBoss setObject:@TRUE forKey:@3.5];
                    [self shootBulletwithPosMult:4 angle:120 xpos:1.5 ypos:1/10];
                }
            }
            if(gameSegment ==6) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@3.6]) {
                    [initialBoss setObject:@TRUE forKey:@3.6];
                    [self shootBulletwithPosMult:4 angle:90 xpos:1 ypos:1/10];
                }
            }
        }
        if(level == 4) {
            if(gameSegment ==0) {
                if((framespast % 150) == 0 || ![initialBoss objectForKey:@4.0]) {
                    [initialBoss setObject:@TRUE forKey:@4.0];
                    [self shootBulletwithPosMult:4 angle:20 xpos:1/10 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:40 xpos:1/10 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:60 xpos:1/10 ypos:1/10];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 150) == 0 || ![initialBoss objectForKey:@4.1]) {
                    [initialBoss setObject:@TRUE forKey:@4.1];
                    [self shootBulletwithPosMult:4 angle:100 xpos:1.5 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:120 xpos:1.5 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:140 xpos:1.5 ypos:1/10];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 130) == 0 || ![initialBoss objectForKey:@4.2]) {
                    [initialBoss setObject:@TRUE forKey:@4.2];
                    [self shootBulletwithPosMult:5 angle:40 xpos:1/10 ypos:1/10];
                    [self shootBulletwithPosMult:5 angle:120 xpos:1.5 ypos:1/10];
                }
            }
            if(gameSegment ==3) {
                if (shootThePowerup == FALSE) {
                    [self shootMiniMeMissile];
                    shootThePowerup = TRUE; }
                if((framespast % 80) == 0 || ![initialBoss objectForKey:@4.3]) {
                    [initialBoss setObject:@TRUE forKey:@4.3];
                    [self shootBulletwithPos:5 angle:0 xpos:-180 ypos:-80];
                }
                if ((framespast % 100) == 0) {
                    [self shootBulletwithPos:5 angle:0 xpos:-180 ypos:-160];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 55) == 0 || ![initialBoss objectForKey:@4.4]) {
                    [initialBoss setObject:@TRUE forKey:@4.4];
                    [self shootBulletwithPos:5 angle:90 xpos:-120 ypos:-180];
                    [self shootBulletwithPos:5 angle:90 xpos:0 ypos:-180];
                    [self shootBulletwithPos:5 angle:90 xpos:120 ypos:-180];
                }
            }
            if(gameSegment ==5) {
                if((framespast % 15) ==0 || ![initialBoss objectForKey:@4.5]) {
                    [initialBoss setObject:@TRUE forKey:@4.5];
                    [self shootBulletwithPos:4 angle:180 xpos:-40 ypos:0];
                    [self shootBulletwithPos:4 angle:180 xpos:40 ypos:0];
//                    [self shootBulletwithPos:4 angle:180 xpos:0 ypos:-25];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 40;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==6) {
                if((framespast % 15) ==0 || ![initialBoss objectForKey:@4.6]) {
                    [initialBoss setObject:@TRUE forKey:@4.6];
                    [self shootBulletwithPos:3 angle:180 xpos:-80 ypos:-140];
                    [self shootBulletwithPos:3 angle:180 xpos:80 ypos:-140];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 25;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==7) {
                if((framespast % 15) ==0 || ![initialBoss objectForKey:@4.7]) {
                    [initialBoss setObject:@TRUE forKey:@4.7];
                    [self shootBulletwithPos:3 angle:0 xpos:-160 ypos:-140];
                    [self shootBulletwithPos:3 angle:180 xpos:160 ypos:-140];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 20;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==8) {
                if((framespast % 40) ==0 || ![initialBoss objectForKey:@4.8]){
                    [initialBoss setObject:@TRUE forKey:@4.8];
                    [self shootBulletwithPos:3 angle:90 xpos:0 ypos:-150];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    for(NSUInteger i = 0; i < [bullets count]; i++){
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 20;
                        
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
        }
        if(level == 5) {
            if(gameSegment ==0) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@5.0]) {
                    [initialBoss setObject:@TRUE forKey:@5.0];
                    [self shootBulletwithPos:3 angle:180 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:90 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:360 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:45 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:135 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:225 xpos:0 ypos:-240];
                    [self shootBulletwithPos:3 angle:315 xpos:0 ypos:-240];
                }
            }
            if(gameSegment ==1) {
                if (shootThePowerup == TRUE) {
                    [self shootSlowDownMissile];
                    shootThePowerup = FALSE; }
                if((framespast % 25) == 0 || ![initialBoss objectForKey:@5.1]) {
                    [initialBoss setObject:@TRUE forKey:@5.1];
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                }
                if((framespast % 50) == 0) {
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                    }
                }
            }
            if(gameSegment ==2) {
                if((framespast % 25) == 0 || ![initialBoss objectForKey:@5.2]) {
                    [initialBoss setObject:@TRUE forKey:@5.2];
                    [self shootBulletwithPos:4 angle:90 xpos:100 ypos:-300];
                    [self shootBulletwithPos:4 angle:90 xpos:-100 ypos:-300];
                    if ((framespast % 30) == 0) {
                        for(NSUInteger i = 0; i < [bullets count]; i++) {
                            [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] + 90];
                        }
                    }
                }
            }
            if(gameSegment ==3) {
                if((framespast % 25) == 0 || ![initialBoss objectForKey:@5.3]) {
                    [initialBoss setObject:@TRUE forKey:@5.3];
                    [self shootBulletwithPos:4 angle:90 xpos:100 ypos:-300];
                    [self shootBulletwithPos:4 angle:90 xpos:-100 ypos:-300];
                    if ((framespast % 30) == 0) {
                        for(NSUInteger i = 0; i < [bullets count]; i++) {
                            [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] + 270];
                        }
                    }
                }
            }
            if(gameSegment ==4) {
                if((framespast % 10) == 0 || ![initialBoss objectForKey:@5.4]) {
                    [initialBoss setObject:@TRUE forKey:@5.4];
                    [self shootBulletwithPos:5 angle:90 xpos:100 ypos:-300];
                    [self shootBulletwithPos:5 angle:90 xpos:-100 ypos:-300];
                    if ((framespast % 35) == 0) {
                        for(NSUInteger i = 0; i < [bullets count]; i++) {
                            [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] + 40];
                        }
                    }
                }
            }
            if(gameSegment ==5) {
                if((framespast % 10) == 0 || ![initialBoss objectForKey:@5.5]) {
                    [initialBoss setObject:@TRUE forKey:@5.5];
                    [self shootBulletwithPos:5 angle:90 xpos:100 ypos:-300];
                    [self shootBulletwithPos:5 angle:90 xpos:-100 ypos:-300];
                    if ((framespast % 35) == 0) {
                        for(NSUInteger i = 0; i < [bullets count]; i++) {
                            [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 40];
                        }
                    }
                }
            }
        }
        if(level == 6) {
            if(gameSegment ==0) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@6.0]) {
                    [initialBoss setObject:@TRUE forKey:@6.0];
                    [self shootBullet:5 angle:270];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + (arc4random() % 90)-45;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==1) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@6.1]) {
                    if (shootThePowerup == FALSE) {
                        [self shootSlowDownMissile];
                        shootThePowerup = TRUE; }
                    [initialBoss setObject:@TRUE forKey:@6.1];
                    [self shootBulletwithPos:2 angle:180 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:90 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:270 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:360 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:45 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:135 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:225 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:315 xpos:0 ypos:-240];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@6.2]) {
                    [initialBoss setObject:@TRUE forKey:@6.2];
                    [self shootBulletwithPos:2 angle:360 xpos:-150 ypos:-40];
                    [self shootBulletwithPos:2 angle:360 xpos:-150 ypos:-160];
                    [self shootBulletwithPos:2 angle:360 xpos:-150 ypos:-280];
                }
            }
            if(gameSegment ==3) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@6.3]) {
                    [initialBoss setObject:@TRUE forKey:@6.3];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:3 angle:240 xpos:100 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:3 angle:300 xpos:-100 ypos:screenCenter.y *0.5];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@6.4]) {
                    [initialBoss setObject:@TRUE forKey:@6.4];
                    [self shootBulletwithPos:2 angle:300 xpos:-100 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:2 angle:240 xpos:100 ypos:screenCenter.y *0.5];
                    
                }
            }
            if(gameSegment ==5) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@6.5]) {
                    [initialBoss setObject:@TRUE forKey:@6.5];
                    [self shootBulletwithPos:4 angle:90 xpos:100 ypos:-300];
                    [self shootBulletwithPos:4 angle:90 xpos:-100 ypos:-300];
                }
            }
        }
        if(level == 7) {
            if(gameSegment ==0) {
                if((framespast % 90) == 0 || ![initialBoss objectForKey:@7.0]) {
                    [initialBoss setObject:@TRUE forKey:@7.0];
                    [self shootBullet:1 angle:230];
                    [self shootBullet:2 angle:270];
                    [self shootBullet:1 angle:310];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@7.1]) {
                    [initialBoss setObject:@TRUE forKey:@7.1];
                    if (shootThePowerup == TRUE) {
                        [self shootMiniMeMissile];
                        shootThePowerup = FALSE; }
                    [self shootBullet:3 angle:300];
                    [self shootBullet:3 angle:240];
                }
                for(NSUInteger i = 0; i < [bullets count]; i++) {
                    NSInteger j = i;
                    projectile = [bullets objectAtIndex:j];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 20) == 0 || ![initialBoss objectForKey:@7.2]) {
                    [initialBoss setObject:@TRUE forKey:@7.2];
                    [self shootBullet:3 angle:180];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 30;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==3) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@7.3]) {
                    [initialBoss setObject:@TRUE forKey:@7.3];
                    [self shootBullet:1 angle:270];
                    [self shootBullet:1 angle:270];
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + (arc4random() % 90)-45;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }

                }
            }
            if(gameSegment ==4) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@7.4]) {
                    [initialBoss setObject:@TRUE forKey:@7.4];
                    int tempInt = (arc4random() % 90) + 240;
                    [self shootBullet:3 angle:tempInt];
                    [self shootBullet:3 angle:tempInt];
                    [self shootBullet:3 angle:tempInt];
                    [self shootBullet:3 angle:tempInt];
                }
            }
        }
        if(level == 8) {
            if(gameSegment ==0) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@8.0]) {
                    [initialBoss setObject:@TRUE forKey:@8.0];
                    [self shootBulletwithPos:4 angle:260 xpos:50 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:4 angle:240 xpos:50 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:4 angle:220 xpos:50 ypos:screenCenter.y *0.5];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@8.1]) {
                    [initialBoss setObject:@TRUE forKey:@8.1];
                    [self shootBulletwithPos:4 angle:300 xpos:-50 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:4 angle:320 xpos:-50 ypos:screenCenter.y *0.5];
                    [self shootBulletwithPos:4 angle:280 xpos:-50 ypos:screenCenter.y *0.5];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@8.2]) {
                    [initialBoss setObject:@TRUE forKey:@8.2];
                    [self shootBulletwithPosMult:4 angle:20 xpos:1/10 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:40 xpos:1/10 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:60 xpos:1/10 ypos:1/10];
                }
            }
            if(gameSegment ==3) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@8.3]) {
                    if (shootThePowerup == FALSE) {
                        [self shootMiniMeMissile];
                        shootThePowerup = TRUE; }
                    [initialBoss setObject:@TRUE forKey:@8.3];
                    [self shootBulletwithPosMult:4 angle:100 xpos:1.5 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:120 xpos:1.5 ypos:1/10];
                    [self shootBulletwithPosMult:4 angle:140 xpos:1.5 ypos:1/10];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 60) == 0 || ![initialBoss objectForKey:@8.4]) {
                    [initialBoss setObject:@TRUE forKey:@8.4];
                    [self shootBulletwithPos:5 angle:90 xpos:-120 ypos:-180];
                    [self shootBulletwithPos:5 angle:90 xpos:0 ypos:-180];
                    [self shootBulletwithPos:5 angle:90 xpos:120 ypos:-180];
                }
            }
        }
        if(level == 9) {
            if(gameSegment ==0) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@9.0]) {
                    [initialBoss setObject:@TRUE forKey:@9.0];
                    [self shootBulletwithPos:2 angle:180 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:90 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:270 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:360 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:45 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:135 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:225 xpos:0 ypos:-240];
                    [self shootBulletwithPos:2 angle:315 xpos:0 ypos:-240];

                }
            }
            if(gameSegment ==1) {
                if((framespast % 50) == 0 || ![initialBoss objectForKey:@9.1]) {
                    [initialBoss setObject:@TRUE forKey:@9.1];
//                    int tempInt = (arc4random() % 300) -245;
                    [self shootBulletwithPosFire:2 angle:270 xpos:0 ypos:30];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 25) == 0 || ![initialBoss objectForKey:@9.2]) {
                    [initialBoss setObject:@TRUE forKey:@9.2];
                    if (shootThePowerup == TRUE) {
                        [self shootSlowDownMissile];
                        shootThePowerup = FALSE; }
                    [self shootBulletwithPos:3 angle:300 xpos:-100 ypos:0];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPos:3 angle:240 xpos:100 ypos:0];
                }
            }
            if(gameSegment ==3) {
                if((framespast % 25) == 0 || ![initialBoss objectForKey:@9.3]) {
                    [initialBoss setObject:@TRUE forKey:@9.3];
                    [self shootBulletwithPos:5 angle:(arc4random() % 360) xpos:0 ypos:-240];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 30) == 0 || ![initialBoss objectForKey:@9.4]) {
                    [initialBoss setObject:@TRUE forKey:@9.4];
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                }
                if((framespast % 55) == 0){
                    for(NSUInteger i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                    }
                }
            }
        }
    }
    [self moveBullet];
    [self moveFakeBullet];
}
-(void) laughoutloud {
    // L
    [self shootBulletwithPosSmall:1 angle:270 xpos:-140 ypos:100];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-140 ypos:80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-140 ypos:60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-140 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:40];
    // O
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:100];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:100];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:100];
    // L
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:100];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:120 ypos:40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:140 ypos:40];
}
-(void) makeDownvote:(float) xOffset {
    [self shootBulletwithPos:1 angle:270 xpos:30+xOffset ypos:-10];
    [self shootBulletwithPos:1 angle:270 xpos:110+xOffset ypos:-10];
    [self shootBulletwithPos:1 angle:270 xpos:40+xOffset ypos:-20];
    [self shootBulletwithPos:1 angle:270 xpos:70+xOffset ypos:-20];
    [self shootBulletwithPos:1 angle:270 xpos:100+xOffset ypos:-20];
    [self shootBulletwithPos:1 angle:270 xpos:50+xOffset ypos:-30];
    [self shootBulletwithPos:1 angle:270 xpos:90+xOffset ypos:-30];
    [self shootBulletwithPos:1 angle:270 xpos:60+xOffset ypos:-40];
    [self shootBulletwithPos:1 angle:270 xpos:80+xOffset ypos:-40];
    [self shootBulletwithPos:1 angle:270 xpos:70+xOffset ypos:-50];
}
-(void) makeDownvoteSpeed:(float) xOffset speed:(float) speedInput {
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:0];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:0];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:0];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:10];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:10];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:10];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:20];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:20];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:20];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:30];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:30];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:30];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:40];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:40];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:40];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:50];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:50];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:50];
    [self shootBulletwithPos:speedInput angle:270 xpos:30+xOffset ypos:-10];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:-10];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:-10];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:-10];
    [self shootBulletwithPos:speedInput angle:270 xpos:110+xOffset ypos:-10];
    [self shootBulletwithPos:speedInput angle:270 xpos:40+xOffset ypos:-20];
    [self shootBulletwithPos:speedInput angle:270 xpos:60+xOffset ypos:-20];
    [self shootBulletwithPos:speedInput angle:270 xpos:80+xOffset ypos:-20];
    [self shootBulletwithPos:speedInput angle:270 xpos:100+xOffset ypos:-20];
    [self shootBulletwithPos:speedInput angle:270 xpos:50+xOffset ypos:-30];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:-30];
    [self shootBulletwithPos:speedInput angle:270 xpos:90+xOffset ypos:-30];
    [self shootBulletwithPos:speedInput angle:270 xpos:60+xOffset ypos:-40];
    [self shootBulletwithPos:speedInput angle:270 xpos:80+xOffset ypos:-40];
    [self shootBulletwithPos:speedInput angle:270 xpos:70+xOffset ypos:-50];
}
- (void) makeFace {
    // Left Eye
    [self shootBulletwithPosSmall:1 angle:270 xpos:-70 ypos:-100];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-70 ypos:-90];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-70 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-70 ypos:-70];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-70 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-70 ypos:-50];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-80 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-90 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-110 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-130 ypos:-50];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-130 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-130 ypos:-70];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-130 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-130 ypos:-90];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-130 ypos:-100];
    // Right Eye
    [self shootBulletwithPosSmall:1 angle:270 xpos:130 ypos:-100];
    [self shootBulletwithPosSmall:1 angle:270 xpos:130 ypos:-90];
    [self shootBulletwithPosSmall:1 angle:270 xpos:130 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:130 ypos:-70];
    [self shootBulletwithPosSmall:1 angle:270 xpos:130 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:130 ypos:-50];
    [self shootBulletwithPosSmall:1 angle:270 xpos:120 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:110 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:90 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:70 ypos:-50];
    [self shootBulletwithPosSmall:1 angle:270 xpos:70 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:70 ypos:-70];
    [self shootBulletwithPosSmall:1 angle:270 xpos:70 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:70 ypos:-90];
    [self shootBulletwithPosSmall:1 angle:270 xpos:70 ypos:-100];
    // Nose
    [self shootBulletwithPosSmall:1 angle:270 xpos:4 ypos:-236];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-4 ypos:-244];
    // Smile
    [self shootBulletwithPosSmall:1 angle:270 xpos:50 ypos:-328];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-332];
    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-336];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:-340];
    [self shootBulletwithPosSmall:1 angle:270 xpos:10 ypos:-340];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-340];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-10 ypos:-340];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-340];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-336];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-40 ypos:-332];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-50 ypos:-328];
}
-(void) shootSlowDownMissile {
    [self shootBulletwithPosSlowDown:1 angle:270];
}
-(void) shootMiniMeMissile {
    [self shootBulletwithPosSmallerBall:1 angle:270];
}
-(void) dropEffect:(CCSprite *) spriteToHaveTheEffectOn {
      id dropdown = [CCMoveTo actionWithDuration:1.5f position:ccp(screenCenter.x, screenCenter.y*1.8)];
      id staythere = [CCDelayTime actionWithDuration:3.0f];
      id gobackup = [CCMoveTo actionWithDuration:4.5f position:ccp(screenCenter.x, screenCenter.y * 11)];
      [spriteToHaveTheEffectOn runAction:[CCSequence actions:dropdown, staythere, gobackup, nil]];
}
-(void) initBoss {
    if(bosstime == true) {
        label.color = ccc3(0, 0, 0);
        streak = [CCMotionStreak streakWithFade:0.5 minSeg:1 width:50 color:ccc3(247,148,29) textureFilename:@"orange.png"];
        [self addChild:streak];
//        [self rflash:0 green:0 blue:0 alpha:255 actionWithDuration:0];
        // This is for the level changing mechanism for the level screen
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"boss"] < level) {
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"boss"];
        }
        if(level == 1) {
            [self addChild:level1bg];
            [self removeChild:streak cleanup:YES];
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialcompleted"] == FALSE){
                gameSegment = 0;
            } else if([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialcompleted"] == TRUE) {
                gameSegment = 1;
                LevelTag = [CCSprite spriteWithFile:@"LevelTag1.png"];
                LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
                [self addChild:LevelTag z:10000];
                [self dropEffect:LevelTag];
            }
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target1.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
            [boss runAction:bossscale];
        }
        else if(level == 2) {
            [self removeChild:level1bg];
            [self addChild:level2bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag2.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target2.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
            [boss runAction:bossscale];
        }
        else if(level == 3) {
            [self removeChild:level2bg];
            [self addChild:level3bg];
            [self removeChild:streak cleanup:YES];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag3.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target3.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
            [boss runAction:bossscale];
        }
        else if(level == 4) {
            [self removeChild:level3bg];
            [self addChild:level4bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag4.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target4.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
            [boss runAction:bossscale];
        }
        else if(level == 5) {
            [self removeChild:level4bg];
            [self addChild:level5bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag5.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target5.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
            [boss runAction:bossscale];
        }
        else if(level == 6) {
            [self removeChild:level5bg];
            [self addChild:level6bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag6.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target6.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
            [boss runAction:bossscale];
        }
        else if(level == 7) {
            [self removeChild:level6bg];
            [self addChild:level7bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag7.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target7.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
            [boss runAction:bossscale];
        }
        else if(level == 8) {
            [self removeChild:level7bg];
            [self addChild:level8bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag8.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target8.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
            [boss runAction:bossscale];
        }
        else if(level == 9) {
            [self removeChild:level8bg];
            [self addChild:level9bg];
            LevelTag = [CCSprite spriteWithFile:@"LevelTag9.png"];
            LevelTag.position = ccp(screenCenter.x,screenCenter.y * 3);
            [self addChild:LevelTag z:10000];
            [self dropEffect:LevelTag];
            int x = screenCenter.x;
            int y = screenCenter.y * 1.6;
            boss = [CCSprite spriteWithFile:@"target9.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
            [boss runAction:bossscale];
        }
    }
    else if(bosstime == false) {
        int x = screenCenter.x;
        int y = screenCenter.y * 1.6;
        boss = [CCSprite spriteWithFile:@"target9.png"];
        boss.position = ccp(x,y);
        boss.scale = 0;
        [self addChild:boss z:0];
        id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
        [boss runAction:bossscale];
        [self shootBullet:1 angle:90];
    }
}
-(void) movePlayerPos: (CGPoint) rot_pos1 rot_pos2:(CGPoint) rot_pos2 {
    float rotation_theta = atan((rot_pos1.y-rot_pos2.y)/(rot_pos1.x-rot_pos2.x)) * 180 / M_PI;
    if(rot_pos1.y - rot_pos2.y > 0) {
        if(rot_pos1.x - rot_pos2.x < 0) {
            touchangle = (-90-rotation_theta);
        }
        else if(rot_pos1.x - rot_pos2.x > 0) {
            touchangle = (90-rotation_theta);
        }
    }
    else if(rot_pos1.y - rot_pos2.y < 0) {
        if(rot_pos1.x - rot_pos2.x < 0) {
            touchangle = (270-rotation_theta);
        }
        else if(rot_pos1.x - rot_pos2.x > 0) {
            touchangle = (90-rotation_theta);
        }
    }
    if (touchangle < 0) {
        touchangle+=360;
    }
    float speed = 10; // Move 50 pixels in 60 frames (1 second)
    float vx = cos(touchangle * M_PI / 180) * speed;
    float vy = sin(touchangle * M_PI / 180) * speed;
    CGPoint direction = ccp(vy,vx);
    if(deathanimation == true) {
        player.position = ccpAdd(player.position, direction);
        shield.position = player.position;
    }
}
-(void) grabTouchCoord {
    // Methods that should run every frame here!
    KKInput *input = [KKInput sharedInput];
    //This will be true as long as there is at least one finger touching the screen
    if(input.touchesAvailable) {
        playerpos = player.position;
        posTouchScreen = [input locationOfAnyTouchInPhase:KKTouchPhaseAny];
        CGPoint rot_pos2 = [player position];
        CGPoint rot_pos1 = posTouchScreen;
        CGPoint newpos = posTouchScreen;
        CGPoint oldpos = [player position];
        if(newpos.x - oldpos.x > 5 || newpos.x - oldpos.x < -5 || newpos.y - oldpos.y > 5 || newpos.y - oldpos.y < -5) {
            [self movePlayerPos:rot_pos1 rot_pos2:rot_pos2];
        }
    }
}
-(void) deleteubershield {
    [self unschedule:@selector(deleteubershield)];
    ubershieldon = false;
    [self removeChild:shield cleanup:YES];
}
-(void) moveBullet {
    //move the bullets
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        NSInteger j = i;
        projectile = [bullets objectAtIndex:j];
        float angle = [[bullets objectAtIndex:j] getAngle];
        float speed = [[bullets objectAtIndex:j] getSpeed]; // Move 50 pixels in 60 frames (1 second)
        // For the slow-down powerup
        for(NSUInteger k = 0; k < [slowDowners count]; k++) {
            CCSprite* tempSprite = [slowDowners objectAtIndex:k];
            if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
                [self removeChild:tempSprite cleanup:YES];
                isItSlow = TRUE;
                if (tut.parent == nil) {
                    tut = [CCLabelTTF labelWithString:@"Slow Motion!" fontName:@"Arial" fontSize:30];
                    tut.position = screenCenter;
                    tut.color = ccc3(0, 0, 0);
                    [self addChild:tut z:10000];
                    dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
                    dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                        [self removeChild:tut cleanup:YES];
                    });
                }
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    isItSlow = FALSE;
                });
            }
        }
        if (isItSlow == TRUE) {
            speed = speed - 0.7;
        }
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(NSUInteger i = 0; i < [fireBalls count]; i++) {
        NSInteger j = i;
        projectile = [fireBalls objectAtIndex:j];
        float angle = 270;
        float speed = 3;
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(NSUInteger i = 0; i < [smileyFaces count]; i++) {
        NSInteger j = i;
        projectile = [smileyFaces objectAtIndex:j];
        float angle = 270;
        float speed = 3;
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(NSUInteger i = 0; i < [smallerBallers count]; i++) {
        NSInteger j = i;
        projectile = [smallerBallers objectAtIndex:j];
        float angle = 270;
        float speed = 3;
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(NSUInteger i = 0; i < [slowDowners count]; i++) {
        NSInteger j = i;
        projectile = [slowDowners objectAtIndex:j];
        float angle = 270;
        float speed = 3;
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(NSUInteger i = 0; i < [powerups count]; i++) {
        NSInteger j = i;
        projectile = [powerups objectAtIndex:j];
        float angle = [[powerups objectAtIndex:j] getAngle];
        float speed = [[powerups objectAtIndex:j] getSpeed]; // Move 50 pixels in 60 frames (1 second)
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
        projectile.position = ccp(projectile.position.x,projectile.position.y - 1);
    }
}
- (void)mySelector {
    [self unschedule:@selector(mySelector)];
    //create one
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"endless"] == false) {
        [[CCDirector sharedDirector] pushScene:
         [CCTransitionCrossFade transitionWithDuration:0.5f scene:[LevelSelect node]]];
    }
    stagespast = stagespast + 1;
    [self initBoss];
    gameSegment = 0;
    framespast = 0;
    NSLog(@"Boss defeated.");
}
-(void) moveFakeBullet
{
    for(NSUInteger i = 0; i < [fakebullets count]; i++) {
        NSInteger j = i;
        projectile2 = [fakebullets objectAtIndex:j];
        CGPoint rot_pos2 = [projectile2 position];
        CGPoint rot_pos1 = [player position];
        float rotation_theta = atan((rot_pos1.y-rot_pos2.y)/(rot_pos1.x-rot_pos2.x)) * 180 / M_PI;
        if(rot_pos1.y - rot_pos2.y > 0) {
            if(rot_pos1.x - rot_pos2.x < 0) {
                fakebulletangle = (-90-rotation_theta);
            }
            else if(rot_pos1.x - rot_pos2.x > 0) {
                fakebulletangle = (90-rotation_theta);
            }
        }
        else if(rot_pos1.y - rot_pos2.y < 0) {
            if(rot_pos1.x - rot_pos2.x < 0) {
                fakebulletangle = (270-rotation_theta);
            }
            else if(rot_pos1.x - rot_pos2.x > 0) {
                fakebulletangle = (90-rotation_theta);
            }
        }
        if (fakebulletangle < 0) {
            fakebulletangle+=360;
        }
        float speed = 10; // Move 50 pixels in 60 frames (1 second)
        float vx = cos(fakebulletangle * M_PI / 180) * speed;
        float vy = sin(fakebulletangle * M_PI / 180) * speed;
        CGPoint direction = ccp(vy,vx);
        projectile2.position = ccpAdd(projectile2.position, direction);
    }
}
/* -------------------------------------------------------------------------------- */
/*    DIFFERENT BULLETS BEING SHOT                                                  */
/* -------------------------------------------------------------------------------- */

-(void) shootBullet: (float) speed angle:(float) angleInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = boss.position;
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
}
-(void) shootBulletwithPos: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    int x = screenCenter.x;
    int y = screenCenter.y*1.3;
    newB.position = ccp(x, y);
    //    newB.position = ccp(arc4random()%346 + 75,arc4random()%406 + 75);
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
}
-(void) shootBulletwithPosMult: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    int x = screenCenter.x;
    int y = screenCenter.y*1.3;
    newB.position = ccp(x, y);
    //    newB.position = ccp(arc4random()%346 + 75,arc4random()%406 + 75);
    newB.position = ccp(newB.position.x * xInput, newB.position.y * yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
}
-(void) shootBulletwithPosNoArray: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
//    newB.position = boss.position;
    newB.position = ccp(arc4random()%346 + 75,arc4random()%406 + 75);
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [flowerbullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
}
-(void) shootBulletwithPosCustom: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
//    newB.position = ccp(arc4random()%)
    newB.position = ccp(xInput, yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.05f];
    [newB runAction:scale];
}
-(void) shootBulletwithPosShield: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    if(shieldon == false) {
        Powerup *newB = [Powerup powerup:speed :angleInput];
        newB.position = ccp(boss.position.x + xInput, boss.position.y + yInput);
        [self addChild:newB z:9];
        [powerups addObject:newB];
        newB.tag = 42;
        newB.scale = 0.2f;
//        [self removeChild:newB cleanup:YES];
        [self removeChild:shield cleanup:YES];
    }
}
-(void) shootBulletwithPosSmallerBall: (float) speed angle:(float) angleInput {
    SmallerBall *newB = [SmallerBall smallBall:speed :angleInput];
    newB.position = boss.position;
//    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [smallerBallers addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
    smallerBall = [CCSprite spriteWithFile:@"cyan.png"];
    smallerBall.position = newB.position;
    smallerBall.scale = 0;
    [self addChild:smallerBall z:10];
    id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [smallerBall runAction:bossscale];
    [smallerBallers addObject:smallerBall];
}
-(void) shootBulletwithPosSlowDown: (float) speed angle:(float) angleInput {
    SlowDown *newB = [SlowDown slowedDown:speed :angleInput];
    newB.position = boss.position;
//    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [slowDowners addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
    slowDown = [CCSprite spriteWithFile:@"cyan.png"];
    slowDown.position = newB.position;
    slowDown.scale = 0;
    [self addChild:slowDown z:10];
    id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [slowDown runAction:bossscale];
    [slowDowners addObject:slowDown];
}
-(void) shootBulletwithPosFire: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = ccp(boss.position.x, boss.position.y + 30);
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
    [newB runAction:scale];
    fireball = [CCSprite spriteWithFile:@"fire.png"];
    fireball.position = newB.position;
    fireball.scale = 0;
    [self addChild:fireball z:-20];
    id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.7f];
    [fireball runAction:bossscale];
    [fireBalls addObject:fireBalls];
}
-(void) shootBulletwithPosSmiley: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = ccp(boss.position.x, boss.position.y + 30);
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
    smileyface = [CCSprite spriteWithFile:@"smileyface.png"];
    smileyface.position = newB.position;
    smileyface.scale = 0;
    [self addChild:smileyface z:10];
    id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.4f];
    [smileyface runAction:bossscale];
    [smileyFaces addObject:smileyface];
}
-(void) shootBulletwithPosSmall: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = boss.position;
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput +200);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.05f];
    [newB runAction:scale];
}
-(void) returnBullet {
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        NSInteger j = i;
        projectile = [bullets objectAtIndex:j];
        fakebullet = [CCSprite spriteWithFile:@"orange.png"];
        fakebullet.position = projectile.position;
        [self addChild:fakebullet];
        [fakebullets addObject:fakebullet];
        fakebullet.scale = 0.1;
        [[SimpleAudioEngine sharedEngine] playEffect:@"bwooo.mp3"];
        bwooo = false;
    }
    for(NSUInteger i = 0; i < [flowerbullets count]; i++) {
        NSInteger j = i;
        projectile = [flowerbullets objectAtIndex:j];
        fakebullet = [CCSprite spriteWithFile:@"orange.png"];
        fakebullet.position = projectile.position;
        [self addChild:fakebullet];
        [fakebullets addObject:fakebullet];
        fakebullet.scale = 0.1;
        [[SimpleAudioEngine sharedEngine] playEffect:@"bwooo.mp3"];
        bwooo = false;
    }
    [self flash:247 green:148 blue:29 alpha:255 actionWithDuration:0];
}

/* -------------------------------------------------------------------------------- */
/*    END OF GAME                                                                   */
/* -------------------------------------------------------------------------------- */

-(void) gameEnd {
    [self deathplusdeath];
}
-(void) warpTime {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
//    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"techno.mp3" loop:YES];
    [[SimpleAudioEngine sharedEngine] playEffect:@"timewwarp.mp3"];
    [self removeChild:tut];
    isTimeWarped = true;
    framespast = 0;
    stagespast = 4;
    [self flash:255 green:255 blue:255 alpha:255 actionWithDuration:0.5];
//    bosstime = false;
    thetemporalint = 180;
    omganothertemportalint = 180;
}
-(void) deleteBullets {
    [self returnBullet];
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        Bullet *temp = [bullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
    }
    for(NSUInteger i = 0; i < [fireBalls count]; i++) {
        CCSprite *temp = [fireBalls objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
    }
    for(NSUInteger i = 0; i < [flowerbullets count]; i++) {
        CCSprite *temp = [flowerbullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
    }
    for(NSUInteger i = 0; i < [smileyFaces count]; i++) {
        CCSprite *temp = [smileyFaces objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
    }
    for(NSUInteger i = 0; i < [smallerBallers count]; i++) {
        CCSprite *temp = [smallerBallers objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [smallerBallers removeAllObjects];
    }
    [smileyFaces removeAllObjects];
    [smallerBallers removeAllObjects];
    [fireBalls removeAllObjects];
    [bullets removeAllObjects];
    [flowerbullets removeAllObjects];
}
-(void) deathplusdeath {
    //    [[NSUserDefaults standardUserDefaults] setInteger:(coins + 1) forKey:@"coins"];
    [self removeChild:streak cleanup:YES];
    [self flash:0 green:0 blue:255 alpha:255 actionWithDuration:0];
    [self rflash:255 green:255 blue:255 alpha:255 actionWithDuration:0];
    [self shootBulletwithPosShield:3 angle:260 xpos:0 ypos:0];
    label.color = ccc3(0, 0, 0);
    id bossscale = [CCScaleTo actionWithDuration:0.5f scale:2.0f];
    [boss runAction:bossscale];
    id bossturn = [CCRotateTo actionWithDuration:2.0 angle:200];
    [boss runAction:bossturn];
    id bossscale2 = [CCScaleTo actionWithDuration:2.0f scale:0.0f];
    [boss runAction:bossscale2];
    stagespast = stagespast + 1;
    //create first,delay,create second
    [self schedule:@selector(mySelector) interval:0.0];
    for(NSUInteger i = 0; i<[fireBalls count]; i++) {
        [self removeChild:[fireBalls objectAtIndex:i] cleanup:YES];
    }
    [fireBalls removeAllObjects];
    for(NSUInteger i = 0; i<[smileyFaces count]; i++) {
        [self removeChild:[smileyFaces objectAtIndex:i] cleanup:YES];
    }
    [smileyFaces removeAllObjects];
    for(NSUInteger i = 0; i<[smallerBallers count]; i++) {
        [self removeChild:[smallerBallers objectAtIndex:i] cleanup:YES];
    }
    [smallerBallers removeAllObjects];
}
/* -------------------------------------------------------------------------------- */
/*    COLLISIONS                                                                    */
/* -------------------------------------------------------------------------------- */
//obj2 is the player
-(BOOL) isCollidingSphere:(CCSprite *) obj1 WithSphere:(CCSprite *) obj2 {
    float obj1Radii = [obj1 boundingBox].size.width/2;
    float obj2Radii = [obj2 boundingBox].size.width/2;
    float minDistance = obj1Radii + obj2Radii; //12 + 30;
    float dx = obj2.position.x - obj1.position.x;
    float dy = obj2.position.y - obj1.position.y;
    float actualDistance = sqrtf((dx * dx) + (dy * dy));
    if (actualDistance <= minDistance) {
        return true;
    } else {
        return false;
    }
}

-(BOOL) isCollidingRect:(CCSprite *) spriteOne WithSphere:(CCSprite *) spriteTwo {
    float diff = ccpDistance(spriteOne.position, spriteTwo.position);
    float obj1Radii = [spriteOne boundingBox].size.width/2;
    float obj2Radii = [spriteTwo boundingBox].size.width/2;
    if (diff < obj1Radii + obj2Radii) {
        return TRUE;
    } else {
        return FALSE;
    }
}
// This is what moves the game on to the next level after you hit the target
-(void) targetHit {
    if (targetHit == true) {
        // This should happen when the bullet is deleted.
        if (level == 1) {
            gameSegment += 1;
            if (gameSegment >= 7) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 100) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 2) {
            gameSegment += 1;
            if (gameSegment >= 5) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 150) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 3) {
            gameSegment += 1;
            if (gameSegment >= 6) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 200) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 4) {
            gameSegment += 1;
            if (gameSegment >= 8) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 250) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 5) {
            gameSegment += 1;
            if (gameSegment >= 5) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 300) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 6) {
            gameSegment += 1;
            if (gameSegment >= 5) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 300) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 7) {
            gameSegment += 1;
            if (gameSegment >= 4) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 300) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
            for(NSUInteger i = 0; i < [bullets count]; i++) {
                Bullet *temp = [bullets objectAtIndex:i];
                [self removeChild:temp];
            }
        } else if (level == 8) {
            gameSegment += 1;
            if (gameSegment >= 4) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 300) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                level += 1;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
            for(NSUInteger i = 0; i < [bullets count]; i++) {
                Bullet *temp = [bullets objectAtIndex:i];
                [self removeChild:temp];
            }
        } else if (level == 9) {
            gameSegment += 1;
            if (gameSegment >= 4) {
                [[NSUserDefaults standardUserDefaults] setInteger:(coins + 300) forKey:@"coins"];
                [self schedule:@selector(gameSegmentBeat)];
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self resumeSchedulerAndActions];
                    [self unschedule:@selector(gameSegmentBeat)];
                });
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
            for(NSUInteger i = 0; i < [bullets count]; i++) {
                Bullet *temp = [bullets objectAtIndex:i];
                [self removeChild:temp];
            }
        }
        
        for(NSUInteger i = 0; i < [bullets count]; i++) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
        }
        [bullets removeAllObjects];
        player.position = ccp(screenCenter.x,screenCenter.y / 4);
    } else if (targetHit == false) {
    }
}
-(void) changePlayerPosition {
    player.position = ccp(screenCenter.x,screenCenter.y / 3);
}

-(void) detectCollisions
{
    if ([self isCollidingRect:player WithSphere:blocker] == true) {
        if(shieldon == true) {
            [self removeChild:shield cleanup:YES];
            [self deleteubershield];
            shieldon = false;
        }
        else if(ubershieldon == true) {
            [self removeChild:shield cleanup:YES];
            [self deleteubershield];
        }
        else {
            [self playerdeathstart];
//            [self schedule:@selector(playerdeath) interval:0.5];
        }
    }
    
    if (CGRectIntersectsRect(CGRectMake(player.position.x, player.position.y, playerWidth, playerHeight), CGRectMake(boss.position.x, boss.position.y, bossWidth, bossHeight)) == true) {
        targetHit = true;
        [self targetHit];
    }
    if (CGRectIntersectsRect(CGRectMake(player.position.x, player.position.y, playerWidth, playerHeight), CGRectMake(shield.position.x, shield.position.y, shield.boundingBox.size.width, shield.boundingBox.size.height)) == true) {
    }
    // For the Mini-Me powerup
    for(NSUInteger i = 0; i < [smallerBallers count]; i++) {
        NSInteger j = i;
        CCSprite* tempSprite = [smallerBallers objectAtIndex:j];
        if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
            [self removeChild:tempSprite cleanup:YES];
            if (tut.parent == nil) {
                tut = [CCLabelTTF labelWithString:@"You Shrunk!" fontName:@"Arial" fontSize:30];
                tut.position = screenCenter;
                [self addChild:tut z:10000];
                tut.color = ccc3(0, 0, 0);
                dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
                dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                    [self removeChild:tut cleanup:YES];
                });
            }
            player.scale = 0.05f;
            dispatch_time_t countdownTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
            dispatch_after(countdownTime, dispatch_get_main_queue(), ^(void){
                player.scale = 0.15f;
            });
        }
    }
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        NSInteger j = i;
        CCSprite* tempSprite = [bullets objectAtIndex:j];
        if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
            if(shieldon == true) {
                [self removeChild:tempSprite cleanup:YES];
                [bullets removeObjectAtIndex:i];
                [self removeChild:shield cleanup:YES];
                [self deleteubershield];
                shieldon = false;
            }
            else if(ubershieldon == true) {
                [self removeChild:shield cleanup:YES];
                [self deleteubershield];
                [self removeChild:tempSprite cleanup:YES];
                [bullets removeObjectAtIndex:i];
            }
            else {
                [self playerdeathstart];
            }
        }
    }
    for(NSUInteger i = 0; i < [flowerbullets count]; i++) {
        NSInteger j = i;
        CCSprite* tempSprite = [flowerbullets objectAtIndex:j];
        if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
            if(shieldon == true) {
                [self removeChild:tempSprite cleanup:YES];
                [flowerbullets removeObjectAtIndex:i];
                [self removeChild:shield cleanup:YES];
                shieldon = false;
            }
            if(ubershieldon == true) {
                [self removeChild:tempSprite cleanup:YES];
                [flowerbullets removeObjectAtIndex:i];
            }
            else{
                [self playerdeathstart];
            }
        }
    }
    for(NSUInteger i = 0; i < [fakebullets count]; i++) {
        NSInteger j = i;
        if([fakebullets count] > 0) {
            CCSprite* tempFakeSprite = [fakebullets objectAtIndex:j];
            if ([self isCollidingSphere:[fakebullets objectAtIndex:j] WithSphere:player] == true) {
                [self removeChild:tempFakeSprite cleanup:YES];
                [fakebullets removeObjectAtIndex:j];
                intScore = intScore + 100;
                NSString *str = [NSString stringWithFormat:@"%d",intScore];
                [label setString:str];
                [label draw];
            }
        }
    }
    for(NSUInteger i = 0; i < [powerups count];i++) {
        NSInteger j = i;
        CCSprite* tempSprite = [powerups objectAtIndex:j];
        if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
            [self removeChildByTag:42 cleanup:YES];
            [powerups removeObjectAtIndex:i];
            [self deleteBullets];
            shield = [CCSprite spriteWithFile:@"shield.png"];
            shield.scale = 0.15;
            shield.position = player.position;
            [self addChild:shield z:-10];
            shieldon = true;
            [self flash:0 green:255 blue:0 alpha:255 actionWithDuration:0];
        }
    }
}
/* -------------------------------------------------------------------------------- */
/*    USEFUL CODE TO MAKE MY LIFE EASIER                                            */
/* -------------------------------------------------------------------------------- */
-(void) flashLabel:(NSString *) stringToFlashOnScreen actionWithDuration:(float) numSecondsToFlash color:(NSString *) colorString
{
    if ([colorString isEqualToString:@"red"] == TRUE) {
        tut.color = ccc3(255,0,0);
    }
    if ([colorString isEqualToString:@"blue"] == TRUE) {
        tut.color = ccc3(0,0,255);
    }
    if ([colorString isEqualToString:@"green"] == TRUE) {
        tut.color = ccc3(0,255,0);
    }
    if ([colorString isEqualToString:@"black"] == TRUE) {
        tut.color = ccc3(0,0,0);
    }
    if ([colorString isEqualToString:@"white"] == TRUE) {
        tut.color = ccc3(255,255,255);
    }
    tut.fontName = @"HelveticaNeue-Light";
    [tut setString:stringToFlashOnScreen];
    id addVisibility = [CCCallFunc actionWithTarget:self selector:@selector(makeFlashLabelVisible)];
    id delayInvis = [CCDelayTime actionWithDuration:numSecondsToFlash];
    id addInvis = [CCCallFunc actionWithTarget:self selector:@selector(makeFlashLabelInvisible)];
    CCSequence *showLabelSeq = [CCSequence actions:addVisibility, delayInvis, addInvis, nil];
    [self runAction:showLabelSeq];
}
-(void) makeFlashLabelVisible {
    tut.visible = TRUE;
}
-(void) makeFlashLabelInvisible {
    tut.visible = FALSE;
}
-(void) dotsEffect:(CCSprite *) spriteToBeTheNextBigThing {
    id dropdown = [CCMoveTo actionWithDuration:1.0f position:ccp(screenCenter.x, screenCenter.y + 140)];
    id jump = [CCJumpBy actionWithDuration:0.75f position:CGPointZero height:15 jumps:3];
    id repeatJump = [CCRepeat actionWithAction:jump times:1];
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:dropdown, repeatJump, nil]];
}
-(void) flash:(int) red green:(int) green blue:(int) blue alpha:(int) alpha actionWithDuration:(float) duration {
    colorLayer = [CCLayerColor layerWithColor:ccc4(red, green, blue, alpha)];
    [self addChild:colorLayer z:0];
    id delay = [CCDelayTime actionWithDuration:duration];
    id fadeOut = [CCFadeOut actionWithDuration:0.5f];
    [colorLayer runAction:[CCSequence actions:delay, fadeOut, nil]];
    [self schedule:@selector(delflash) interval:0.5];
}
-(void) rflash:(int) red green:(int) green blue:(int) blue alpha:(int) alpha actionWithDuration:(float) duration {
    colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, alpha)];
    [self addChild:colorLayer z:0];
    id tint = [CCTintTo actionWithDuration:0.5 red:red green:green blue:blue];
    id delay = [CCDelayTime actionWithDuration:duration];
    id fadeOut = [CCFadeOut actionWithDuration:0.5f];
    [colorLayer runAction:[CCSequence actions:tint, delay, fadeOut, nil]];
    [self schedule:@selector(delrflash) interval:0.5];
}
- (void)delflash {
    [self unschedule:@selector(delflash)];
    [self removeChild:colorLayer cleanup:YES];
}
- (void)delrflash {
    [self unschedule:@selector(delrflash)];
    [self removeChild:colorLayer cleanup:YES];
    if(bosstime == true) {
        glClearColor(255, 255, 255, 255);
    }
    else {
        glClearColor(255, 255, 255, 255);
    }
}
-(void) setDimensionsInPixelsGraduallyOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height {
    id scaleX = [CCScaleTo actionWithDuration:0.5f scaleX:0 scaleY:1];
    [spriteToSetDimensions runAction:scaleX];
}
/* -------------------------------------------------------------------------------- */
/*    SCENES AND OTHER THINGS BESIDES GAMEPLAY                                      */
/* -------------------------------------------------------------------------------- */
-(void) gameover {
    if(isDying == true) {
        [self unschedule:@selector(gameover)];
        gameSegment = 0;
        framespast = 0;
        secondspast = 0;
        [[SimpleAudioEngine sharedEngine] playEffect:@"zoom.mp3"];
        [[NSUserDefaults standardUserDefaults] setInteger:intScore forKey:@"score"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[Dead node]]];
    }
}
-(void) pause {
    [[CCDirector sharedDirector] pushScene:
     [CCTransitionCrossFade transitionWithDuration:0.5f scene:[Pausue node]]];
}
-(void) playerdeathstart {
    if(deathanimation == true) {
        [self flash:0 green:150 blue:150 alpha:255 actionWithDuration:2.5];
        [self schedule:@selector(scalePlayer) interval:0.5];
        deathanimation = false;
    }
}
-(void) scalePlayer {
    [self unschedule:@selector(scalePlayer)];
    id tintp = [CCTintTo actionWithDuration:0.5 red:68 green:68 blue:255];
    id scalep = [CCScaleTo actionWithDuration:0.5 scale:5];
    [bullet runAction:tintp];
    [bullet runAction:scalep];
    [self schedule:@selector(playerdeath) interval:0.5];
}
-(void) gameSegmentBeat {
    // When the level ends - countdown :)
    [self pauseSchedulerAndActions];
    
    CCSprite *opaqueBG = [CCSprite spriteWithFile:@"background1.png"];
    opaqueBG.position = screenCenter;
    [self addChild:opaqueBG z:10000];
    
    CCLabelTTF *three = [CCLabelTTF labelWithString:@"3" fontName:@"HelveticaNeue-Light" fontSize:100];
    three.position = ccp(screenCenter.x, screenCenter.y);
    CCLabelTTF *two = [CCLabelTTF labelWithString:@"2" fontName:@"HelveticaNeue-Light" fontSize:100];
    two.position = ccp(screenCenter.x, screenCenter.y);
    CCLabelTTF *one = [CCLabelTTF labelWithString:@"1" fontName:@"HelveticaNeue-Light" fontSize:100];
    one.position = ccp(screenCenter.x, screenCenter.y);
    CCLabelTTF *go = [CCLabelTTF labelWithString:@"Go!" fontName:@"HelveticaNeue-Light" fontSize:100];
    go.position = ccp(screenCenter.x, screenCenter.y);
    
    dispatch_time_t countdownTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_after(countdownTime1, dispatch_get_main_queue(), ^(void){
        [self addChild:three z:10001];
    });
    dispatch_time_t countdownTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(countdownTime2, dispatch_get_main_queue(), ^(void){
        [self removeChild:three];
        [self addChild:two z:10001];
    });
    dispatch_time_t countdownTime3 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(countdownTime3, dispatch_get_main_queue(), ^(void){
        [self removeChild:two];
        [self addChild:one z:10001];
    });
    dispatch_time_t countdownTime4 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    dispatch_after(countdownTime4, dispatch_get_main_queue(), ^(void){
        [self removeChild:one];
        [self addChild:go z:10001];
    });
    dispatch_time_t countdownTime5 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC));
    dispatch_after(countdownTime5, dispatch_get_main_queue(), ^(void){
        [self removeChild:go];
        [self removeChild:opaqueBG];
    });
}
-(void) playerdeath {
    isDying = true;
    [self unschedule:@selector(playerdeath)];
    [self unscheduleUpdate];
    NSLog(@"Player Died");
    // Background
    border = [CCSprite spriteWithFile:@"continuebg.png"];
    border.position = ccp(screenCenter.x,screenCenter.y);
    if ([[CCDirector sharedDirector] winSizeInPixels].height == 1136){
        border = [CCSprite spriteWithFile:@"continuebg-568h.png"];
        border.position = ccp(screenCenter.x,screenCenter.y);
    }
    [self addChild:border z:9010];
    // The coin label
    NSString* world = [NSString stringWithFormat:@"...continue for %d coins.",continueCost];
    gameOver2 = [CCLabelTTF labelWithString:world fontName:@"HelveticaNeue-Medium" fontSize:25];
    gameOver2.position = ccp(screenCenter.x, screenCenter.y * 1.55);
    [self addChild:gameOver2 z:9011];
    // The "or..." button
    gameOver = [CCLabelTTF labelWithString:@"or..." fontName:@"HelveticaNeue-Bold" fontSize:24];
    gameOver.position = ccp(screenCenter.x, screenCenter.y - 54);
    gameOver.color = ccc3(52,73,94);
    [self addChild:gameOver z:9012];
    // The other buttons
    CCMenuItemImage* continueButton = [CCMenuItemImage itemWithNormalImage:@"keepgoing.png" selectedImage:@"keepgoing-sel.png" target:self selector:@selector(continuee)];
    continueButton.scale = 1.1f;
    CCMenuItemImage* dieButton = [CCMenuItemImage itemWithNormalImage:@"giveup.png" selectedImage:@"giveup-sel.png" target:self selector:@selector(gameover)];
    dieButton.scale = 1.1f;
    GameOverMenu = [CCMenu menuWithItems: continueButton, dieButton, nil];
    [GameOverMenu alignItemsVerticallyWithPadding:45.0];
    GameOverMenu.position = ccp(screenCenter.x, screenCenter.y - 54);
    [self addChild:GameOverMenu z:9011];
}
-(void) continuee {
    if(coins >= continueCost) {
        [[NSUserDefaults standardUserDefaults] setInteger:(coins - continueCost) forKey:@"coins"];
        continueCost = continueCost * 2;
        [self boughtProduct];
    }
    else {
        [[CCDirector sharedDirector] pushScene:
         [CCTransitionCrossFade transitionWithDuration:0.5f scene:[StoreLayer node]]];
    }
}
-(void) updateCoins {
    coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
    [coinLabel setString:[NSString stringWithFormat:@"%i",coins]];
}
-(void) boughtProduct {
    id tintp = [CCTintTo actionWithDuration:0.6 red:247 green:147 blue:29];
    id scalep = [CCScaleTo actionWithDuration:0.1 scale:0.15];
    [bullet runAction:tintp];
    [bullet runAction:scalep];
    [self removeChild:blocker cleanup:YES];
    deathanimation = true;
    player.position = ccp(screenCenter.x,screenCenter.y / 4);
    [self removeFromParentAndCleanup:YES];
    [self removeChild:border cleanup:YES];
    [self removeChild:coinLabel cleanup:YES];
    [self removeChild:gameOver cleanup:YES];
    [self removeChild:gameOver1 cleanup:YES];
    [self removeChild:gameOver2 cleanup:YES];
    [self removeChild:gameOver3 cleanup:YES];
    [self removeChild:dieLabel cleanup:YES];
    [self removeChild:continuePressed cleanup:YES];
    [self removeChild:gameOverLayer cleanup:YES];
    [self removeChild:GameOverMenu cleanup:YES];
    [self scheduleUpdate];
    [[CCDirector sharedDirector] resume];
    [self returnBullet];
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        Bullet *temp = [bullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
    }
    [bullets removeAllObjects];
    for(NSUInteger i = 0; i < [flowerbullets count]; i++) {
        Bullet *temp = [flowerbullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
    }
    [flowerbullets removeAllObjects];
    isDying = false;
    [self unschedule:@selector(gameover)];
    shield = [CCSprite spriteWithFile:@"shield.png"];
    shield.scale = 0.15;
    shield.position = player.position;
    [self addChild:shield z:-10];
    ubershieldon = true;
    [self schedule:@selector(deleteubershield) interval:3.0];
}
@end