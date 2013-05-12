//
//  NLViewController.m
//  colorMatch
//
//  Created by Nathan Levine on 5/2/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLViewController.h"
#include <math.h> 

@interface NLViewController ()
{
    UIColor *colorToSave;
    UInt8 red;
    UInt8 green;
    UInt8 blue;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    
    //testing array
    NSMutableArray *arrayOfPolishes;
    
    //array of labvalues
    NSMutableArray *labValuesArray;
    
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
    
    //set up the array for testing
    arrayOfPolishes = [[NSMutableArray alloc]init];
    
    //get some dummy polishes to test.
    NLNailPolish *meetMeAtSunset =[[NLNailPolish alloc]initWithLabValuesL:53 A:67 B:65 andName:@"Meet Me At Sunset"];
    [arrayOfPolishes addObject:meetMeAtSunset];
    NLNailPolish *shesPampered =[[NLNailPolish alloc]initWithLabValuesL:43 A:65 B:36 andName:@"She's Pampered"];
    [arrayOfPolishes addObject:shesPampered];
    NLNailPolish *garnet =[[NLNailPolish alloc]initWithLabValuesL:44 A:64 B:43 andName:@"Garnet"];
    [arrayOfPolishes addObject:garnet];
    NLNailPolish *bungleJungle =[[NLNailPolish alloc]initWithLabValuesL:46 A:66 B:69 andName:@"Bungle Jungle"];
    [arrayOfPolishes addObject:bungleJungle];
    NLNailPolish *jellyApple =[[NLNailPolish alloc]initWithLabValuesL:52 A:73 B:64 andName:@"Jelly Apple"];
    [arrayOfPolishes addObject:jellyApple];
    
    //hide label
    nailPolishNameLabel.hidden = YES;

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

    //turns out i could use a built in method DERPFACE BE RIGHT HERE
//    [colorToSave getRed:&red2 green:&green2 blue:&blue2 alpha:nil];
//    NSLog(@"red is:%f green is:%f blue is %f", (red2*255), (green2*255), (blue2*255));
    
    //set backgorund color of tiny view to pixel color
    viewToChangeColor.backgroundColor = colorToSave;
    
    //get HSB
    [colorToSave getHue:&hue saturation:&saturation brightness:&brightness alpha:nil];
    //NSLog(@"hue! %g saturation! %g brightness! %g", hue, saturation, brightness);

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

#pragma mark convert color stuff

- (NSMutableArray *) convertRGBtoLABwithColor: (UIColor *)color
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

-(float)compareUsingCIE1994WithLab1l:(int)lab1l andLab1a:(int)lab1a andLab1b:(int)lab1b andLab2l:(int)lab2l andLab2a:(int)lab2a andLab2b:(int)lab2b
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
- (NLNailPolish *)compareColor:(UIColor*)color
{
    //get the lab values
    labValuesArray = [self convertRGBtoLABwithColor:color];
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
    
    for (NLNailPolish *polish in arrayOfPolishes)
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


#pragma mark Button Stuff

- (IBAction)manipulateButton:(UIButton *)sender
{
    //goes to segue
}

- (IBAction)compareOneBtn:(UIButton *)sender
{
    //get the color that was chosen
    UIColor *color = viewToChangeColor.backgroundColor;
    
    //run the comparison
    NLNailPolish *polishMatched = [self compareColor:color];
    
    //now return the closest match colors to the screen.
    
    //unhide label and name it
    nailPolishNameLabel.text = polishMatched.name;
    nailPolishNameLabel.hidden = NO;
    
}

- (IBAction)compareTwoBtn:(UIButton *)sender
{
    //get the color that was chosen
    UIColor *color = viewToPutManipulatedColorIn.backgroundColor;
    
    //run the comparison
    NLNailPolish *polishMatched = [self compareColor:color];
    
    //now return the closest match colors to the screen.
    
    //unhide label and name it
    nailPolishNameLabel.text = polishMatched.name;
    nailPolishNameLabel.hidden = NO;
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
