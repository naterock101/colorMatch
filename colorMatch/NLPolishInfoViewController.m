//
//  NLPolishInfoViewController.m
//  colorMatch
//
//  Created by Nathan Levine on 5/12/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLPolishInfoViewController.h"

@interface NLPolishInfoViewController ()

@end

@implementation NLPolishInfoViewController
@synthesize polishColor, polishName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //set up the polish color in the view
    viewForPolishColor.backgroundColor = polishColor;
    
    //set up the name as the title on the navbar
    self.title = polishName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
