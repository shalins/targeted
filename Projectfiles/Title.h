//
//  Title.h
//  bullet hell-o
//
//  Created by Kevin Frans on 7/2/13.
//
//

#import "CCScene.h"

@interface Title : CCScene
{
    CCSprite* bullet;
    NSMutableArray *bullets;
    NSMutableArray *bulletDirection;
    NSMutableArray *bulletSpeed;
    CCSprite* projectile;
    int framespast;

    BOOL theLogs;
    BOOL isEndlessMode;
    BOOL isLevelMode;
    CCSprite* bluemove;
    CCSprite* orangemove;
    CGPoint screenCenter;
    CGSize size;
    CCSprite *myTitleLogo;
    CCMenu *menu;
    CCMenu *menu2;
    CCMenu *menutwo;
    CCMenu *menu3;
    CCLabelTTF *levelText;
    CCLabelTTF *endlessText;
    CCMenuItemSprite *playMenuItem;
    CCMenuItemSprite *leaderMenuItem;
    CCMenuItemImage *sound;
    CCMenuItemImage *soundOff;
    
    CCMenuItemImage *endless;
    CCMenuItemImage *level;
    CCMenu *endlessMenu;
    CCMenu *levelMenu;
    CCLabelTTF *levelModeText;
    CCLabelTTF *endlessModeText;

}

@end
