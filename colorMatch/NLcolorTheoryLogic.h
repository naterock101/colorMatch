//
//  NLcolorTheoryLogic.h
//  colorMatch
//
//  Created by Nathan Levine on 5/16/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLNailPolish.h"


@interface NLcolorTheoryLogic : NSObject
{
    
}

+ (NSMutableArray *) convertRGBtoLABwithColor: (UIColor *)color;
+ (float)compareUsingCIE1994WithLab1l:(int)lab1l andLab1a:(int)lab1a andLab1b:(int)lab1b andLab2l:(int)lab2l andLab2a:(int)lab2a andLab2b:(int)lab2b;
+ (NLNailPolish *)compareColor:(UIColor*)color toDatabase: (NSArray *) colorArray;



@end
