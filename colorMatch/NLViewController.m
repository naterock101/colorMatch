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
    UIColor *colorToSave;
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    
    //nlmanipulatecolorVC
    NLManipulateColorViewController *manipulateVC;
}

@end

@implementation NLViewController
@synthesize colorThatWasManipulated;

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
    
    //testimage for funsies
    UIImage *testImage = [UIImage imageNamed:@"colorWheel2.png"];
    [testImageView setImage:testImage];
}

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

#pragma mark getPixelColor
//grabs pixel at a uitouch cgpoint

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //make a touch
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    //make a cgpoint out of a touch
    CGPoint point1 = [touch locationInView:self.view];
    //get a color from a pixel
    colorToSave = [self getPixelColorAtLocation:point1];

    //set backgorund color of tiny view to pixel color
    viewToChangeColor.backgroundColor = colorToSave;
}

-(UIColor *) getPixelColorAtLocation: (CGPoint)point
{
    //set color no nothing for now
    UIColor * color = nil;
    
    //make a cgimageref out of your image
    CGImageRef inImage = testImageView.image.CGImage;
    
    //gets height and width of image
    size_t width = CGImageGetWidth(inImage);
    size_t height = CGImageGetHeight(inImage);
    
    //determines the x and y of the cgpoing based on the image
    NSUInteger x = (((NSUInteger)floor(point.x)) - 30);
    NSUInteger y = (((NSUInteger)floor(point.y)) - 25);
    NSUInteger test = height - y;
    
    if ((x < width) && (test < height))
    {
        CGDataProviderRef provider = CGImageGetDataProvider(inImage);
    	CFDataRef bitmapData = CGDataProviderCopyData(provider);
    	const UInt8* data = CFDataGetBytePtr(bitmapData);
    	size_t offset = ((width * y) + x) * 4;
        
        //rgb values work differnt on device and simulator so for testing have this out
        if (TARGET_IPHONE_SIMULATOR)
        {
            red = data[offset];
            green = data[offset + 1];
            blue =  data[offset + 2];
        } else {
            //on device, notice red and blue are swapped because apple does byte swpaping on device and not on simulator, learing like a boss
            blue =  data[offset];       
            green = data[offset + 1];
            red =   data[offset + 2];
        }
    	UInt8 alpha = data[offset+3];
    	//CFRelease(bitmapData);
    	color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
        NSLog(@"red is:%f green is:%f blue is %f", ((red/255.0f)*255), ((green/255.0f)*255), ((blue/255.0f)*255));
    }
    return color;
}

#pragma mark Manipulate Button Stuff

- (IBAction)manipulateButton:(UIButton *)sender
{
    //goes to segue
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"manipulateColorSeg"])
    {
        manipulateVC = segue.destinationViewController;
        manipulateVC.colorToManipulate = colorToSave;
        manipulateVC.delegate = self;
    }
}

#pragma mark Delegate stuff

- (void)addColorToView:(UIColor *)color
{
    viewToPutManipulatedColorIn.backgroundColor = color;
}

@end
