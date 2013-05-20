//
//  NLNailPolish.m
//  colorMatch
//
//  Created by Nathan Levine on 5/11/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLNailPolish.h"

@implementation NLNailPolish
@synthesize company, name, labA, labB, labL, red, green, blue;

- (id)initWithLabValuesL:(float)labl A:(float)laba B:(float)labb andName: (NSString *)name2 andRed: (int)red2 andGreen: (int)green2 andBlue: (int)blue2
{    
    self = [super init];
    if (self) {
        self.labL = labl;
        self.labA = laba;
        self.labB = labb;
        self.name = name2;
        self.red = red2;
        self.green = green2;
        self.blue = blue2;
    }
    return self;
}

@end
