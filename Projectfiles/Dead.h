//
//  Dead.h
//  bullet hell-o
//
//  Created by Kevin Frans on 7/2/13.
//
//

#import "CCScene.h"

@interface Dead : CCScene
{
    int coins;
    UITextField* nameField;
    NSString* score;
    CGPoint screenCenter;
    CGSize size;
    
}
@end
