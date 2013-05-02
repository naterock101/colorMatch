//
//  NLViewController.m
//  colorMatch
//
//  Created by Nathan Levine on 5/2/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLViewController.h"

@interface NLViewController ()
{
    
}

@end

@implementation NLViewController


#pragma mark -
#pragma mark Initial methods
//initial stuff
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //call the method that sets up the initial appearance
    [self setupAppearance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupAppearance
{
    //make a nav button that will assign the button to the action method (takepicture)
    UIBarButtonItem *cameraBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePicture:)];
    
    //add the button to the nav bar
    [[self navigationItem] setRightBarButtonItem:cameraBarButtonItem];
}

#pragma mark -
#pragma mark Camera methods
//camera stuff

//calls when camera button is pressed
- (void)takePicture:(id) sender
{
    //make an instance of the camera
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    
    //check if the device has a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //if it does open up the camera api
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        //if it doesn't open up the photoLibrary
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    //set the delegate so that once pictures are taken the picturefinishedtaken method calls
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

//calls after you take a picture
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //grab the image you just took in order to do stuff with it
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //add the picture to the imageview
    [imageViewForPic setImage:image];
    
    //dismiss the camera view
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
