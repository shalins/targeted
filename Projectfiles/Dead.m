//
//  Dead.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/2/13.
//
//

#import "Dead.h"
#import "HelloWorldLayer.h"
#import "Title.h"
#import "LevelSelect.h"
#import "StatLayer.h"

@implementation Dead

-(id) init
{
    if ((self = [super init]))
    {
        
        // Some variables to make positioning more easy
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = ccp(size.width/2, size.height/2);
        
        glClearColor(255, 255, 255, 255);
        [self unscheduleAllSelectors];
        
        // have everything stop
        CCNode* node;
        CCARRAY_FOREACH([self children], node)
        {
            [node pauseSchedulerAndActions];
        }
        
        coins = [[NSUserDefaults standardUserDefaults] integerForKey:@"coins"];
        
        CCSprite* background = [CCSprite spriteWithFile:@"gameoverbg.png"];
        background.position = ccp(screenCenter.x,screenCenter.y);
        [self addChild:background z:-10000];
        
        // add the labels shown during game over
        //        score = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:@"score"]];
        
        //        // Game Over
        //        CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"HelveticaNeue-Light" fontSize:32];
        //        gameOver.position = CGPointMake((screenSize.width / 2)-60, 400);
        //        [self addChild:gameOver z:100 tag:100];
        //        // Score
        //        CCLabelTTF* gameOver2 = [CCLabelTTF labelWithString:score fontName:@"HelveticaNeue-Light" fontSize:30];
        //        gameOver2.position = CGPointMake((screenSize.width / 2)-60, 370);
        //        [self addChild:gameOver2 z:100 tag:100];
        
        // Display # of coins in stash
        NSString* world = [NSString stringWithFormat:@"you have %i coins.", coins];
        CCLabelTTF *coinLabel = [CCLabelTTF labelWithString:world fontName:@"HelveticaNeue-Medium" fontSize:25];
        coinLabel.position = ccp(screenCenter.x, screenCenter.y * 1.3);
        [self addChild:coinLabel z:9011];
        
        
        // Restart Button
        CCMenuItemImage *restartButton = [CCMenuItemImage itemWithNormalImage:@"restart.png" selectedImage:@"restart-sel.png" target:self selector:@selector(retry)];
        //        restartButton.position = ccp(screenCenter.x, screenCenter.y);
        restartButton.scale = 0.8f;
        if ([[CCDirector sharedDirector] winSizeInPixels].height == 1136){
            restartButton.scale = 0.9f;
        }
        // Back Button
        CCMenuItemImage *backButton = [CCMenuItemImage itemWithNormalImage:@"backarrow.png" selectedImage:@"backarrow-sel.png" target:self selector:@selector(quitGame)];
        //        backButton.position = ccp(screenCenter.x,screenCenter.y / 3);
        
        CCMenu *backmenu = [CCMenu menuWithItems:restartButton, backButton, nil];
        [backmenu alignItemsVerticallyWithPadding:7];
        backmenu.position = ccp(screenCenter.x, screenCenter.y / 1.7);
        [self addChild:backmenu];
        
        
        // Name Field
        //        nameField = [[UITextField alloc] initWithFrame:CGRectMake(35, 140, 260, 25)];
        //        [[[CCDirector sharedDirector] view] addSubview:nameField];
        //        nameField.delegate = self;
        //        nameField.placeholder = @"Tap to Enter Username";
        //        nameField.borderStyle = UITextBorderStyleRoundedRect;
        //        [nameField setReturnKeyType:UIReturnKeyDone];
        //        [nameField setAutocorrectionType:UITextAutocorrectionTypeNo];
        //        [nameField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        //        textField.visible = true;
        
        
        //        CCLabelTTF *fb = [CCMenuItemImage itemFromNormalImage:@"facebook.png" selectedImage:@"facebook.png" target:self selector:@selector(fb)];
        //        fb.position = ccp(size.width - 16, size.height - 16);
        //        fb.scale = 1;
        //        CCMenu *fbm = [CCMenu menuWithItems:fb, nil];
        //        fbm.position = CGPointZero;
        //        [self addChild:fbm];
        
        // [MGWU submitHighScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"score"] byPlayer:@"Player" forLeaderboard:@"defaultLeaderboard"];
        
    }
    return self;
}

-(void) quitGame
{
    //    [nameField removeFromSuperview];
    //    [nameField release];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:0.5f scene:[Title node]]];
}

-(void) sel
{
    //    [nameField removeFromSuperview];
    //    [nameField release];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[StatLayer node]]];
}

-(void) retry
{
    //    [nameField removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFlipX transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

//- (void)textFieldDidEndEditing:(UITextField*)textField
//{
//    if (textField == nameField && ![nameField.text isEqualToString:@""])
//    {
//        [nameField endEditing:YES];
//        [nameField removeFromSuperview];
//        // here is where you should do something with the data they entered
//        NSString *result = nameField.text;
//        //        username = result;
//        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"username"];
//        [MGWU submitHighScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"score"] byPlayer:result forLeaderboard:@"defaultLeaderboard"];
//    }
//}
//
//
//-(BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//	if (![nameField.text isEqualToString:@""])
//	{
//		//Hide keyboard when "done" clicked
//		[textField resignFirstResponder];
//		[nameField removeFromSuperview];
//		return YES;
//	}
//}

@end
