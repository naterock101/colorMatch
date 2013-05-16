//
//  NLViewController.m
//  colorMatch
//
//  Created by Nathan Levine on 5/2/13.
//  Copyright (c) 2013 BankBox. All rights reserved.
//

#import "NLViewController.h"
#import "NLcolorTheoryLogic.h"
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
    
    //nlpolishinfoVC
    NLPolishInfoViewController *polishInfoVC;
    
    //se up a variable for your matched polish
    NLNailPolish *polishMatched;
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
    NLNailPolish *meetMeAtSunset =[[NLNailPolish alloc]initWithLabValuesL:53 A:67 B:65 andName:@"Meet Me At Sunset" andRed:240 andGreen:54 andBlue:39];
    [arrayOfPolishes addObject:meetMeAtSunset];
    NLNailPolish *shesPampered =[[NLNailPolish alloc]initWithLabValuesL:43 A:65 B:36 andName:@"She's Pampered" andRed:202 andGreen:10 andBlue:50];
    [arrayOfPolishes addObject:shesPampered];
    NLNailPolish *garnet =[[NLNailPolish alloc]initWithLabValuesL:44 A:64 B:43 andName:@"Garnet" andRed:205 andGreen:47 andBlue:43];
    [arrayOfPolishes addObject:garnet];
    NLNailPolish *bungleJungle =[[NLNailPolish alloc]initWithLabValuesL:46 A:66 B:69 andName:@"Bungle Jungle" andRed:217 andGreen:27 andBlue:2];
    [arrayOfPolishes addObject:bungleJungle];
    NLNailPolish *jellyApple =[[NLNailPolish alloc]initWithLabValuesL:52 A:73 B:64 andName:@"Jelly Apple" andRed:244 andGreen:30 andBlue:27];
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

#pragma mark Button Stuff

- (IBAction)manipulateButton:(UIButton *)sender
{
    //goes to segue
}

- (IBAction)polishInfoBtn:(id)sender
{
  /*  //
    //holla at amazon!
    //
    
    //keys and stuff
    NSString *awsAccessKeyID = @"AKIAJKPDNUQBFQ4VY3QA";
    NSString *awSecretAccessKey = @"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";
    NSString *associateTagID = @"ban04d2-20";
    
    //make keyword to search
    NSString *searchString = [NSString stringWithFormat:@"%@ nail polish", polishMatched.name];
    NSString *searchItem = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    //make things for unsigned api string (timestamp)
    NSTimeZone *zone = [NSTimeZone defaultTimeZone];                //get the current application default time zone
    NSInteger interval = [zone secondsFromGMTForDate:[NSDate date]];//sec Returns the time difference of the current application with the world standard time (Green Venice time)
    NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:interval]; //gets the current date
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init]; //sets up a formatter
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];// get current date/time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    NSString *currentTime = [dateFormatter stringFromDate:nowDate];
    NSString *encodedTime = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef) currentTime,NULL, CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    
    //Make unsigned api string
    NSString* unsignedString = [NSString stringWithFormat:@"GET\nwebservices.amazon.com\n/onca/xml\nAWSAccessKeyId=%@&AssociateTag=%@&Keywords=%@&Condition=All&7&Operation=ItemLookup&ResponseGroup=Images%%2CItemAttributes%%2COffers&Service=AWSECommerceService&Timestamp=%@&Version=2011-08-01", awsAccessKeyID, associateTagID, searchItem, encodedTime];

    //make into nsdata
    NSData *dataToSign = [unsignedString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *signatureString = [AmazonAuthUtils HMACSign:dataToSign withKey:awSecretAccessKey usingAlgorithm:kCCHmacAlgSHA256];
    NSLog(@"signature is:%@", signatureString);
    
    NSString *apiString = [NSString stringWithFormat:@"http://ecs.amazonaws.com/onca/xml?AWSAccessKeyId=%@&AssociateTag=%@&Keywords=%@&Operation=ItemLookup&SearchIndex=All&Service=AWSECommerceService&Timestamp=%@&Version=2011-08-01&Signature=%@", awsAccessKeyID, associateTagID, searchItem, encodedTime, signatureString];
        NSLog(@"api is: %@", apiString);
  //  NSString *stringApiTest = [CFURLCreateStringByAddingPercentEscapes(<#CFAllocatorRef allocator#>, <#CFStringRef originalString#>, <#CFStringRef charactersToLeaveUnescaped#>, <#CFStringRef legalURLCharactersToBeEscaped#>, <#CFStringEncoding encoding#>)]
*/    

}

- (IBAction)compareOneBtn:(UIButton *)sender
{
    //get the color that was chosen
    UIColor *color = viewToChangeColor.backgroundColor;
    
    //run the comparison
    polishMatched = [NLcolorTheoryLogic compareColor:color toDatabase:arrayOfPolishes];
    
    //unhide label and name it
    nailPolishNameLabel.text = polishMatched.name;
    nailPolishNameLabel.hidden = NO;
    
    //add the polish color to the view
    UIColor *polishColor = [UIColor colorWithRed:polishMatched.red/255.0 green:polishMatched.green/255.0 blue:polishMatched.blue/255.0 alpha:1];
    viewForClosestPolishColor.backgroundColor = polishColor;
}

- (IBAction)compareTwoBtn:(UIButton *)sender
{
    //get the color that was chosen
    UIColor *color = viewToPutManipulatedColorIn.backgroundColor;
    
    //run the comparison
    polishMatched = [NLcolorTheoryLogic compareColor:color toDatabase:arrayOfPolishes];
    
    //unhide label and name it
    nailPolishNameLabel.text = polishMatched.name;
    nailPolishNameLabel.hidden = NO;
    
    //add the polish color to the view
    UIColor *polishColor = [UIColor colorWithRed:polishMatched.red/255.0 green:polishMatched.green/255.0 blue:polishMatched.blue/255.0 alpha:1];
    viewForClosestPolishColor.backgroundColor = polishColor;
}

#pragma mark Segue stuff


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"manipulateColorSeg"])
    {
        manipulateVC = segue.destinationViewController;
        manipulateVC.colorToManipulate = colorToSave;
        manipulateVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"mainToInfo"])
    {
        polishInfoVC = segue.destinationViewController;
        polishInfoVC.polishName = polishMatched.name;
        polishInfoVC.polishColor = [UIColor colorWithRed:polishMatched.red/255.0 green:polishMatched.green/255.0 blue:polishMatched.blue/255.0 alpha:1];
    }
}

#pragma mark Delegate stuff

- (void)addColorToView:(UIColor *)color
{
    viewToPutManipulatedColorIn.backgroundColor = color;
}

@end
