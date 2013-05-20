//
//  NailPolishInfo.h
//  colorMatch
//
//  Created by Nathan Levine on 5/16/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NailPolishInfo : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * redValue;
@property (nonatomic, retain) NSNumber * blueValue;
@property (nonatomic, retain) NSNumber * greenValue;
@property (nonatomic, retain) NSString * manufacturer;

@end
