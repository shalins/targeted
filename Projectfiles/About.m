//
//  About.m
//  targeted
//
//  Created by Shalin Shah on 11/27/13.
//
//

#import "About.h"

@implementation About

-(id) init
{
    if ((self = [super init]))
    {
        // Some variables to make positioning more easy
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = ccp(size.width/2, size.height/2);
        
        CCLabelTTF *settings = [CCLabelTTF labelWithString:@"ABOUT" fontName:@"HelveticaNeue-UltraLight" fontSize:55];
        settings.position = ccp(screenCenter.x, screenCenter.y * 1.7);
        [self addChild:settings];
        
        CCLayerColor* colorLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:colorLayer z:0];
        
//        CCMenuItemImage *about = [CCMenuItemImage itemWithNormalImage:@"about.png" selectedImage:@"about.png" target:self selector:@selector(resetGameData)];
        
        CCSprite *about = [CCSprite spriteWithFile:@"about.png"];
        [self addChild:about z:1];
        about.position = screenCenter;
        
        
    }
    return self;
}










@end