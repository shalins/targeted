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
    CCSprite* bluemove;
    CCSprite* orangemove;
    CGPoint screenCenter;
    CGSize size;
    
    CCMenu *menu;
    CCMenu *menu2;
    CCMenuItemSprite *playMenuItem;
    CCMenuItemSprite *leaderMenuItem;
}

@end
