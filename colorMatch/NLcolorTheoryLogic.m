//
//  NLcolorTheoryLogic.m
//  colorMatch
//
//  Created by Nathan Levine on 5/16/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLcolorTheoryLogic.h"

@implementation NLcolorTheoryLogic
{
    
}

+ (NSMutableArray *) convertRGBtoLABwithColor: (UIColor *)color
{
    //make variables to get rgb values
    CGFloat red3;
    CGFloat green3;
    CGFloat blue3;
    //get rgb of color
    [color getRed:&red3 green:&green3 blue:&blue3 alpha:nil];
    
    float red2 = (float)red3*255;
    float blue2 = (float)blue3*255;
    float green2 = (float)green3*255;
    
    //first convert RGB to XYZ
    
    // same values, from 0 to 1
    red2 = red2/255;
    green2 = green2/255;
    blue2 = blue2/255;
    
    // adjusting values
    if(red2 > 0.04045)
    {
        red2 = (red2 + 0.055)/1.055;
        red2 = pow(red2,2.4);
    } else {
        red2 = red2/12.92;
    }
    
    if(green2 > 0.04045)
    {
        green2 = (green2 + 0.055)/1.055;
        green2 = pow(green2,2.4);
    } else {
        green2 = green2/12.92;
    }
    
    if(blue2 > 0.04045)
    {
        blue2 = (blue2 + 0.055)/1.055;
        blue2 = pow(blue2,2.4);
    } else {
        blue2 = blue2/12.92;
    }
    
    red2 *= 100;
    green2 *= 100;
    blue2 *= 100;
    
    //make x, y and z variables
    float x;
    float y;
    float z;
    
    // applying the matrix to finally have XYZ
    x = (red2 * 0.4124) + (green2 * 0.3576) + (blue2 * 0.1805);
    y = (red2 * 0.2126) + (green2 * 0.7152) + (blue2 * 0.0722);
    z = (red2 * 0.0193) + (green2 * 0.1192) + (blue2 * 0.9505);
    
    //then convert XYZ to LAB
    
    x = x/95.047;
    y = y/100;
    z = z/108.883;
    
    // adjusting the values
    if(x > 0.008856)
    {
        x = powf(x,(1.0/3.0));
    } else {
        x = ((7.787 * x) + (16/116));
    }
    
    if(y > 0.008856)
    {
        y = pow(y,(1.0/3.0));
    } else {
        y = ((7.787 * y) + (16/116));
    }
    
    if(z > 0.008856)
    {
        z = pow(z,(1.0/3.0));
    } else {
        z = ((7.787 * z) + (16/116));
    }
    
    //make L, A and B variables
    float l;
    float a;
    float b;
    
    //finally have your l, a, b variables!!!!
    l = ((116 * y) - 16);
    a = 500 * (x - y);
    b = 200 * (y - z);
    
    NSNumber *lNumber = [NSNumber numberWithFloat:l];
    NSNumber *aNumber = [NSNumber numberWithFloat:a];
    NSNumber *bNumber = [NSNumber numberWithFloat:b];
    
    //add them to an array to return.
    NSMutableArray *labArray = [[NSMutableArray alloc] init];
    [labArray addObject:lNumber];
    [labArray addObject:aNumber];
    [labArray addObject:bNumber];
    
    return labArray;
}

#pragma mark CIE1994 comparison

+ (float)compareUsingCIE1994WithLab1l:(int)lab1l andLab1a:(int)lab1a andLab1b:(int)lab1b andLab2l:(int)lab2l andLab2a:(int)lab2a andLab2b:(int)lab2b
{
    float c1 = sqrt((lab1a*lab1a)+(lab1b*lab1b));
    float c2 = sqrt((lab2a*lab2a)+(lab2b*lab2b));
    float deltaC = c1 - c2;
    float deltaL = lab1l -  lab2l;
    float deltaA = lab1a -  lab2a;
    float deltaB = lab1b -  lab2b;
    float deltaH = sqrt((deltaA*deltaA)+(deltaB*deltaB)-(deltaC*deltaC));
    //float first = deltaL;
    float second = deltaC / (1+(0.045*c1));
    float third = deltaH / (1+(0.015*c1));
    float deltaE = sqrt((deltaL*deltaL)+(second*second)+(third*third));
    
    return deltaE;
}

#pragma mark compare Colors
+ (NLNailPolish *)compareColor:(UIColor*)color toDatabase: (NSArray *) colorArray
{
    //get the lab values
    NSMutableArray *labValuesArray = [self convertRGBtoLABwithColor:color];
    NSNumber *lnumber = [labValuesArray objectAtIndex:0];
    int lValue = [lnumber intValue];
    NSNumber *anumber = [labValuesArray objectAtIndex:1];
    int aValue = [anumber intValue];
    NSNumber *bnumber = [labValuesArray objectAtIndex:2];
    int bValue = [bnumber intValue];
    
    //make float variable to compare deltas
    float smallestDelta = 0;
    
    //make nailpolish to return
    NLNailPolish *polishToReturn = [[NLNailPolish alloc]init];
    
    for (NLNailPolish *polish in colorArray)
    {
        //do the comparison using CIE1994 formula
        float deltaEcomp = [self compareUsingCIE1994WithLab1l:lValue andLab1a:aValue andLab1b:bValue andLab2l:polish.labL andLab2a:polish.labA andLab2b:polish.labB];
        
        //find the closest match
        //if there is no delta yet (first omparison)
        if (smallestDelta == 0)
        {
            smallestDelta = deltaEcomp;
            polishToReturn = polish;
        }
        else
        {
            //check if its smaller than the smalest delta, if it is replace it and become the newest smallest delta
            if (deltaEcomp > smallestDelta)
            {
                smallestDelta = deltaEcomp;
                polishToReturn = polish;
            }
        }
    }
    return polishToReturn;
}


@end
