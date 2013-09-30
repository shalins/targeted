/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "cocos2d.h"
#import "Player.h"
#import "Pausue.h"
#import "Bullet.h"
#import "Powerup.h"
#import "Donkey.h"

// Device and Widescreen Detection
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
// iPhone
#define IS_IPHONE ( ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )  || ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone Simulator" ] ) )
#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )
// iPod Touch
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )
#define IS_IPOD_5 ( IS_IPOD && IS_WIDESCREEN )
// iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPAD_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

@interface HelloWorldLayer : CCLayer
{
    CCLabelTTF *levelOneLabel;
    CCLabelTTF *levelTwoLabel;
    CCLabelTTF *levelThreeLabel;
    CCLabelTTF *levelFourLabel;
    CCLabelTTF *levelFiveLabel;
    CCLabelTTF *levelSixLabel;
    CCLabelTTF *levelSevenLabel;
    CCLabelTTF *levelEightLabel;
    CCLabelTTF *levelNineLabel;
    CCLabelTTF *levelTenLabel;

	NSString* helloWorldString;
	NSString* helloWorldFontName;
	int helloWorldFontSize;
    CGPoint posTouchScreen;
    id movePlayer;
    CCSprite* boss;
    CGPoint playerpos;
    float touchangle;
    float fakebulletangle;
    CCSprite* bullet;
    CCSprite* fakebullet;
    NSMutableArray *bullets;
    NSMutableArray *bulletDirection;
    NSMutableArray *bulletSpeed;
    NSMutableArray *fakebullets;
    NSMutableArray *donkeys;
    NSMutableArray *powerups;
    NSMutableArray *flowerbullets;
    CCSprite* projectile;
    CCSprite* projectile2;
    int framespast;
    CCSprite* pausebutton;
    CCLabelTTF* label;
    CCLabelTTF* tut;
    NSString* score;
    int intScore;
    CCSprite* donkey;
    CCLayerColor* colorLayer;
    int level;
    bool bosstime;
    bool isDying;
    int attacktype;
    int tempattacktype;
    bool isTimeWarped;
    bool deathanimation;
    bool ubershieldon;
    bool shieldon;
    bool targetHit;
    BOOL playedTutorial;
    int redtint;
    int bluetint;
    int greentint;
    CCSprite* border;
    CCSprite* countdown;
    CCLayerColor* gameOverLayer;
    CCMenu*  GameOverMenu;
    CCLabelTTF* gameOver;
    CCLabelTTF* gameOver1;
    CCLabelTTF* gameOver2;
    CCLabelTTF* gameOver3;
    CCLabelTTF *dieLabel;
    CCLabelTTF *continuePressed;
    CCLabelBMFont* coinLabel;
    int continueCost;
    CCSprite *player;
    CCSprite *shield;
    CCDirector *director;
    CCSprite *obstacle;
    
    // get screen center and screen size
    CGPoint screenCenter;
    CGSize screenSize;    
}

@property (nonatomic, copy) NSString* helloWorldString;
@property (nonatomic, copy) NSString* helloWorldFontName;
@property (nonatomic) int helloWorldFontSize;

@end
