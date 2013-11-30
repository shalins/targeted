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
    BOOL theLogs;
    
    CCSprite* bluemove;
    CCSprite* orangemove;
    CGPoint screenCenter;
    CGSize size;
    CCSprite *myTitleLogo;
    CCMenu *menu;
    CCMenu *menu2;
    CCMenu *menu3;
    CCMenuItemSprite *playMenuItem;
    CCMenuItemSprite *leaderMenuItem;
    CCMenuItemImage *sound;
}

@end
