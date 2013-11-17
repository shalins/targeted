
//
//  High.m
//  bullet hell-o
//
//  Created by Kevin Frans on 7/9/13.
//
//

#import "High.h"
#import "Title.h"
#import "HelloWorldLayer.h"
#import "LeaderBoardPlayer.h"

@implementation High

CGSize screenSize;

-(id) init
{
    if ((self = [super init]))
    {
        glClearColor(255, 255, 255, 255);
        screenSize = [[CCDirector sharedDirector] winSize];
        CGPoint screenCenter = [[CCDirector sharedDirector] screenCenter];
        CCLabelBMFont *gameTitle = [CCLabelTTF labelWithString:@"USER STATS" fontName:@"Bend2SquaresBRK" fontSize:28];
        gameTitle.color = ccc3(0,0,0);
        gameTitle.position = ccp(screenCenter.x, screenCenter.y + 210);
        [self addChild:gameTitle];
        
        [MGWU submitHighScore:50 byPlayer:@"BobbyJoe" forLeaderboard:@"defaultLeaderboard"];

        [self getScores];
        
        CCLabelTTF *back3 = [CCMenuItemImage itemFromNormalImage:@"back.png" selectedImage:@"back-sel.png" target:self selector:@selector(goHome)];
        back3.position = ccp(160, 80);
        back3.scale = 0.5;
        CCMenu *backmenu3 = [CCMenu menuWithItems:back3, nil];
        backmenu3.position = CGPointZero;
        [self addChild:backmenu3];
    }
}


-(void) goHome
{
    [[CCDirector sharedDirector] replaceScene:
	 [CCTransitionSlideInL transitionWithDuration:0.5f scene:[Title node]]];
    //        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}

-(void) getScores
{
    [MGWU getHighScoresForLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:)
                             onTarget:self];
}

-(void)receivedScores:(NSDictionary*)scores
{
    
    NSMutableArray *otherPlayers = [scores objectForKey:@"all"];
    int count = [otherPlayers count];
    
    for (int i = 0; i < count; i ++)
    {
        NSMutableDictionary *playerDict = [otherPlayers objectAtIndex:i];
        NSNumber * score = [playerDict objectForKey:@"score"];
        NSString *name = [playerDict objectForKey:@"name"];
        if (!name) {
            name = @"player";
        }
        //        NSNumber *rank = [playerDict objectForKey:@"rank"];
        NSNumber *rank = [NSNumber numberWithInt:i + 1];
        
        LeaderBoardPlayer *p = [[LeaderBoardPlayer alloc] init];
        p.name = name;
        p.score = score;
        p.rank = rank;
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@) %@ : %@", rank, name, score]
                                               fontName:@"NexaBold"
                                               fontSize:16];
        label.anchorPoint = ccp(0.0f,0.5f);
        label.position = ccp(screenSize.width / 2, screenSize.height - 55 - i * 20);
        label.color = ccc3(0, 0, 0);
        
        
        
        [self addChild:label z: 2];
        
        [allPlayers addObject:p];
    }
    
}
@end
