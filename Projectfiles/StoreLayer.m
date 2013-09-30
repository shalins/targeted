//
//  StoreLayer.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/10/13.
//
//

#import "StoreLayer.h"
#import "HelloWorldLayer.h"

@implementation StoreLayer

int numPowerUp1;
int numPowerUp2;

int coins;
NSString *CoinString;
CCLabelBMFont *coinsLabel;

-(id) init
{
	if ((self = [super init]))
	{
        CCSprite* background = [CCSprite spriteWithFile:@"blank.png"];
        background.position = ccp(screenCenter.x,screenCenter.y);
        [self addChild:background z:-1000];
        
        screenSize = [[CCDirector sharedDirector] winSize];
        screenCenter = CGPointMake(screenSize.width/2, screenSize.height/2);
        
        int CoinNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        coins = CoinNumber;
        CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
        coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"HelveticaNeue-Light" fontSize:28];
        coinsLabel.position = ccp(screenSize.width/2, screenSize.height - 145);
        [self addChild:coinsLabel];
        
        CCMenuItemImage *buyMoney1 = [CCMenuItemImage itemWithNormalImage:@"coins1.png" selectedImage:@"coins1-sel.png" target:self selector:@selector(buyCash1)];
        CCMenuItemImage *buyMoney2 = [CCMenuItemImage itemWithNormalImage:@"coins2.png" selectedImage:@"coins2-sel.png" target:self selector:@selector(buyCash2)];
        CCMenuItemImage *buyMoney3 = [CCMenuItemImage itemWithNormalImage:@"coins3.png" selectedImage:@"coins3-sel.png" target:self selector:@selector(buyCash3)];
        
        CCSprite* header = [CCSprite spriteWithFile:@"store.png"];
        header.position = ccp(screenSize.width/2,screenSize.height / 1.2);
        header.scale = 1.3;
        [self addChild:header];
        
        CCMenu *moneyVendor = [CCMenu menuWithItems:buyMoney1, buyMoney2, buyMoney3, nil];
        moneyVendor.position = ccp(screenSize.width/2, screenSize.height/2 - 45);
        [moneyVendor alignItemsVerticallyWithPadding:12];
        [self addChild:moneyVendor];
        
        CCMenuItemImage *leaveButton = [CCMenuItemImage itemWithNormalImage:@"leaveButton.png" selectedImage:@"leaveButton-sel.png" target:self selector:@selector(goHome)];
        leaveButton.scale = 0.8f;
        
        CCMenu *leaveMenu = [CCMenu menuWithItems:leaveButton, nil];
        leaveMenu.position = ccp(screenSize.width/2, screenSize.height/7.5);
        [self addChild:leaveMenu];
        
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1024 || [[CCDirector sharedDirector] winSizeInPixels].height == 2048){
            buyMoney1.scale = 1.5;
            buyMoney2.scale = 1.5;
            buyMoney3.scale = 1.5;
            leaveButton.scale = 1.3;
            [moneyVendor alignItemsVerticallyWithPadding:12.0f]; }
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) buyCash1 {
    [MGWU testBuyProduct:@"com.shalinshah.100" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void) buyCash2 {
    [MGWU testBuyProduct:@"com.shalinshah.250" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void) buyCash3 {
    [MGWU testBuyProduct:@"com.shalinshah.500" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) boughtProduct:(NSString*) powerupToBuy {
    NSLog(@"Something was Bought!");
    [MGWU showMessage:@"Purchase Successful" withImage:nil];
    if ([powerupToBuy isEqualToString:@"com.shalinshah.100"] == true) {
        NSLog(@"100 Coins added!");
        coins += 100;
        //NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setInteger:coins forKey:@"coins"];
    }
    if ([powerupToBuy isEqualToString:@"com.shalinshah.250"] == true) {
        NSLog(@"250 Coins added!");
        coins += 250;
        //NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setInteger:coins forKey:@"coins"];
        
    }
    if ([powerupToBuy isEqualToString:@"com.shalinshah.500"] == true) {
        NSLog(@"500 Coins added!");
        coins += 500;
        //NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setInteger:coins forKey:@"coins"];
    }
}
-(void) goHome {
    [[CCDirector sharedDirector] popScene];
}
-(void) update:(ccTime)delta {
    CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
    [coinsLabel setString:CoinString];
}

@end