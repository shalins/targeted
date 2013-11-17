//
//  SlowDown.m
//  targeted
//
//  Created by Shalin Shah on 11/16/13.
//
//

#import "SlowDown.h"

@implementation SlowDown

+(id) slowedDown: (float) speedIn:(float) angleIn
{
    id powerup = [[self alloc] initWithValues:speedIn :angleIn];
    
    return powerup;
}

-(id) initWithValues: (float) speedIn:(float) angleIn
{
    if (self = [super initWithFile:@"cyan.png"])
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
