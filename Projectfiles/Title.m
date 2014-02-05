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
#import "Bullet.h"

@implementation Title

int coins;

-(id) init
{
    if ((self = [super init]))
    {
            int numTimesPlayed = [[NSUserDefaults standardUserDefaults] objectForKey:@"numTimesPlayed"];
            numTimesPlayed++;
            [[NSUserDefaults standardUserDefaults] setInteger:numTimesPlayed forKey:@"numTimesPlayed"];
            coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
        
            // NSLogging Switch
            theLogs = TRUE;
        
            // Some variables to make positioning more easy
            size = [[CCDirector sharedDirector] winSize];
            screenCenter = ccp(size.width/2, size.height/2);

            // Background Sprite
            CCSprite *background = [CCSprite spriteWithFile:@"mainmenubg.png"];
            background.position = screenCenter;
            [self addChild:background z:-500];
            CCSprite *blurry = [CCSprite spriteWithFile:@"blurry.png"];
            blurry.position = screenCenter;
            [self addChild:blurry z:-1001];
            CCSprite *title = [CCSprite spriteWithFile:@"text.png"];
            title.position = screenCenter;
            [self addChild:title z:0];
        
            // Play Button
            CCMenuItemImage *start = [CCMenuItemImage itemWithNormalImage:@"start.png" selectedImage:@"start-sel.png" target:self selector:@selector(unPause)];
            menu = [CCMenu menuWithItems:start, nil];
            menu.position = ccp(screenCenter.x,screenCenter.y);
            [self addChild:menu];

            bullets = [[NSMutableArray alloc] init];
        
        
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
            endlessMenu.position = ccp(screenCenter.x - 105,screenCenter.y);
            [self addChild:endlessMenu];
            isEndlessMode = TRUE;
        
            level = [CCMenuItemImage itemWithNormalImage:@"level.png" selectedImage:@"level-sel.png" target:self selector:@selector(levelSelected)];
            levelMenu = [CCMenu menuWithItems:level, nil];
            levelMenu.position = ccp(screenCenter.x + 105,screenCenter.y);
            [self addChild:levelMenu];
        
            levelModeText = [CCLabelTTF labelWithString:@"LEVEL MODE" fontName:@"HelveticaNeue" fontSize:25];
            levelModeText.position = ccp(screenCenter.x * 4, (screenCenter.y * 3) / 5);
//            [self addChild:levelModeText];
            endlessModeText = [CCLabelTTF labelWithString:@"ENDLESS MODE" fontName:@"HelveticaNeue" fontSize:25];
            endlessModeText.position = ccp(screenCenter.x * (-4), (screenCenter.y * 3) / 5);
//            [self addChild:endlessModeText];
        
            levelText = [CCLabelTTF labelWithString:@"LEVEL" fontName:@"HelveticaNeue" fontSize:15];
            levelText.position = ccp(screenCenter.x + 105,screenCenter.y + 35);
            [self addChild:levelText];
            endlessText = [CCLabelTTF labelWithString:@"ENDLESS" fontName:@"HelveticaNeue" fontSize:15];
            endlessText.position = ccp(screenCenter.x - 105,screenCenter.y + 35);
            [self addChild:endlessText];
        
            // Sounds
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"select.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"complete.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"correct.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"correctv2.mp3"];
            [[SimpleAudioEngine sharedEngine] preloadEffect:@"died.mp3"];
            if([[NSUserDefaults standardUserDefaults]boolForKey:@"musicon"] == TRUE) {
                [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
            }
            framespast = 0;
        // Set everything to be invisible
        menu.visible = NO;
        menu2.visible = NO;
        menu3.visible = NO;
        menutwo.visible = NO;
        endlessMenu.visible = NO;
        levelMenu.visible = NO;
        levelText.visible = NO;
        endlessText.visible = NO;

        // Animations
        [self goUp:title];
        [self fadeEffect:menu];
        [self fadeEffect:menu2];
        [self fadeEffect:menutwo];
        [self fadeEffect:menu3];
        [self fadeEffect:endlessMenu];
        [self fadeEffect:levelMenu];
        [self fadeEffect:levelText];
        [self fadeEffect:endlessText];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta
{
    // Remove all the bullets after they move off the screen
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        CCSprite* shalinbullet = [bullets objectAtIndex:i];
        if(shalinbullet.position.x > size.width + 50) {
            Bullet *temp = [bullets objectAtIndex:i];
            [self removeChild:temp cleanup:YES];
            [bullets removeObjectAtIndex:i];        }
        if(shalinbullet.position.x < (size.width / 10) - 50) {
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
    framespast++;
    [self shootSomeBullets];
}

-(void) shootSomeBullets {
    if((framespast % 115) ==0) {
        [self shootBullet:1 angle:230];
        [self shootBullet:2 angle:270];
        [self shootBullet:1 angle:310];
    }
    [self moveBullet];
}

-(void) moveBullet {
    //move the bullets
    for(NSUInteger i = 0; i < [bullets count]; i++) {
        NSInteger j = i;
        projectile = [bullets objectAtIndex:j];
        float angle = [[bullets objectAtIndex:j] getAngle];
        float speed = [[bullets objectAtIndex:j] getSpeed]; // Move 50 pixels in 60 frames (1 second)
        // For the slow-down powerup
        float vx = cos(angle * M_PI / 180) * speed;
        float vy = sin(angle * M_PI / 180) * speed;
        CGPoint direction = ccp(vx,vy);
        projectile.position = ccpAdd(projectile.position, direction);
    }
}
-(void) shootBullet: (float) speed angle:(float) angleInput {
    Bullet *newB = [Bullet bullet:speed :angleInput];
    newB.position = ccp(screenCenter.x, screenCenter.y * 1.5);
    [self addChild:newB z:-501];
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
    newB.position = ccp(newB.position.x + xInput, newB.position.y + yInput);
    [self addChild:newB z:9];
    [bullets addObject:newB];
    newB.scale = 0;
    id scale = [CCScaleTo actionWithDuration:1.0f scale:0.2f];
    [newB runAction:scale];
}
-(void) turnOnSound {
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"musicon"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self removeChild:sound cleanup:YES];
    [self removeChild:menu2 cleanup:YES];
    soundOff = [CCMenuItemImage itemWithNormalImage:@"music-not.png" selectedImage:@"music-not-sel.png" target:self selector:@selector(turnOnSound)];
    soundOff.scale = 1.1;
    menutwo = [CCMenu menuWithItems:soundOff, nil];
    menutwo.position = ccp(screenCenter.x - 33,screenCenter.y / 5);
    [self addChild:menutwo];
}
-(void) endlessSelected {
    isEndlessMode = TRUE;
    isLevelMode = FALSE;
    [self removeChild:endless cleanup:YES];
    [self removeChild:endlessMenu cleanup:YES];
    [self removeChild:level cleanup:YES];
    [self removeChild:levelMenu cleanup:YES];
    if (isEndlessMode == TRUE) {
        [self fadeEffect:endlessModeText];
    } else {
    }
    endless = [CCMenuItemImage itemWithNormalImage:@"endless-sel.png" selectedImage:@"endless-sel.png" target:self selector:@selector(endlessSelected)];
    endlessMenu = [CCMenu menuWithItems:endless, nil];
    endlessMenu.position = ccp(screenCenter.x - 105,screenCenter.y);
    [self addChild:endlessMenu];
    level = [CCMenuItemImage itemWithNormalImage:@"level.png" selectedImage:@"level-sel.png" target:self selector:@selector(levelSelected)];
    levelMenu = [CCMenu menuWithItems:level, nil];
    levelMenu.position = ccp(screenCenter.x + 105,screenCenter.y);
    [self addChild:levelMenu];
}
-(void) levelSelected {
    isEndlessMode = FALSE;
    isLevelMode = TRUE;
    [self removeChild:endless cleanup:YES];
    [self removeChild:endlessMenu cleanup:YES];
    [self removeChild:level cleanup:YES];
    [self removeChild:levelMenu cleanup:YES];
    if (isLevelMode == TRUE) {
        [self fadeEffect:levelModeText];
    } else {
    }
    level = [CCMenuItemImage itemWithNormalImage:@"level-sel.png" selectedImage:@"level-sel.png" target:self selector:@selector(levelSelected)];
    levelMenu = [CCMenu menuWithItems:level, nil];
    levelMenu.position = ccp(screenCenter.x + 105,screenCenter.y);
    [self addChild:levelMenu];
    endless = [CCMenuItemImage itemWithNormalImage:@"endless.png" selectedImage:@"endless-sel.png" target:self selector:@selector(endlessSelected)];
    endlessMenu = [CCMenu menuWithItems:endless, nil];
    endlessMenu.position = ccp(screenCenter.x - 105,screenCenter.y);
    [self addChild:endlessMenu];
}
-(void) settings
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.5f scene:[Settings node]]];
}
-(void) unPause
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"musicon"] == TRUE) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"select.mp3"];
    }
    if (isLevelMode == TRUE) {
        [[CCDirector sharedDirector] replaceScene: [CCTransitionSlideInR transitionWithDuration:0.5f scene:[Scene node]]];
    } else if (isEndlessMode == TRUE) {
        NSNumber *leveldata = [NSNumber numberWithInteger:1];
        [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"endless"];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    }
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"numTimesPlayed"] == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:(coins + 15) forKey:@"coins"];
    }
}
-(void) addStuffIn {
    menu.visible = YES;
    menu2.visible = YES;
    menu3.visible = YES;
    menutwo.visible = YES;
    endlessMenu.visible = YES;
    levelMenu.visible = YES;
    levelText.visible = YES;
    endlessText.visible = YES;
}
-(void) goUp:(CCSprite *) spriteToBeTheNextBigThing {
    id dropdown = [CCMoveTo actionWithDuration:0.8f position:ccp(screenCenter.x, screenCenter.y * 1.7)];
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:dropdown, nil]];
}
-(void) fadeEffect:(CCMenu *) spriteToBeTheNextBigThing {
    id delay = [CCDelayTime actionWithDuration:1.35];
    id addStuffIn = [CCCallFunc actionWithTarget:self selector:@selector(addStuffIn)];
    id fadeIn = [CCFadeIn actionWithDuration:2.0f];
    [spriteToBeTheNextBigThing runAction:[CCSequence actions:delay,addStuffIn,fadeIn, nil]];
}
@end