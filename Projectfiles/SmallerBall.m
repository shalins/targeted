//
//  SmallerBall.m
//  targeted
//
//  Created by Shalin Shah on 11/16/13.
//
//

#import "SmallerBall.h"

@implementation SmallerBall

+(id) smallBall: (float) speedIn:(float) angleIn
{
    id powerup = [[self alloc] initWithValues:speedIn :angleIn];
    
    return powerup;
}

-(id) initWithValues: (float) speedIn:(float) angleIn
{
    if (self = [super init])
    {
        speed = speedIn;
        angle = angleIn;
    }
    
    return self;
}

-(void) changeSpeed: (float) speedIn
{
    speed = speedIn;
}

-(void) changeAngle: (float) angleIn
{
    angle = angleIn;
}

-(float) getSpeed
{
    return speed;
}

-(float) getAngle
{
    return angle;
}

@end