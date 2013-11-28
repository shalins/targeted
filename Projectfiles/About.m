//
//  About.m
//  targeted
//
//  Created by Shalin Shah on 11/27/13.
//
//

#import "About.h"
#import "Settings.h"

@implementation About

-(id) init
{
    if ((self = [super init]))
    {
        // Some variables to make positioning more easy
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = ccp(size.width/2, size.height/2);

        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:colorLayer z:0];
        
        CCSprite *about = [CCSprite spriteWithFile:@"me.png"];
        [self addChild:about z:1];
        about.position = screenCenter;
        
        CCMenuItemImage *facebook = [CCMenuItemImage itemWithNormalImage:@"facebook.png" selectedImage:@"facebook.png" target:self selector:@selector(facebook)];
        facebook.scale = 0.6f;
        
        CCMenuItemImage *twitter = [CCMenuItemImage itemWithNormalImage:@"twitter.png" selectedImage:@"twitter.png" target:self selector:@selector(twitter)];
        twitter.scale = 0.6f;
        
        CCMenuItemImage *email = [CCMenuItemImage itemWithNormalImage:@"email.png" selectedImage:@"email.png" target:self selector:@selector(email)];
        email.scale = 0.6f;
        
        CCMenu *menu = [CCMenu menuWithItems:facebook, twitter, email, nil];
        [menu alignItemsHorizontallyWithPadding:8];
        menu.position = ccp(screenCenter.x,screenCenter.y * 1.4);
        [self addChild:menu];
        
        CCMenuItemImage *back = [CCMenuItemImage itemWithNormalImage:@"arrow.png" selectedImage:@"arrow-sel.png" target:self selector:@selector(back)];
        back.scale = 1.1f;
        CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = ccp(screenCenter.x,screenCenter.y / 3);
        [self addChild:backMenu];
        
    }
    return self;
}


-(void) facebook {
    NSURL *facebookURL = [NSURL URLWithString:@"https://www.facebook.com/getcenterapp"];
    [[UIApplication sharedApplication] openURL:facebookURL];
    
}

-(void) twitter {
    NSURL *twitterURL = [NSURL URLWithString:@"https://twitter.com/getcenter"];
    [[UIApplication sharedApplication] openURL:twitterURL];
}

-(void) email {
    NSURL *emailURL = [NSURL URLWithString:@"mailto:shalinvs@gmail.com"];
    [[UIApplication sharedApplication] openURL:emailURL];
}

-(void) back {
    [[CCDirector sharedDirector] replaceScene: [CCTransitionProgress transitionWithDuration:0.5f scene:[Settings node]]];
}


@end