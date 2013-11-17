//
//  SlowDown.h
//  targeted
//
//  Created by Shalin Shah on 11/16/13.
//
//

#import "CCSprite.h"

@interface SlowDown : CCSprite
{
    float angle;
    float speed;
    
}



-(id) initWithValues: (float) speedIn: (float) angleIn;
-(float) getAngle;
-(float) getSpeed;
-(void) changeAngle: (float) angleIn;
-(void) changeSpeed: (float) speedIn;
+(id) slowedDown: (float) speedIn:(float) angleIn;


@end
