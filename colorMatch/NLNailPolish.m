//
//  NLNailPolish.m
//  colorMatch
//
//  Created by Nathan Levine on 5/11/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLNailPolish.h"

@implementation NLNailPolish
@synthesize company, name, labA, labB, labL;

- (id)initWithLabValuesL:(int)labl A:(int)laba B:(int)labb andName: (NSString *)name
{    
    self = [super init];
    if (self) {
        self.labL = labl;
        self.labA = laba;
        self.labB = labb;
        self.name = name;
    }
    return self;
}

@end
