//
//  SmallerBall.h
//  targeted
//
//  Created by Shalin Shah on 11/16/13.
//
//

#import "CCSprite.h"

@interface SmallerBall : CCSprite
{
    float angle;
    float speed;
    
}



-(id) initWithValues: (float) speedIn: (float) angleIn;
-(float) getAngle;
-(float) getSpeed;
-(void) changeAngle: (float) angleIn;
-(void) changeSpeed: (float) speedIn;
+(id) smallBall: (float) speedIn:(float) angleIn;

@end