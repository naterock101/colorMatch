//
//  NLNailPolish.h
//  colorMatch
//
//  Created by Nathan Levine on 5/11/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NLNailPolish : NSObject
{
    
}

- (id)initWithLabValuesL:(float)labl A:(float)laba B:(float)labb andName: (NSString *)name2 andRed: (int)red2 andGreen: (int)green2 andBlue: (int)blue2;

@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) float labL;
@property (nonatomic) float labA;
@property (nonatomic) float labB;
@property (nonatomic) int red;
@property (nonatomic) int green;
@property (nonatomic) int blue;

@end
