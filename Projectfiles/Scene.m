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
        // Some variables to make positioning more easy
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = ccp(size.width/2, size.height/2);
    
        CCSprite *background = [CCSprite spriteWithFile:@"levelbg.png"];
        background.position = ccp(screenCenter.x,screenCenter.y);
        [self addChild:background];
        // Different BG for iPhone 5
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1136){
            CCSprite *background = [CCSprite spriteWithFile:@"levelbg-568h.png"];
            background.position = ccp(screenCenter.x,screenCenter.y);
            [self addChild:background];
        }
        
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 0) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 1) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 2) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 3) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"4.png" selectedImage:@"4-sel.png" target:self selector:@selector(level4)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 4) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"4.png" selectedImage:@"4-sel.png" target:self selector:@selector(level4)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"5.png" selectedImage:@"5-sel.png" target:self selector:@selector(level5)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 5) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"4.png" selectedImage:@"4-sel.png" target:self selector:@selector(level4)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"5.png" selectedImage:@"5-sel.png" target:self selector:@selector(level5)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"6.png" selectedImage:@"6-sel.png" target:self selector:@selector(level6)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 6) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"4.png" selectedImage:@"4-sel.png" target:self selector:@selector(level4)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"5.png" selectedImage:@"5-sel.png" target:self selector:@selector(level5)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"6.png" selectedImage:@"6-sel.png" target:self selector:@selector(level6)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"7.png" selectedImage:@"7-sel.png" target:self selector:@selector(level7)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] == 7) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"4.png" selectedImage:@"4-sel.png" target:self selector:@selector(level4)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"5.png" selectedImage:@"5-sel.png" target:self selector:@selector(level5)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"6.png" selectedImage:@"6-sel.png" target:self selector:@selector(level6)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"7.png" selectedImage:@"7-sel.png" target:self selector:@selector(level7)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"8.png" selectedImage:@"8-sel.png" target:self selector:@selector(level8)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"locked.png" selectedImage:@"locked-sel.png" target:self selector:@selector(locked)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        if([[NSUserDefaults standardUserDefaults]integerForKey:@"boss"] >= 8) {
            CCMenuItemImage *level1 = [CCMenuItemImage itemWithNormalImage:@"1.png" selectedImage:@"1-sel.png" target:self selector:@selector(level1)];
            level1.position = ccp(screenCenter.x - 90, screenCenter.y + 100);
            level1.scale = 1.1f;
            CCMenu *levelOne = [CCMenu menuWithItems:level1, nil];
            levelOne.position = CGPointZero;
            [self addChild:levelOne];
            
            CCMenuItemImage *level2 = [CCMenuItemImage itemWithNormalImage:@"2.png" selectedImage:@"2-sel.png" target:self selector:@selector(level2)];
            level2.position = ccp(screenCenter.x, screenCenter.y + 100);
            level2.scale = 1.1f;
            CCMenu *levelTwo = [CCMenu menuWithItems:level2, nil];
            levelTwo.position = CGPointZero;
            [self addChild:levelTwo];
            
            CCMenuItemImage *level3 = [CCMenuItemImage itemWithNormalImage:@"3.png" selectedImage:@"3-sel.png" target:self selector:@selector(level3)];
            level3.position = ccp(screenCenter.x + 90, screenCenter.y + 100);
            level3.scale = 1.1f;
            CCMenu *levelThree = [CCMenu menuWithItems:level3, nil];
            levelThree.position = CGPointZero;
            [self addChild:levelThree];
            
            CCMenuItemImage *level4 = [CCMenuItemImage itemWithNormalImage:@"4.png" selectedImage:@"4-sel.png" target:self selector:@selector(level4)];
            level4.position = ccp(screenCenter.x - 90, screenCenter.y);
            level4.scale = 1.1f;
            CCMenu *levelFour = [CCMenu menuWithItems:level4, nil];
            levelFour.position = CGPointZero;
            [self addChild:levelFour];
            
            CCMenuItemImage *level5 = [CCMenuItemImage itemWithNormalImage:@"5.png" selectedImage:@"5-sel.png" target:self selector:@selector(level5)];
            level5.position = ccp(screenCenter.x, screenCenter.y);
            level5.scale = 1.1f;
            CCMenu *levelFive = [CCMenu menuWithItems:level5, nil];
            levelFive.position = CGPointZero;
            [self addChild:levelFive];
            
            CCMenuItemImage *level6 = [CCMenuItemImage itemWithNormalImage:@"6.png" selectedImage:@"6-sel.png" target:self selector:@selector(level6)];
            level6.position = ccp(screenCenter.x + 90, screenCenter.y);
            level6.scale = 1.1f;
            CCMenu *levelSix = [CCMenu menuWithItems:level6, nil];
            levelSix.position = CGPointZero;
            [self addChild:levelSix];
            
            CCMenuItemImage *level7 = [CCMenuItemImage itemWithNormalImage:@"7.png" selectedImage:@"7-sel.png" target:self selector:@selector(level7)];
            level7.position = ccp(screenCenter.x - 90, screenCenter.y - 100);
            level7.scale = 1.1f;
            CCMenu *levelSeven = [CCMenu menuWithItems:level7, nil];
            levelSeven.position = CGPointZero;
            [self addChild:levelSeven];
            
            CCMenuItemImage *level8 = [CCMenuItemImage itemWithNormalImage:@"8.png" selectedImage:@"8-sel.png" target:self selector:@selector(level8)];
            level8.position = ccp(screenCenter.x, screenCenter.y - 100);
            level8.scale = 1.1f;
            CCMenu *levelEight = [CCMenu menuWithItems:level8, nil];
            levelEight.position = CGPointZero;
            [self addChild:levelEight];
            
            CCMenuItemImage *level9 = [CCMenuItemImage itemWithNormalImage:@"9.png" selectedImage:@"9-sel.png" target:self selector:@selector(level9)];
            level9.position = ccp(screenCenter.x + 90, screenCenter.y - 100);
            level9.scale = 1.1f;
            CCMenu *levelNine = [CCMenu menuWithItems:level9, nil];
            levelNine.position = CGPointZero;
            [self addChild:levelNine];
        }
        CCMenuItemImage *back3 = [CCMenuItemImage itemWithNormalImage:@"arrow.png" selectedImage:@"arrow-sel.png" target:self selector:@selector(unPause)];
        back3.position = ccp(screenCenter.x, screenCenter.y - 190);
        back3.scale = 1.1f;
        CCMenu *backmenu3 = [CCMenu menuWithItems:back3, nil];
        backmenu3.position = CGPointZero;
        [self addChild:backmenu3];

    }
    return self;
}
-(void) level1 {
    NSNumber *leveldata = [NSNumber numberWithInteger:1];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level2 {
    NSNumber *leveldata = [NSNumber numberWithInteger:2];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level3 {
    NSNumber *leveldata = [NSNumber numberWithInteger:3];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level4
{
    NSNumber *leveldata = [NSNumber numberWithInteger:4];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level5 {
    NSNumber *leveldata = [NSNumber numberWithInteger:5];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level6 {
    NSNumber *leveldata = [NSNumber numberWithInteger:6];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level7 {
    NSNumber *leveldata = [NSNumber numberWithInteger:7];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level8 {
    NSNumber *leveldata = [NSNumber numberWithInteger:8];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) level9 {
    NSNumber *leveldata = [NSNumber numberWithInteger:9];
    [[NSUserDefaults standardUserDefaults] setObject:leveldata forKey:@"leveldata"];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"endless"];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}
-(void) locked
{    
//    if([[NSUserDefaults standardUserDefaults]boolForKey:@"cheater"] == false)
//    {
//        [MGWU showMessage:@"Achievement Get!      That level is locked!" withImage:nil];
//        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"cheater"];
//    }
}

-(void) unPause
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInL transitionWithDuration:0.5f scene:[LevelSelect node]]];
}
@end