/*
 * Copyright (c) 2010-2011 Shalin Shah.
 */

#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "Player.h"
#import "Dead.h"
#import "LevelSelect.h"
#import "StoreLayer.h"

@interface HelloWorldLayer (PrivateMethods)
@end

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
int gameSegment = 0;
int framespast;
int secondspast;
int stagespast;
int wowanothertemportalint;
int coins;
CCSprite* blank;
CCMotionStreak* streak;

-(id) init
{
    if ((self = [super init]))
    {
        targetHit = false;
        [[NSUserDefaults standardUserDefaults] setBool:targetHit forKey:@"targetHit"];
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"hex.mp3" loop:YES];
        deathanimation = true;
        streak = [CCMotionStreak streakWithFade:0.5 minSeg:1 width:50 color:ccc3(247,148,29) textureFilename:@"orange.png"];
        streak.position = player.position;
        //[self addChild:streak];
        glClearColor(255,255,255,255);
        continueCost = 1;
        coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
        redtint = 0;
        greentint = 0;
        bluetint = 255;
        wowanothertemportalint = 180;
        NSNumber *leveldata = [[NSUserDefaults standardUserDefaults] objectForKey:@"leveldata"];
        level = [leveldata intValue];
        NSLog([NSString stringWithFormat:@"%i", level]);
        shieldon = false;
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialcompleted"] == false) {
            stagespast = 0;
//            bosstime = false;
        }
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"tutorialcompleted"] == true) {
            stagespast = 4;
            attacktype = 4;
//            bosstime = true;
        }
        framespast = 0;
        secondspast = 0;
        gameSegment = 0;
        bosstime = true;
        isTimeWarped = false;
        thetemporalint = 180;
        omganothertemportalint = 180;
        intScore = 0;
        screenSize = [[CCDirector sharedDirector] winSize];
        bullets = [[NSMutableArray alloc] init];
        donkeys = [[NSMutableArray alloc] init];
        flowerbullets = [[NSMutableArray alloc] init];
        //bulletSpeed = [[NSMutableArray alloc] init];
        fakebullets = [[NSMutableArray alloc] init];
        powerups = [[NSMutableArray alloc] init];
        //bulletDirection = [[NSMutableArray alloc] init];
        director = [CCDirector sharedDirector];
        screenCenter = [[CCDirector sharedDirector] screenCenter];
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
        pausebutton.position = ccp(305,465);
        pausebutton.scale = 1;
        [self addChild:pausebutton];
        [self initScore];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bwooo.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"zoom.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"timewwarp.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"swip.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"yeswecan.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"down2.mp3"];
        blank = [CCSprite spriteWithFile:@"blank.png"];
        blank.position = ccp(160,240);
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
        }
        [self initBoss];
    }
    return self;
}
-(void)update:(ccTime)dt
{
    for(int i = 0; i < [bullets count]; i++)
    {
        CCSprite* shalinbullet = [bullets objectAtIndex:i];        
        if(shalinbullet.position.x > 310) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i];        }
        if(shalinbullet.position.x < -5) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i];        }
        if(shalinbullet.position.y < 0) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i];
        }
    }
    
    if(bosstime == false) {
        if(framespast == 300) {
            if(stagespast > -1) {
                [self returnBullet];
                for(int i = 0; i < [bullets count]; i++) {
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
                
                [tut setString:@"Dont touch blue!"];
                
                //ccaction//delay 3 seconds after 3 secs: [self shootBulletWithPosPowerup 3 370 0 0];
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
    if(isTimeWarped)
    {
        framespast++;
    }
    secondspast = framespast/60;
    [self bossAttack];
//    [self gameSeg];
    [self detectCollisions];
    // [self tint];
    KKInput* input = [KKInput sharedInput];
    if ([input isAnyTouchOnNode:pausebutton touchPhase:KKTouchPhaseAny]) {
        [self pause];
    }
}
-(void) initScore
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"startgame"] == false)
    {
        [MGWU showMessage:@"Achievement Get!      A Blue World" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"startgame"];
    }
    label = [CCLabelTTF labelWithString:@"0" fontName:@"NexaBold" fontSize:24];
    label.position = ccp(5,463);
    label.anchorPoint = ccp(0.0,0.5);
    label.color = ccc3(0, 0, 0);
    [self addChild: label];
}

/* -------------------------------------------------------------------------------- */
/*    GAMEPLAY                                                                      */
/* -------------------------------------------------------------------------------- */
-(void) bossAttack {
    if(bosstime == true) {
        if(level == 0){
            if(gameSegment == 0) {
                if((framespast % 25) == 0) {
                    tut = [CCLabelTTF labelWithString:@"Touch to move" fontName:@"Bend2SquaresBRK" fontSize:60];
                    tut.position = ccp(160,320);
                    tut.color = ccc3(0, 0, 0);
                    [self addChild: tut];
                }
            }
            if(gameSegment == 1) {
                if((framespast % 25) ==0) {
                    [self shootBulletwithPos:1 angle:260 xpos:0 ypos:0];
                    [self removeChild:tut];
                    tut = [CCLabelTTF labelWithString:@"Don't touch blue" fontName:@"Bend2SquaresBRK" fontSize:60];
                    tut.position = ccp(160,320);
                    tut.color = ccc3(0, 0, 0);
                    [self addChild:tut];
                }
            }
            if(gameSegment == 2) {
                if((framespast % 25) ==0) {
                    [self shootBulletwithPosPowerup:1 angle:260 xpos:0 ypos:0];
                    [self removeChild:tut];
                    tut = [CCLabelTTF labelWithString:@"Grab shields" fontName:@"Bend2SquaresBRK" fontSize:60];
                    tut.position = ccp(160,320);
                    tut.color = ccc3(0, 0, 0);
                    [self addChild:tut];
                }
            }
        }        
        if(level == 1) {
            if(gameSegment == 0) {
                if((framespast % 25) == 0) {
//                    int tempInt = (arc4random() % 90) + 240;
//                    [self shootBullet:1 angle:tempInt];
                    [self shootBullet:3 angle:270];
                }
            }
            if(gameSegment == 1) {
                if((framespast % 25) ==0) {
                    [self shootBullet:3 angle:230];
                    [self shootBullet:5 angle:270];
                    [self shootBullet:3 angle:310];
                }
            }
            if(gameSegment == 2) {
                if((framespast % 25) ==0) {
                    [self shootBullet:5 angle:300];
                    [self shootBullet:5 angle:240];
                }
                
                for(int i = 0; i < [bullets count]; i++)
                {
                    NSInteger j = i;
                    projectile = [bullets objectAtIndex:j];
                    
                    if(projectile.position.x > 300) {
                        
                        [[bullets objectAtIndex:j] changeAngle:240.0];
                    }
                    if(projectile.position.x < 10) {
                        [[bullets objectAtIndex:j] changeAngle:300.0];
                    }
                    if(projectile.position.y < 0) {
                        if( [[bullets objectAtIndex:j] getAngle] == 240) {
                            [[bullets objectAtIndex:j] changeAngle:160.0];
                        }
                        if([[bullets objectAtIndex:j] getAngle] == 300) {
                            [[bullets objectAtIndex:j] changeAngle:390.0];
                        }
                    }
                    
                }
            }
            if(gameSegment == 3) {
                if((framespast % 25) ==0) {
                    [self shootBullet:3 angle:180];
                    for(int i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 30;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment == 4) {
                if((framespast % 25) ==0) {
                    [self shootBullet:3 angle:270];
                    [self shootBullet:3 angle:270];
                    for(int i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + (arc4random() % 90)-45;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment == 5) {
                if((framespast % 45) ==0) {
                    [self shootBullet:3 angle:thetemporalint];
                    thetemporalint = thetemporalint + 15;
                    [self shootBullet:3 angle:thetemporalint];
                    for(int i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        [[bullets objectAtIndex:j] changeAngle:[[bullets objectAtIndex:j] getAngle] + 5];
                    }
                }
            }
            if(gameSegment == 6) {
                if((framespast % 45) ==0) {
                    [self shootBullet:3 angle:180];
//                    [self shootBullet:3 angle:200];
//                    [self shootBullet:3 angle:220];
                    [self shootBullet:3 angle:240];
                    [self shootBullet:3 angle:260];
                    [self shootBullet:3 angle:280];
                    [self shootBullet:3 angle:300];
//                    [self shootBullet:3 angle:320];
//                    [self shootBullet:3 angle:340];
                    [self shootBullet:3 angle:360];
                }
            }
        }
        if(level == 2) {
            if(gameSegment ==0) {
                if((framespast % 100) == 0) {
                    int tempInt = (arc4random() % 90) + 240;
                    [self shootBullet:1 angle:tempInt];
//                    int tempInt = (arc4random() % 300) -245;
//                    [self makeDownvote:tempInt];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPos:3 angle:240 xpos:-50 ypos:0];
                    [self shootBulletwithPos:3 angle:300 xpos:50 ypos:0];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPos:3 angle:240 xpos:100 ypos:0];
                    [self shootBulletwithPos:3 angle:300 xpos:-100 ypos:0];
                }
            }
            if(gameSegment ==3) {
                if([[NSUserDefaults standardUserDefaults]boolForKey:@"downwall"] == false) {
                    [MGWU showMessage:@"Achievement Get!      Retreat" withImage:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"downwall"];
                }
                if((framespast % 250) == 0) {
//                    [self makeDownvote:-200];
                    [self makeDownvote:-100];
                    if(isTimeWarped == false) {
                        [self makeDownvote:0];
                    }
//                    [self makeDownvote:100];
//                    [self makeDownvote:200];
                }
            }
            if(gameSegment ==4) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:270 xpos:100 ypos:0];
                    [self shootBulletwithPos:3 angle:271 xpos:-100 ypos:0];
                    for(int i = 0; i < [bullets count];i++) {
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
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:300 xpos:-100 ypos:0];
                    [self shootBulletwithPos:3 angle:240 xpos:100 ypos:0];
                    for(int i = 0; i < [bullets count];i++) {
                    }
                }
                if((framespast % 130) == 0) {
//                    [self makeDownvote:-65];
                }
            }
        }
        if(level == 3) {
            if(gameSegment ==0) {
                if(framespast == 160) {
                    [self makeFace];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 50) == 0) {
                    [self shootBulletwithPosDonkey:3 angle:270 xpos:0 ypos:0];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:omganothertemportalint xpos:0 ypos:0];
                    omganothertemportalint = omganothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:omganothertemportalint xpos:0 ypos:0];
                    omganothertemportalint = omganothertemportalint + 15;
                }
            }
            if(gameSegment ==3) {
                if((framespast % 10) == 0) {
                    [self shootBulletwithPos:7 angle:275 xpos:0 ypos:0];
                    [self shootBulletwithPos:7 angle:250 xpos:0 ypos:0];
                    [self shootBulletwithPos:7 angle:300 xpos:0 ypos:0];
                    if([[NSUserDefaults standardUserDefaults]boolForKey:@"obamablast"] == false)
                    {
                        [MGWU showMessage:@"Achievement Get!      Obamablast!" withImage:nil];
                        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"obamablast"];
                    }
                }
            }
            if(gameSegment ==4) {
                if(framespast == 1500) {
                    [self yeswecan];
                }
                if((framespast % 50) == 0) {
                    [self shootBulletwithPosDonkey:3 angle:270 xpos:100 ypos:0];
                    [self shootBulletwithPosDonkey:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosDonkey:3 angle:270 xpos:-100 ypos:0];
                }
            }
        }
        if(level == 4) {
            if(gameSegment ==0) {
                if(framespast == 160) {
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 0; i < 8;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(160,460 - i*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 9; i < 16;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(0,460 - (i-8)*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 17; i < 24;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(320,460 - (i-16)*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                }
            }
            if(gameSegment ==1) {
                if(framespast == 251) {
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 0; i < 8;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(i*40,400)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 9; i < 16;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(0,460 - (i-8)*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 17; i < 24;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(320,460 - (i-16)*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                }
            }
            if(gameSegment ==2) {
                if(framespast == 351) {
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 0; i < 8;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(160-(i*20),460 - i*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 8; i < 16;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(160+((i-8)*20),460 - (i-8)*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                }
            }
            if(gameSegment ==3) {
                if(framespast == 451) {
                    [flowerbullets removeAllObjects];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 0; i < 8;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(360-(i*36),300)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 9; i < 16;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(0+((i-8)*36),50)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                }
            }
            if(gameSegment ==4) {
                if(framespast == 551) {
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 0; i < 8;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(80,460 - i*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPosNoArray:3 angle:270 xpos:0 ypos:0];
                    for(int i = 9; i < 16;i++) {
                        id flowermove = [CCMoveTo actionWithDuration:1.0 position:ccp(240,460 - (i-8)*60)];
                        [[flowerbullets objectAtIndex:i] runAction:flowermove];
                    }
                }
                if((framespast % 15) == 0) {
                    [self shootBulletwithPos:5 angle:0 xpos:-180 ypos:-80];
                    [self shootBulletwithPos:5 angle:0 xpos:-180 ypos:-160];
                    [self shootBulletwithPos:5 angle:0 xpos:-180 ypos:-240];
                }
            }
            if(gameSegment ==5) {
                if(framespast == 651) {}
                if((framespast % 15) ==0) {
                    [self shootBulletwithPos:3 angle:180 xpos:-80 ypos:-100];
                    [self shootBulletwithPos:3 angle:180 xpos:80 ypos:-100];
                    [self shootBulletwithPos:3 angle:180 xpos:0 ypos:-180];
                    for(int i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 30;
                        
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==6) {
                if(framespast == 851) { }
                if((framespast % 15) ==0) {
                    [self shootBulletwithPos:3 angle:180 xpos:-160 ypos:-140];
                    [self shootBulletwithPos:3 angle:180 xpos:160 ypos:-140];
                    for(int i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 30;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==7) {
                if(framespast == 1001) { }
                if((framespast % 15) ==0) {
                    [self shootBulletwithPos:3 angle:0 xpos:-160 ypos:-140];
                    [self shootBulletwithPos:3 angle:180 xpos:160 ypos:-140];
                    for(int i = 0; i < [bullets count]; i++) {
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 20;
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
            if(gameSegment ==8) {
                if(framespast == 1151) {}
                if((framespast % 15) ==0){
                    [self shootBulletwithPos:3 angle:90 xpos:0 ypos:-440];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++){
                        NSInteger j = i;
                        int tempDir = [[bullets objectAtIndex:j] getAngle] + 20;
                        
                        [[bullets objectAtIndex:j] changeAngle:tempDir];
                    }
                }
            }
        }
        if(level == 5) {
            if(gameSegment ==0) {
                if(framespast == 160) {
//                    [self shootBullet:3 angle:230];
//                    [self shootBullet:5 angle:270];
//                    [self shootBullet:3 angle:310];
                    
                    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-120];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-120];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-120];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-120];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-120];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-140];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-140];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:-140];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-140];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-160];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:-160];
                    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-160];
                    
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-120];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-120];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-120];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-120];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-120];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-140];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-140];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:-140];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-140];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-160];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:-160];
//                    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-160];
                }
            }
            if(gameSegment ==1) {
                if((framespast % 50) == 0) {
//                    [self shootBulletwithPosDonkey:3 angle:270 xpos:0 ypos:0];
                }
            }
            if(gameSegment ==2) {
                if((framespast % 25) == 0) {
//                    [self shootBulletwithPos:3 angle:omganothertemportalint xpos:0 ypos:0];
//                    omganothertemportalint = omganothertemportalint + 15;
//                    [self shootBulletwithPos:3 angle:omganothertemportalint xpos:0 ypos:0];
//                    omganothertemportalint = omganothertemportalint + 15;
                }
            }
            if(gameSegment ==3) {
                if((framespast % 10) == 0) {
//                    [self shootBulletwithPos:7 angle:270 xpos:0 ypos:0];
//                    [self shootBulletwithPos:7 angle:250 xpos:0 ypos:0];
//                    [self shootBulletwithPos:7 angle:290 xpos:0 ypos:0];
//                    if([[NSUserDefaults standardUserDefaults]boolForKey:@"obamablast"] == false)
//                    {
//                        [MGWU showMessage:@"Achievement Get!      Obamablast!" withImage:nil];
//                        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"obamablast"];
//                    }
                }
            }
            if(gameSegment ==4) {
                if(framespast == 1500) {
//                    [self yeswecan];
                }
                if((framespast % 50) == 0) {
//                    [self shootBulletwithPosDonkey:3 angle:270 xpos:100 ypos:0];
//                    [self shootBulletwithPosDonkey:3 angle:270 xpos:0 ypos:0];
//                    [self shootBulletwithPosDonkey:3 angle:270 xpos:-100 ypos:0];
                }
            }
        }
        if(gameSegment == 1) {
//            [self removeChild:tut];
        }
    }
    else if(bosstime == false){
        if(stagespast < 5){
            if(attacktype == 0){
                attacktype = 1;
            }
            if(attacktype == 1){
                if(framespast == 10){
                    if(isTimeWarped == false){
                        tut = [CCLabelTTF labelWithString:@"Touch to move" fontName:@"Bend2SquaresBRK" fontSize:60];
                        tut.position = ccp(160,320);
                        tut.color = ccc3(0, 0, 0);
                        [self addChild: tut];
                    }
                    else if(isTimeWarped == true){
                        tut = [CCLabelTTF labelWithString:@"time has been warped" fontName:@"Bend2SquaresBRK" fontSize:30];
                        tut.position = ccp(160,320);
                        tut.color = ccc3(0, 0, 0);
                        [self addChild: tut];
                    }
                }
            }
            else if(attacktype == 2){
                if(framespast ==10){
                    [self shootBulletwithPos:1 angle:260 xpos:0 ypos:0];
                    [self removeChild:tut];
                    tut = [CCLabelTTF labelWithString:@"Don't touch blue" fontName:@"Bend2SquaresBRK" fontSize:60];
                    tut.position = ccp(160,320);
                    tut.color = ccc3(0, 0, 0);
                    [self addChild:tut];
                }
            }
            else if(attacktype == 3){
                if(framespast ==10){
                    [self shootBulletwithPosPowerup:1 angle:260 xpos:0 ypos:0];
                    [self removeChild:tut];
                    tut = [CCLabelTTF labelWithString:@"Grab powerups for\nan additional shield" fontName:@"Bend2SquaresBRK" fontSize:60];
                    tut.position = ccp(160,320);
                    tut.color = ccc3(0, 0, 0);
                    [self addChild:tut];
                    
                }
            }
            else if(attacktype == 4){
                if(framespast == 10){
                    [self removeChild:tut];
                    bosstime = true;
                    [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"tutorialcompleted"];
                }
                if((framespast % 50) == 0){
                    
                    [self shootBulletwithPos:1 angle:360 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:1 angle:360 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:1 angle:360 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:1 angle:360 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 5){
                if((framespast % 25) == 0){
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++) {}
                }
            }
        }
        if(stagespast > 4 && stagespast < 10) {
            if(attacktype == 0) {
                tempattacktype = (arc4random() % 5)+1;
                while(attacktype == tempattacktype) {
                    tempattacktype = (arc4random() % 5)+1;
                }
                attacktype = tempattacktype;
                NSLog([NSString stringWithFormat:@"%d",attacktype]);
                wowanothertemportalint = 180;
            }
            if(attacktype == 1) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:270 xpos:(arc4random() % 320)-160 ypos:0];
                }
            }
            else if(attacktype == 2) {
                if((framespast % 10) == 0) {
                    [self shootBulletwithPos:2 angle:(arc4random() % 360) xpos:0 ypos:-240];
                }
            }
            else if(attacktype == 3) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:300 xpos:-100 ypos:0];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPos:3 angle:240 xpos:100 ypos:0];
                }
            }
            else if(attacktype == 4) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 5) {
                if((framespast % 25) == 0) {
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++){}
                }
                if((framespast % 50) == 0) {
                    for(int i = 0; i < [bullets count]; i++){
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] + 15];
                    }
                }
            }
        }
        if(stagespast > 9 && stagespast < 15) {
            if(attacktype == 0) {
                tempattacktype = (arc4random() % 5)+1;
                while(attacktype == tempattacktype) {
                    tempattacktype = (arc4random() % 5)+1;
                }
                attacktype = tempattacktype;
                wowanothertemportalint = 180;
            }
            if(attacktype == 1){
                if((framespast % 75) == 0){
                    int tempInt = (arc4random() % 300) -245;
                    [self makeDownvote:tempInt];
                }
            }
            else if(attacktype == 2){
                if((framespast % 50) == 0){
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
            else if(attacktype == 3){
                if((framespast % 75) == 0){
                    [self makeDownvoteSpeed:-100 speed:3];
                    [self makeDownvoteSpeed:100 speed:3];
                }
            }
            else if(attacktype == 4){
                if((framespast % 75) == 0)
                {
                    [self shootBulletwithPos:2 angle:340 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:2 angle:350 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:2 angle:10 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:2 angle:20 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 5){
                if((framespast % 25) == 0){
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++) {}
                }
                if((framespast % 50) == 0) {
                    for(int i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                    }
                }
            }
        }
        if(stagespast > 14 && stagespast < 20) {
            if(attacktype == 0) {
                tempattacktype = (arc4random() % 5)+1;
                while(attacktype == tempattacktype) {
                    tempattacktype = (arc4random() % 5)+1;
                }
                attacktype = tempattacktype;
                wowanothertemportalint = 180;
            }
            if(attacktype == 1) {
                if((framespast % 75) == 0) {
                    int tempInt = (arc4random() % 300) -245;
                    [self shootBulletwithPosDonkey:2 angle:270 xpos:tempInt ypos:0];
                }
            }
            else if(attacktype == 2) {
                if((framespast % 50) == 0) {
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
            else if(attacktype == 3) {
                if((framespast % 75) == 0) {
                    [self makeDownvoteSpeed:-100 speed:3];
                    [self makeDownvoteSpeed:100 speed:3];
                }
            }
            else if(attacktype == 4) {
                if((framespast % 75) == 0) {
                    [self shootBulletwithPos:2 angle:340 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:2 angle:350 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:2 angle:10 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:2 angle:20 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 5) {
                if((framespast % 25) == 0) {
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++){}
                }
                if((framespast % 50) == 0){
                    for(int i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                    }
                }
            }
        }
        if(stagespast > 19) {
            if(attacktype == 0) {
                tempattacktype = (arc4random() % 14)+1;
                while(attacktype == tempattacktype) {
                    tempattacktype = (arc4random() % 14)+1;
                }
                attacktype = tempattacktype;
                wowanothertemportalint = 180;
            }
            if(attacktype == 1) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:270 xpos:(arc4random() % 320)-160 ypos:0];
                }
            }
            else if(attacktype == 2) {
                if((framespast % 10) == 0) {
                    [self shootBulletwithPos:2 angle:(arc4random() % 360) xpos:0 ypos:-240];
                }
            }
            else if(attacktype == 3) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:3 angle:300 xpos:-100 ypos:0];
                    [self shootBulletwithPos:3 angle:270 xpos:0 ypos:0];
                    [self shootBulletwithPos:3 angle:240 xpos:100 ypos:0];
                }
            }
            else if(attacktype == 4) {
                if((framespast % 25) == 0) {
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:2 angle:360 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 5) {
                if((framespast % 25) == 0) {
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++) {}
                }
                if((framespast % 50) == 0) {
                    for(int i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] + 15];
                    }
                }
            }
            else if(attacktype == 6) {
                if((framespast % 75) == 0) {
                    int tempInt = (arc4random() % 300) -245;
                    [self makeDownvote:tempInt];
                }
            }
            else if(attacktype == 7) {
                if((framespast % 50) == 0) {
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
            else if(attacktype == 8) {
                if((framespast % 75) == 0) {
                    [self makeDownvoteSpeed:-100 speed:3];
                    [self makeDownvoteSpeed:100 speed:3];
                }
            }
            else if(attacktype == 9) {
                if((framespast % 75) == 0) {
                    [self shootBulletwithPos:2 angle:340 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:2 angle:350 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:2 angle:10 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:2 angle:20 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 10) {
                if((framespast % 25) == 0) {
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++) {}
                }
                if((framespast % 50) == 0) {
                    for(int i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                    }
                }
            }
            if(attacktype == 11) {
                if((framespast % 75) == 0) {
                    int tempInt = (arc4random() % 300) -245;
                    [self shootBulletwithPosDonkey:2 angle:270 xpos:tempInt ypos:0];
                }
            }
            else if(attacktype == 12) {
                if((framespast % 50) == 0) {
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
            else if(attacktype == 13) {
                if((framespast % 75) == 0) {
                    [self makeDownvoteSpeed:-100 speed:3];
                    [self makeDownvoteSpeed:100 speed:3];
                }
            }
            else if(attacktype == 14) {
                if((framespast % 75) == 0) {
                    [self shootBulletwithPos:2 angle:340 xpos:-200 ypos:-80];
                    [self shootBulletwithPos:2 angle:350 xpos:-200 ypos:-200];
                    [self shootBulletwithPos:2 angle:10 xpos:-200 ypos:-320];
                    [self shootBulletwithPos:2 angle:20 xpos:-200 ypos:-440];
                }
            }
            else if(attacktype == 15) {
                if((framespast % 25) == 0) {
                    wowanothertemportalint = wowanothertemportalint + 15;
                    [self shootBulletwithPos:3 angle:wowanothertemportalint xpos:0 ypos:0];
                    for(int i = 0; i < [bullets count]; i++) {}
                }
                if((framespast % 50) == 0) {
                    for(int i = 0; i < [bullets count]; i++) {
                        [[bullets objectAtIndex:i] changeAngle:[[bullets objectAtIndex:i] getAngle] - 15];
                    }
                }
            }
        }
    }
    [self moveBullet];
    [self moveFakeBullet];
}
-(void) yeswecan {
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"yeswecan"] == false) {
        [MGWU showMessage:@"Achievement Get!      Run to the Bottom!" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"yeswecan"];
    }
    [[SimpleAudioEngine sharedEngine] playEffect:@"yeswecan.mp3"];
    // yes
    [self shootBulletwithPosSmall:1 angle:270 xpos:-140 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:0];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-20];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-80 ypos:-20];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-20];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-20];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:-40];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:-60];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-80];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:-80];
    // we
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-120];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-120];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-120];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-120];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-120];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-140];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-140];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:-140];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-140];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-160];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-60 ypos:-160];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-160];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-160];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-160];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-160];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-180];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-80 ypos:-180];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-40 ypos:-180];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-180];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-180];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-200];
    [self shootBulletwithPosSmall:1 angle:270 xpos:60 ypos:-200];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-200];
    //can
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-80 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:160 ypos:-240];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-260];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-260];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:-260];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-260];
    [self shootBulletwithPosSmall:1 angle:270 xpos:100 ypos:-260];
    [self shootBulletwithPosSmall:1 angle:270 xpos:160 ypos:-260];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-280];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-40 ypos:-280];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-280];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-280];
    [self shootBulletwithPosSmall:1 angle:270 xpos:120 ypos:-280];
    [self shootBulletwithPosSmall:1 angle:270 xpos:160 ypos:-280];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:140 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:160 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-40 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-300];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-120 ypos:-320];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-100 ypos:-320];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-80 ypos:-320];
    [self shootBulletwithPosSmall:1 angle:270 xpos:-40 ypos:-320];
    [self shootBulletwithPosSmall:1 angle:270 xpos:40 ypos:-320];
    [self shootBulletwithPosSmall:1 angle:270 xpos:80 ypos:-320];
    [self shootBulletwithPosSmall:1 angle:270 xpos:160 ypos:-320];
}
-(void) makeDownvote:(float) xOffset {
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"downvote"] == false) {
        [MGWU showMessage:@"Achievement Get!      Downvoted" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"downvote"];
    }
//    [self shootBulletwithPos:1 angle:270 xpos:52+xOffset ypos:0];
//    [self shootBulletwithPos:1 angle:270 xpos:88+xOffset ypos:0];
//    [self shootBulletwithPos:1 angle:270 xpos:52+xOffset ypos:10];
//    [self shootBulletwithPos:1 angle:270 xpos:88+xOffset ypos:10];
//    [self shootBulletwithPos:1 angle:270 xpos:52+xOffset ypos:20];
//    [self shootBulletwithPos:1 angle:270 xpos:88+xOffset ypos:20];
//    [self shootBulletwithPos:1 angle:270 xpos:52+xOffset ypos:30];
//    [self shootBulletwithPos:1 angle:270 xpos:88+xOffset ypos:30];
//    [self shootBulletwithPos:1 angle:270 xpos:52+xOffset ypos:40];
//    [self shootBulletwithPos:1 angle:270 xpos:88+xOffset ypos:40];
//    [self shootBulletwithPos:1 angle:270 xpos:50+xOffset ypos:50];
//    [self shootBulletwithPos:1 angle:270 xpos:70+xOffset ypos:50];
//    [self shootBulletwithPos:1 angle:270 xpos:90+xOffset ypos:50];
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
-(void) makeHeadphones {
    // Left Headphone
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
    // Middle Headphone   
//    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-100];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-90];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-80];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-70];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-60];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:30 ypos:-50];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:20 ypos:-40];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:10 ypos:-40];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:0 ypos:-40];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-10 ypos:-40];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-20 ypos:-40];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-50];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-60];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-70];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-80];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-90];
//    [self shootBulletwithPosSmall:1 angle:270 xpos:-30 ypos:-100];
    // Right Headphone
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
-(void) makeMusicNotes {
    
}
-(void) makeCircles {
    
}
-(void) makeLightning {
    
}
-(void) makeStar {
    
}
-(void) makeSquare {
    
}
-(void) makeQuestion {
    
}
-(void) makeExclamation {
    
}
-(void) makeCheckmark {
    
}
-(void) makeX {
    
}
-(void) initObstacles {
    int x = 20;
    int y= 20;
    for (int i = 0; i < 1; i++) {
        obstacle = [CCSprite spriteWithFile:@"monster8.png"];
        obstacle.scale = 0.5;
        obstacle.position = ccp(x, y);
        [self addChild:obstacle z:10 tag:i];
        x = x + 40;
        y = y + 10;
    }
}
-(void) initBoss {
    if(bosstime == true) {
        label.color = ccc3(255, 255, 255);
        streak = [CCMotionStreak streakWithFade:0.5 minSeg:1 width:50 color:ccc3(247,148,29) textureFilename:@"orange.png"];
        streak.position = player.position;
        [self addChild:streak];
        [self rflash:0 green:0 blue:0 alpha:255 actionWithDuration:0];
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"boss"] < level) {
            tut = [CCLabelTTF labelWithString:@"New Boss!" fontName:@"Bend2SquaresBRK" fontSize:60];
            tut.position = ccp(160,320);
            tut.color = ccc3(255, 255, 255);
            [self addChild:tut z:9002];
            [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"boss"];
        }
        if(level == 1) {
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"bigblue"] == false) {
                [MGWU showMessage:@"Achievement Get!      The Big Blue, ruler of Blutopia" withImage:nil];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"bigblue"];
            }
            id newboss = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
            [tut runAction:newboss];
            [self schedule:@selector(newBoss) interval:3.0];
            int x = 150;
            int y = 400;
//            boss = [CCSprite spriteWithFile:@"Glowing_Blue_Orb.png"];
            boss = [CCSprite spriteWithFile:@"target.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
            [boss runAction:bossscale];
            [self shootBullet:1 angle:270];
        }
        else if(level == 2) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"down2.mp3"];
            int x = 150;
            int y = 400;
            boss = [CCSprite spriteWithFile:@"w_obama.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
            [boss runAction:bossscale];
            [self shootBullet:1 angle:90];
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"alienblue"] == false) {
                [MGWU showMessage:@"Achievement Get!      Alien Blue, Karmalord of Reddit" withImage:nil];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"alienblue"];
            }
        }
        else if(level == 3) {
            int x = 150;
            int y = 400;
            boss = [CCSprite spriteWithFile:@"Glowing_Blue_Orb.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
            [boss runAction:bossscale];
            [self shootBullet:1 angle:90];
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"obama"] == false) {
                [MGWU showMessage:@"Achievement Get!      Blubama, political overlord" withImage:nil];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"obama"];
            }
        }
        else if(level == 4) {
            int x = 150;
            int y = 400;
            boss = [CCSprite spriteWithFile:@"target.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
            [boss runAction:bossscale];
            [self shootBullet:1 angle:90];
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"blossom"] == false) {
                [MGWU showMessage:@"Achievement Get!      Blossom, the blue rose" withImage:nil];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"blossom"];
            }
        }
        else if(level == 5) {
            int x = 150;
            int y = 400;
            boss = [CCSprite spriteWithFile:@"download.png"];
            boss.position = ccp(x,y);
            boss.scale = 0;
            [self addChild:boss z:0];
            id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
            [boss runAction:bossscale];
            [self shootBullet:1 angle:90];
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"time"] == false){
                [MGWU showMessage:@"Achievement Get!      Time Vortex" withImage:nil];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"time"];
            }
        }
    }
    else if(bosstime == false) {
        int x = 150;
        int y = 500;
        boss = [CCSprite spriteWithFile:@"target.png"];
        boss.position = ccp(x,y);
        boss.scale = 0;
        [self addChild:boss z:0];
        id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
        [boss runAction:bossscale];
        [self shootBullet:1 angle:90];
    }
}
- (void)newBoss {
    [self unschedule:@selector(newBoss)];
    [self removeChild:tut cleanup:YES];
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
    [self removeChild:shield cleanup:true];
}
-(void) moveBullet {
    //move the bullets
    for(int i = 0; i < [bullets count]; i++) {
        NSInteger j = i;
        projectile = [bullets objectAtIndex:j];
        float angle = [[bullets objectAtIndex:j] getAngle];
        float speed = [[bullets objectAtIndex:j] getSpeed]; // Move 50 pixels in 60 frames (1 second)
        if(isTimeWarped == true) {
            speed = speed + 3;
        }
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(int i = 0; i < [donkeys count]; i++) {
        NSInteger j = i;
        projectile = [donkeys objectAtIndex:j];
        float angle = 270;
        float speed = 3;
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
    for(int i = 0; i < [powerups count]; i++) {
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
// This was the original code for switching the levels and gamesegments
//-(void) gameSeg {
//    if(bosstime == true) {
//        if(level == 1) {
//            if(framespast == 440) {
//                gameSegment = 1;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 740) {
//                gameSegment = 2;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 940) {
//                gameSegment = 3;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    NSInteger j = i;
//                    [self removeChild:[bullets objectAtIndex:j]];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1140) {
//                gameSegment = 4;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    NSInteger j = i;
//                    [self removeChild:[bullets objectAtIndex:j]];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1300) {
//                gameSegment = 5;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    CCSprite *tempB = [bullets objectAtIndex:i];
//                    [self removeChild:tempB];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1700) {
//                gameSegment = 6;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    NSInteger j = i;
//                    [self removeChild:[bullets objectAtIndex:j]];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1900) {
//                gameSegment = 7;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    NSInteger j = i;
//                    [self removeChild:[bullets objectAtIndex:j]];
//                }
//                [bullets removeAllObjects];
//                [self gameEnd];
//            }
//        }
//        if(level == 2) {
//            if(framespast == 540) {
//                gameSegment = 1;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 640) {
//                gameSegment = 2;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 840) {
//                gameSegment = 3;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1260) {
//                gameSegment = 4;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1460) {
//                gameSegment = 5;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 2000) {
//                gameSegment = 6;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//                [self gameEnd];
//            }
//        }
//        if(level == 3) {
//            if(framespast == 350) {
//                gameSegment = 1;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 650) {
//                gameSegment = 2;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1050) {
//                gameSegment = 3;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1450) {
//                gameSegment = 4;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 1700) {
//                gameSegment = 5;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//            }
//            if(framespast == 2000) {
//                gameSegment = 6;
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//                [self gameEnd];
//            }
//        }
//        if(level == 4) {
//            if(framespast == 250) {
//                gameSegment = 1;
//                [self deleteBullets];
//            }
//            if(framespast == 350) {
//                gameSegment = 2;
//                [self deleteBullets];
//            }
//            if(framespast == 450) {
//                gameSegment = 3;
//                [self deleteBullets];
//            }
//            if(framespast == 550) {
//                gameSegment = 4;
//                [self deleteBullets];
//            }
//            if(framespast == 650) {
//                gameSegment = 5;
//                [self deleteBullets];
//            }
//            if(framespast == 850) {
//                gameSegment = 6;
//                [self deleteBullets];
//            }
//            if(framespast == 1000) {
//                gameSegment = 7;
//                [self deleteBullets];
//            }
//            if(framespast == 1150) {
//                gameSegment = 8;
//                [self deleteBullets];
//            }
//            if(framespast == 1400) {
//                gameSegment = 9;
//                [self deleteBullets];
//                if([[NSUserDefaults standardUserDefaults]boolForKey:@"byeblossom"] == false) {
//                    [MGWU showMessage:@"Achievement Get!      You beat the game" withImage:nil];
//                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"byeblossom"];
//                }
//                if([[NSUserDefaults standardUserDefaults]boolForKey:@"endgamecontent"] == false) {
//                    [MGWU showMessage:@"Achievement Get!      EndGame Content++" withImage:nil];
//                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"endgamecontent"];
//                }
//                [self gameEnd];
//            }
//        }
//        if(level == 5) {
//            if(framespast == 250) {
//                [self warpTime];
//            }
//        }
//    }
//    if(bosstime == false) {
//        if(framespast == 300) {
//            if(stagespast > 5) {
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                    int randomtemp = arc4random() % 10;
//                    if(randomtemp == 5) {}
//                }
//                [bullets removeAllObjects];
//                attacktype = 0;
//                framespast = 0;
//                stagespast++;
//            }
//            if(stagespast < 6) {
//                [self returnBullet];
//                for(int i = 0; i < [bullets count]; i++) {
//                    Bullet *temp = [bullets objectAtIndex:i];
//                    [self removeChild:temp];
//                }
//                [bullets removeAllObjects];
//                attacktype++;
//                framespast = 0;
//                stagespast++;
//            }
//        }
//        if(stagespast == 5) {
//            bosstime = true;
//            level = 1;
//            [self initBoss];
//        }
//        else if(stagespast == 10) {
//            bosstime = true;
//            level = 2;
//            [self initBoss];
//        }
//        else if(stagespast == 15) {
//            bosstime = true;
//            level = 3;
//            [self initBoss];
//        }
//        else if(stagespast == 20) {
//            bosstime = true;
//            level = 4;
//            [self initBoss];
//        }
//        else if(stagespast == 25) {
//            bosstime = true;
//            level = 5;
//            [self initBoss];
//        }
//    }
//}
- (void)mySelector {
    [self unschedule:@selector(mySelector)];
    //create one
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"endless"] == false) {
        [[CCDirector sharedDirector] pushScene:
         [CCTransitionCrossFade transitionWithDuration:0.5f scene:[LevelSelect node]]];
    }
    stagespast = stagespast + 1;
//    bosstime = false;
//    bosstime = true;
    [self initBoss];
    gameSegment = 0;
    framespast = 0;
    NSLog(@"Boss defeated.");
}
-(void) moveFakeBullet
{
    for(int i = 0; i < [fakebullets count]; i++) {
        NSInteger j = i;
        projectile2 = [fakebullets objectAtIndex:j];
        CGPoint rot_pos2 = [projectile2 position];
        CGPoint rot_pos1 = [player position];
        float rotation_theta = atan((rot_pos1.y-rot_pos2.y)/(rot_pos1.x-rot_pos2.x)) * 180 / M_PI;
        //        float rotation;
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
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
    [newB runAction:scale];
}
-(void) shootBulletwithPos: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    int x = screenCenter.x - 20;
    int y = screenCenter.y + 50;
    newB.position = boss.position;
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
    [newB runAction:scale];
}
-(void) shootBulletwithPosNoArray: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = boss.position;
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [flowerbullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
    [newB runAction:scale];
}
-(void) shootBulletwithPosPowerup: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    if(shieldon == false) {
        Powerup *newB = [Powerup powerup:speed :angleInput];
        newB.position = boss.position;
        newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
        [self addChild:newB z:9];
        [powerups addObject:newB];
        newB.tag = 42;
        newB.scale = 0.2f;
//        [self removeChild:newB cleanup:YES];
        [self removeChild:shield cleanup:YES];
    }
}
-(void) shootBulletwithPosDonkey: (float) speed angle:(float) angleInput xpos:(float) xInput ypos:(float) yInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = boss.position;
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.1f];
    [newB runAction:scale];
    donkey = [CCSprite spriteWithFile:@"Democrat_Donkey.png"];
    donkey.position = newB.position;
    donkey.scale = 0;
    [self addChild:donkey z:-20];
    id bossscale = [CCScaleTo actionWithDuration:1.0f scale:0.5f];
    [donkey runAction:bossscale];
    [donkeys addObject:donkey];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"donkey"] == false) {
        [MGWU showMessage:@"Achievement Get!      Democratic Donkey" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"donkey"];
    }
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
    for(int i = 0; i < [bullets count]; i++) {
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
    for(int i = 0; i < [flowerbullets count]; i++) {
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
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"techno.mp3" loop:YES];
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
    for(int i = 0; i < [bullets count]; i++) {
        Bullet *temp = [bullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
   }
    for(int i = 0; i < [donkeys count]; i++) {
        CCSprite *temp = [donkeys objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
    }
    for(int i = 0; i < [flowerbullets count]; i++) {
        CCSprite *temp = [flowerbullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        [bullets removeAllObjects];
    }
//    if (bullet.position.x > screenSize.width || bullet.position.y > screenSize.height) {
//        Bullet *Somebullets = [bullets objectAtIndex:i];
//        [self removeChild:Somebullets cleanup:YES];
//        CCSprite *SomeflowerBullets = [flowerbullets objectAtIndex:i];
//        [self removeChild:SomeflowerBullets cleanup:YES];
//        CCSprite *someDonkeys = [donkeys objectAtIndex:i];
//        [self removeChild:someDonkeys cleanup:YES];
//    }
    [donkeys removeAllObjects];
    [bullets removeAllObjects];
    [flowerbullets removeAllObjects];
}
-(void) deathplusdeath {
    [[NSUserDefaults standardUserDefaults] setInteger:(coins + 1) forKey:@"coins"];
    [self removeChild:streak cleanup:YES];
    [self flash:0 green:0 blue:255 alpha:255 actionWithDuration:0];
    [self rflash:255 green:255 blue:255 alpha:255 actionWithDuration:0];
    [self shootBulletwithPosPowerup:3 angle:260 xpos:0 ypos:0];
    label.color = ccc3(0, 0, 0);
    id bossscale = [CCScaleTo actionWithDuration:1.0f scale:2.0f];
    [boss runAction:bossscale];
    id bossturn = [CCRotateTo actionWithDuration:3.0 angle:200];
    [boss runAction:bossturn];
    id bossscale2 = [CCScaleTo actionWithDuration:3.0f scale:0.0f];
    [boss runAction:bossscale2];
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"bossdefeat"] == false) {
        [MGWU showMessage:@"Achievement Get!      Boss Slayer" withImage:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"bossdefeat"];
    }
    stagespast = stagespast + 1;
//    bosstime = false;
    [self initBoss];
    gameSegment = 0;
    framespast = 0;
    NSLog([NSString stringWithFormat:@"%d",stagespast]);
    NSLog([NSString stringWithFormat:@"%d",bosstime]);
    //create first,delay,create second
    [self schedule:@selector(mySelector) interval:3.0];
    for(int i = 0; i<[donkeys count]; i++) {
        [self removeChild:[donkeys objectAtIndex:i] cleanup:YES];
    }
    [donkeys removeAllObjects];
}
/* -------------------------------------------------------------------------------- */
/*    COLLISIONS                                                                    */
/* -------------------------------------------------------------------------------- */
//obj2 is the player
-(BOOL) isCollidingSphere:(CCSprite *) obj1 WithSphere:(CCSprite *) obj2 {
    float minDistance = 12 + 30;
    float dx = obj2.position.x - obj1.position.x;
    float dy = obj2.position.y - obj1.position.y;
    if (! (dx > minDistance || dy > minDistance) ) {
        float actualDistance = sqrt( dx * dx + dy * dy );
        return (actualDistance <= minDistance);
    }
    return NO;
}
-(void) targetHit {
    if (targetHit == true) {
        // This should happen when the bullet is deleted.
                
        if (level == 1) {
            gameSegment++;
            if (gameSegment >= 7) {
                level++;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 2) {
            gameSegment++;
            if (gameSegment >= 6) {
                level++;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 3) {
            gameSegment++;
            if (gameSegment >= 6) {
                level++;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 4) {
            gameSegment++;
            if (gameSegment >= 9) {
                level++;
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        } else if (level == 5) {
            gameSegment++;
            if (gameSegment >= 9) {
                [self gameEnd];
                [self removeChild:boss cleanup:YES];
            }
        }
        for(int i = 0; i < [bullets count]; i++) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
        }
        [bullets removeAllObjects];
        
        player.position = ccp(screenCenter.x,screenCenter.y - 200);
        //  [[CCDirector sharedDirector] pushScene: [CCTransitionCrossFade transitionWithDuration:0.5f scene:[LevelSelect node]]];
    } else if (targetHit == false) {
        
    }
}
-(void) detectCollisions
{
    if (CGRectIntersectsRect(CGRectMake(player.position.x, player.position.y, playerWidth, playerHeight), CGRectMake(boss.position.x, boss.position.y, bossWidth, bossHeight)) == true) {
        targetHit = true;
        [self targetHit];
    }
    
    if (CGRectIntersectsRect(CGRectMake(player.position.x, player.position.y, playerWidth, playerHeight), CGRectMake(shield.position.x, shield.position.y, shield.boundingBox.size.width, shield.boundingBox.size.height)) == true) {
//        [powerups removeAllObjects];
//        [self removeChild:shield cleanup:YES];
    }
    
    for(int i = 0; i < [bullets count]; i++) {
        NSInteger j = i;
        CCSprite* tempSprite = [bullets objectAtIndex:j];
        if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
            if(shieldon == true) {
                [self removeChild:tempSprite cleanup:YES];
                [bullets removeObjectAtIndex:i];
                [self removeChild:shield cleanup:YES];
                [self deleteubershield];
                shieldon = false;
                if([[NSUserDefaults standardUserDefaults]boolForKey:@"protection"] == false) {
                    [MGWU showMessage:@"Achievement Get!      Chicken Blocked" withImage:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"protection"];
                }
            }
            else if(ubershieldon == true) {
                [self removeChild:shield cleanup:YES];
                [self deleteubershield];
                [self removeChild:tempSprite cleanup:YES];
                [bullets removeObjectAtIndex:i];
                if([[NSUserDefaults standardUserDefaults]boolForKey:@"protection"] == false) {
                    [MGWU showMessage:@"Achievement Get!      Temp Inviniciblity" withImage:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"protection"];
                }
            }
            else {
                [self playerdeathstart];
            }
        }
    }
    for(int i = 0; i < [flowerbullets count]; i++) {
        NSInteger j = i;
        CCSprite* tempSprite = [flowerbullets objectAtIndex:j];
        if ([self isCollidingSphere:tempSprite WithSphere:player] == true) {
            if(shieldon == true) {
                [self removeChild:tempSprite cleanup:YES];
                [flowerbullets removeObjectAtIndex:i];
                [self removeChild:shield cleanup:YES];
                shieldon = false;
                if([[NSUserDefaults standardUserDefaults]boolForKey:@"protection"] == false) {
                    [MGWU showMessage:@"Achievement Get!      Chicken Blocked" withImage:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"protection"];
                }
            }
            if(ubershieldon == true) {
                [self removeChild:tempSprite cleanup:YES];
                [flowerbullets removeObjectAtIndex:i];
                if([[NSUserDefaults standardUserDefaults]boolForKey:@"protection"] == false) {
                    [MGWU showMessage:@"Achievement Get!      Chicken Blocked" withImage:nil];
                    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"protection"];
                }
            }
            else{
                [self playerdeathstart];
            }
        }
    }
    for(int i = 0; i < [fakebullets count]; i++) {
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
                if(bwooo == false) {
                    //[[SimpleAudioEngine sharedEngine] playEffect:@"bwooo.mp3"];
                    bwooo = true;
                }
            }
        }
    }
    for(int i = 0; i < [powerups count];i++) {
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
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"shield"] == false) {
                [MGWU showMessage:@"Achievement Get!      Green is the new Orange" withImage:nil];
                [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"shield"];
            }
        }
    }
}
/* -------------------------------------------------------------------------------- */
/*    USEFUL CODE TO MAKE MY LIFE EASIER                                            */
/* -------------------------------------------------------------------------------- */
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
        glClearColor(0, 0, 0, 255);
        NSLog(@"ok, go.");
    }
    else {
        glClearColor(255, 255, 255, 255);
        NSLog(@"ok, go2.");
    }
}
-(void) setDimensionsInPixelsGraduallyOnSprite:(CCSprite *) spriteToSetDimensions width:(int) width height:(int) height {
    float scaleXDimensions = width/[spriteToSetDimensions boundingBox].size.width;
    float scaleYDimensions = height/[spriteToSetDimensions boundingBox].size.height;
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
        if([[NSUserDefaults standardUserDefaults]boolForKey:@"doom"] == false) {
            [MGWU showMessage:@"Achievement Get!      Fall of the Orange" withImage:nil];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"doom"];
        }
    }
}
-(void) pause {
    [[CCDirector sharedDirector] pushScene:
     [CCTransitionCrossFade transitionWithDuration:0.5f scene:[Pausue node]]];
}
-(void) playerdeathstart {
    if(deathanimation == true) {
        [self flash:255 green:0 blue:0 alpha:255 actionWithDuration:0];
        [self schedule:@selector(scalePlayer) interval:0.5];
        deathanimation = false;
    }
}
-(void) scalePlayer {
    [self unschedule:@selector(scalePlayer)];
    id tintp = [CCTintTo actionWithDuration:0.5 red:68 green:68 blue:255];
    id scalep = [CCScaleTo actionWithDuration:0.5 scale:5];
    [player runAction:tintp];
    [player runAction:scalep];
    [self schedule:@selector(playerdeath) interval:0.5];
}
-(void) playerdeath {
    isDying = true;
    [self unschedule:@selector(playerdeath)];
    [self unscheduleUpdate];
    NSLog(@"player died");
    border = [CCSprite spriteWithFile:@"continue.png"];
    border.position = ccp(160,240);
    [self addChild:border z:9010];
    //background
    gameOverLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 0) width: 200 height: 238];
    gameOverLayer.position = ccp(40, 95);
    [self addChild: gameOverLayer z:9010];
    NSString* coinsl = @"Coins: ";
    NSString* coincount = [coinsl stringByAppendingString:[NSString stringWithFormat:@"%i",coins]];
    gameOver1 = [CCLabelTTF labelWithString:coincount fontName:@"HelveticaNeue-Light" fontSize:40];
    gameOver1.position = ccp(160, 320);
    [self addChild:gameOver1 z:9011];
    coinLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",coins] fontName:@"HelveticaNeue-Light" fontSize:75];
    coinLabel.position = ccp(240, 300);
    //[self addChild:coinLabel z:9011];
    NSString* hello = @"";
    NSString*  world= @"";
    NSString*  helloWorld= @"";
    NSString*  burpworld= @"";
    NSString*  coinc= @"";
    hello = @"Continue for ";
    world = [NSString stringWithFormat:@"%d",continueCost];
    helloWorld = [hello stringByAppendingString:world];
    burpworld = @" coins.";
    coinc = [helloWorld stringByAppendingString:burpworld];
    gameOver2 = [CCLabelTTF labelWithString:coinc fontName:@"HelveticaNeue-Light" fontSize:30];
    gameOver2.position = ccp(160, 55);
    [self addChild:gameOver2 z:9011];
    //gameOver.color=ccc3(0,0,0);
    continuePressed = [CCLabelTTF labelWithString:@"Continue" fontName:@"HelveticaNeue-Light" fontSize:24];
    continuePressed.position = ccp(screenSize.width/2, screenSize.height/2 - 5);
    continuePressed.color = ccc3(52,73,94);
    [self addChild:continuePressed z:9012];
    
    dieLabel = [CCLabelTTF labelWithString:@"Give Up" fontName:@"HelveticaNeue-Light" fontSize:24];
    dieLabel.position = ccp(screenSize.width/2, screenSize.height/2 - 80);
    dieLabel.color = ccc3(52,73,94);
    [self addChild:dieLabel z:9012];
    CCMenuItemImage* continueButton = [CCMenuItemImage itemWithNormalImage:@"button.png" selectedImage:@"button-sel.png" target:self selector:@selector(continuee)];    
    CCMenuItemImage* dieButton = [CCMenuItemImage itemWithNormalImage:@"button.png" selectedImage:@"button-sel.png" target:self selector:@selector(gameover)];

    GameOverMenu = [CCMenu menuWithItems: continueButton, dieButton, nil];
    [GameOverMenu alignItemsVerticallyWithPadding:10.0];
    GameOverMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 40);
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
-(void) purchased {}
-(void) updateCoins {
    coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
    [coinLabel setString:[NSString stringWithFormat:@"%i",coins]];
}
-(void) boughtProduct {
    id tintp = [CCTintTo actionWithDuration:0.5 red:247 green:147 blue:29];
    id scalep = [CCScaleTo actionWithDuration:0.5 scale:0.15];
    [player runAction:tintp];
    [player runAction:scalep];
    deathanimation = true;
    //[self removeChild:countdown];
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
    for(int i = 0; i < [bullets count]; i++) {
        Bullet *temp = [bullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        //  [bullets removeObjectAtIndex:j];
        //[bulletDirection removeObjectAtIndex:j];
        //[bulletSpeed removeObjectAtIndex:j];
    }
    [bullets removeAllObjects];
    for(int i = 0; i < [flowerbullets count]; i++) {
        Bullet *temp = [flowerbullets objectAtIndex:i];
        [self removeChild:temp cleanup:YES];
        //  [bullets removeObjectAtIndex:j];
        //[bulletDirection removeObjectAtIndex:j];
        //[bulletSpeed removeObjectAtIndex:j];
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