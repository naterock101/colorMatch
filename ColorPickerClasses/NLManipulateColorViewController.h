//
//  NLManipulateColorViewController.h
//  colorMatch
//
//  Created by Nathan Levine on 5/6/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSColorPickerView.h"
#import "RSBrightnessSlider.h"

@interface NLManipulateColorViewController : UIViewController <RSColorPickerViewDelegate>
{
    NSString * savePath;
    __weak IBOutlet UIButton *btn;
}
- (IBAction)chooseColorBtn:(id)sender;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic) RSColorPickerView *colorPicker;
@property (nonatomic) RSBrightnessSlider *brightnessSlider;
@property (nonatomic) UIView *colorPatch;

//color to be set through segue to be manipulated
@property (nonatomic, strong) UIColor *colorToManipulate;


@end
