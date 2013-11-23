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
        
        size = [[CCDirector sharedDirector] winSize];
        screenCenter = CGPointMake(size.width/2, size.height/2);

        glClearColor(255, 255, 255, 255);
        [self unscheduleAllSelectors];
        
        // have everything stop
        CCNode* node;
        CCARRAY_FOREACH([self children], node)
        {
            [node pauseSchedulerAndActions];
        }
        
        
        CCSprite* background = [CCSprite spriteWithFile:@"sunbg.png"];
        background.position = screenCenter;
        [self addChild:background z:-10000];
        
        // add the labels shown during game over
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        score = [NSString stringWithFormat:@"%i", [[NSUserDefaults standardUserDefaults] integerForKey:@"score"]];
        
        // Game Over
        CCLabelTTF* gameOver = [CCLabelTTF labelWithString:@"Game Over" fontName:@"HelveticaNeue-Light" fontSize:32];
        gameOver.position = CGPointMake((screenSize.width / 2)-60, 400);
        [self addChild:gameOver z:100 tag:100];
        // Score
        CCLabelTTF* gameOver2 = [CCLabelTTF labelWithString:score fontName:@"HelveticaNeue-Light" fontSize:30];
        gameOver2.position = CGPointMake((screenSize.width / 2)-60, 370);
        [self addChild:gameOver2 z:100 tag:100];
        // Restart Button
        CCLabelTTF *highscore = [CCMenuItemImage itemFromNormalImage:@"reset.png" selectedImage:@"reset-sel.png" target:self selector:@selector(retry)];
        highscore.position = ccp(160, 200);
        highscore.scale = 0.9f;
        CCMenu *starMenu = [CCMenu menuWithItems:highscore, nil];
        starMenu.position = CGPointZero;
        [self addChild:starMenu];
        // High Score Button
        CCLabelTTF *boss = [CCMenuItemImage itemFromNormalImage:@"highscores.png" selectedImage:@"highscores-sel.png" target:self selector:@selector(sel)];
        boss.position = ccp(100, 80);
        boss.scale = 0.85f;
        CCMenu *moreMenu = [CCMenu menuWithItems:boss, nil];
        moreMenu.position = CGPointZero;
        [self addChild:moreMenu];
        // Back Button
        CCLabelTTF *back = [CCMenuItemImage itemFromNormalImage:@"back.png" selectedImage:@"back-sel.png" target:self selector:@selector(quitGame)];
        back.position = ccp(240, 80);
        back.scale = 0.5;
        CCMenu *backmenu = [CCMenu menuWithItems:back, nil];
        backmenu.position = CGPointZero;
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
        
        
        CCLabelTTF *fb = [CCMenuItemImage itemFromNormalImage:@"facebook.png" selectedImage:@"facebook.png" target:self selector:@selector(fb)];
        fb.position = ccp(size.width - 16, size.height - 16);
        fb.scale = 1;
        CCMenu *fbm = [CCMenu menuWithItems:fb, nil];
        fbm.position = CGPointZero;
//        [self addChild:fbm];
        
       // [MGWU submitHighScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"score"] byPlayer:@"Player" forLeaderboard:@"defaultLeaderboard"];
        
    }
    return self;
}

-(void) fblogin
{
    [MGWU loginToFacebook];
}
-(void) fb
{
    if([MGWU isFacebookActive])
    {
    NSString *myString = @"I just finished a run of Blue and got a score of ";
    NSString *test = [myString stringByAppendingString:score];
    [MGWU shareWithTitle:@"Blue" caption:[MGWU getUsername] andDescription:test];
    }
else{
    [self fblogin];
}
}

-(void) quitGame
{
    [nameField removeFromSuperview];
//    [nameField release];
    [[CCDirector sharedDirector] replaceScene:
     [CCTransitionSlideInL transitionWithDuration:0.5f scene:[Title node]]];
}

-(void) sel
{
    [nameField removeFromSuperview];
//    [nameField release];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:0.5f scene:[StatLayer node]]];
}

-(void) retry
{
    [nameField removeFromSuperview];
//    [nameField release];
    //    [[CCDirector sharedDirector] popSceneWithTransition:
    //       [CCTransitionCrossFade transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInT transitionWithDuration:0.5f scene:[HelloWorldLayer node]]];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField == nameField && ![nameField.text isEqualToString:@""])
    {
        [nameField endEditing:YES];
        [nameField removeFromSuperview];
        // here is where you should do something with the data they entered
        NSString *result = nameField.text;
        //        username = result;
        [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"username"];
        [MGWU submitHighScore:[[NSUserDefaults standardUserDefaults] integerForKey:@"score"] byPlayer:result forLeaderboard:@"defaultLeaderboard"];
    }
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if (![nameField.text isEqualToString:@""])
	{
		//Hide keyboard when "done" clicked
		[textField resignFirstResponder];
		[nameField removeFromSuperview];
		return YES;
	}
}

@end

