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
        CCSprite* background = [CCSprite spriteWithFile:@"storeback.png"];
        background.position = ccp(160,240);
        [self addChild:background];
        
        screenSize = [[CCDirector sharedDirector] winSize];
        
        int CoinNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
        //        NSNumber *endingHighScoreNumber = [MGWU objectForKey:@"sharedHighScore"];
        coins = CoinNumber;
        CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
        coinsLabel = [CCLabelTTF labelWithString:CoinString fontName:@"HelveticaNeue-Light" fontSize:28];
        coinsLabel.position = ccp(screenSize.width/2, screenSize.height - 145);
        [self addChild:coinsLabel];
        
                
        CCMenuItemImage *buyMoney1 = [CCMenuItemImage itemWithNormalImage:@"money1.png" selectedImage:@"money1-sel.png" target:self selector:@selector(buyCash1)];
        CCMenuItemImage *buyMoney2 = [CCMenuItemImage itemWithNormalImage:@"money2.png" selectedImage:@"money2-sel.png" target:self selector:@selector(buyCash2)];
        CCMenuItemImage *buyMoney3 = [CCMenuItemImage itemWithNormalImage:@"money3.png" selectedImage:@"money3-sel.png" target:self selector:@selector(buyCash3)];
        
        CCMenu *moneyVendor = [CCMenu menuWithItems:buyMoney1, buyMoney2, buyMoney3, nil];
        moneyVendor.position = ccp(screenSize.width/2, screenSize.height/2 - 45);
        [moneyVendor alignItemsVerticallyWithPadding:1.0f];
        [self addChild:moneyVendor];
        
        CCLabelTTF *restartLabel = [CCLabelTTF labelWithString:@"Leave" fontName:@"HelveticaNeue-Light" fontSize:22];
        restartLabel.position = ccp(screenSize.width/2, screenSize.height/2 - 200);
        restartLabel.color = ccc3(52,73,94);
        [self addChild:restartLabel z:9012];
        
        CCMenuItemImage *goBack = [CCMenuItemImage itemWithNormalImage:@"button.png" selectedImage:@"button-sel.png" target:self selector:@selector(goHome)];
        goBack.scale = 0.8f;
        
        CCMenu *backmenu2 = [CCMenu menuWithItems:goBack, nil];
        backmenu2.position = ccp(screenSize.width/2, screenSize.height/2 - 204);
        [self addChild:backmenu2];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void) buyCash1
{
    [MGWU testBuyProduct:@"com.kev.blu.100" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void) buyCash2
{
    [MGWU testBuyProduct:@"com.kev.blu.250" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void) buyCash3
{
    [MGWU testBuyProduct:@"com.kev.blu.500" withCallback:@selector(boughtProduct:) onTarget:self];
}

-(void) boughtProduct:(NSString*) powerupToBuy
{
    NSLog(@"Something was Bought!");
    [MGWU showMessage:@"Purchase Successful" withImage:nil];
    if ([powerupToBuy isEqualToString:@"com.kev.blu.100"] == true)
    {
        NSLog(@"100 Coins added!");
        coins += 100;
        //NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setInteger:coins forKey:@"coins"];
    }
    
    if ([powerupToBuy isEqualToString:@"com.kev.blu.250"] == true)
    {
        NSLog(@"250 Coins added!");
        coins += 250;
        //NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setInteger:coins forKey:@"coins"];
        
    }
    
    if ([powerupToBuy isEqualToString:@"com.kev.blu.500"] == true)
    {
        NSLog(@"500 Coins added!");
        coins += 500;
        //NSNumber *boughtCoinVal = [NSNumber numberWithInt:coins];
        [[NSUserDefaults standardUserDefaults] setInteger:coins forKey:@"coins"];
    }
}

-(void) goHome
{
    //glClearColor(0, 0, 0, 255);
    [[CCDirector sharedDirector] popScene];
}
-(void) update:(ccTime)delta
{
    CoinString = [[NSString alloc] initWithFormat:@"Coins: %i", coins];
    [coinsLabel setString:CoinString];
}

@end