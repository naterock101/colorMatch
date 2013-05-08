//
//  NLManipulateColorViewController.m
//  colorMatch
//
//  Created by Nathan Levine on 5/6/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLManipulateColorViewController.h"
#import "NLViewController.h"

@interface NLManipulateColorViewController ()
{
    NLViewController *nlVC;
    UIViewController *viewController;
}

@end

@implementation NLManipulateColorViewController
@synthesize colorToManipulate, delegate;

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

    // Do any additional setup after loading the view, typically from a nib.
    viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    
    _colorPicker = [[RSColorPickerView alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 300.0)];
    [_colorPicker setCropToCircle:YES]; // Defaults to YES (and you can set BG color)
	[_colorPicker setDelegate:self];
	[viewController.view addSubview:_colorPicker];
    
    //set opening color to manipulate
    [_colorPicker setSelectionColor:colorToManipulate];
    
    // On/off circle or square
    UISwitch *circleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 340, 0, 0)];
    [circleSwitch setOn:_colorPicker.cropToCircle];
	[circleSwitch addTarget:self action:@selector(circleSwitchAction:) forControlEvents:UIControlEventValueChanged];
	[viewController.view addSubview:circleSwitch];
    circleSwitch.hidden = YES;
    
    // View that controls brightness
	_brightnessSlider = [[RSBrightnessSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(circleSwitch.frame) + 4, 340.0, 320 - (20 + CGRectGetWidth(circleSwitch.frame)), 30.0)];
	[_brightnessSlider setColorPicker:_colorPicker];
	[viewController.view addSubview:_brightnessSlider];
    
    // View that shows selected color
	_colorPatch = [[UIView alloc] initWithFrame:CGRectMake(160, 380.0, 150, 30.0)];
	[viewController.view addSubview:_colorPatch];
    
    //add button
    [viewController.view addSubview:btn];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = viewController;
    
	[self.window makeKeyAndVisible];
}

- (void)circleSwitchAction:(UISwitch *)s
{
	_colorPicker.cropToCircle = s.isOn;
}

-(void)colorPickerDidChangeSelection:(RSColorPickerView*)cp
{
 	_colorPatch.backgroundColor = [cp selectionColor];
    _brightnessSlider.value = [cp brightness];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chooseColorBtn:(id)sender
{
    //hides the view(window) that has all the manipulation stuff
    self.window.hidden = YES;
    //goes back to parent VC
    [self dismissViewControllerAnimated:YES completion:nil];
    //metthod from delegate that sends ver manipulated color
    [self.delegate addColorToView:_colorPatch.backgroundColor];
}
@end
