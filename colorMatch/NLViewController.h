//
//  NLViewController.h
//  colorMatch
//
//  Created by Nathan Levine on 5/2/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NLViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIImageView *imageViewForPic;    
    __weak IBOutlet UIImageView *testImageView;
    __weak IBOutlet UIView *viewToChangeColor;
}

- (void)setupAppearance;
- (void)takePicture:(id) sender;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;


@end
