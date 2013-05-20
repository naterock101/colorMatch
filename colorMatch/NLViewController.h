//
//  NLViewController.h
//  colorMatch
//
//  Created by Nathan Levine on 5/2/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLManipulateColorViewController.h"
#import "NLNailPolish.h"
#import "NLPolishInfoViewController.h"
#import <AWSRuntime/AWSRuntime.h>
#import <CoreData/CoreData.h>
#import "NLcolorTheoryLogic.h"
#import "NailPolishInfo.h"

@interface NLViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, DestinationViewControllerDelegate, NSFetchedResultsControllerDelegate>
{
    __weak IBOutlet UILabel *nailPolishNameLabel;
    __weak IBOutlet UIImageView *imageViewForPic;    
    __weak IBOutlet UIImageView *testImageView;
    __weak IBOutlet UIView *viewToPutManipulatedColorIn;
    __weak IBOutlet UIView *viewToChangeColor;
    __weak IBOutlet UIView *viewForClosestPolishColor;
}

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UIColor *colorThatWasManipulated;

- (IBAction)polishInfoBtn:(id)sender;
- (IBAction)manipulateButton:(UIButton *)sender;
- (IBAction)compareOneBtn:(UIButton *)sender;
- (IBAction)compareTwoBtn:(UIButton *)sender;


- (void)setupAppearance;
- (void)takePicture:(id) sender;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;


@end
