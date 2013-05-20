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
+ (float)compareUsingCIE1994WithLab1l:(float)lab1l andLab1a:(float)lab1a andLab1b:(float)lab1b andLab2l:(float)lab2l andLab2a:(float)lab2a andLab2b:(float)lab2b;
+ (NLNailPolish *)compareColor:(UIColor*)color toDatabase: (NSArray *) colorArray;



@end
