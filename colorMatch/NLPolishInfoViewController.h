//
//  NLPolishInfoViewController.h
//  colorMatch
//
//  Created by Nathan Levine on 5/12/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLPolishInfoViewController : UIViewController
{
    
    __weak IBOutlet UIView *viewForPolishColor;
}

@property (strong, nonatomic) UIColor *polishColor;
@property (strong, nonatomic) NSString *polishName;

@end
