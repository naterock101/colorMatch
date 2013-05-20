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
    
    //nlpolishinfoVC
    NLPolishInfoViewController *polishInfoVC;
    
    //se up a variable for your matched polish
    NLNailPolish *polishMatched;
}

@end

@implementation NLViewController
@synthesize colorThatWasManipulated, fetchedResultsController, managedObjectContext;

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
    NLNailPolish *meetMeAtSunset =[[NLNailPolish alloc]initWithLabValuesL:58.62 A:51.73 B:59.63 andName:@"Meet Me At Sunset" andRed:224 andGreen:74 andBlue:27];
    [arrayOfPolishes addObject:meetMeAtSunset];
    NLNailPolish *shesPampered =[[NLNailPolish alloc]initWithLabValuesL:43 A:65 B:36 andName:@"She Pampered" andRed:202 andGreen:10 andBlue:50];
    [arrayOfPolishes addObject:shesPampered];
    NLNailPolish *clambake =[[NLNailPolish alloc]initWithLabValuesL:56.71 A:64.08 B:58.46 andName:@"Clambake" andRed:235 andGreen:50 andBlue:28];
    [arrayOfPolishes addObject:clambake];
    NLNailPolish *fearOfDesire =[[NLNailPolish alloc]initWithLabValuesL:68.12 A:36.02 B:58.95 andName:@"Fear Of Desire" andRed:235 andGreen:118 andBlue:44];
    [arrayOfPolishes addObject:fearOfDesire];
    NLNailPolish *djPlayThatSong =[[NLNailPolish alloc]initWithLabValuesL:52.10 A:49.32 B:-47.18 andName:@"DJ Play That Song" andRed:154 andGreen:89 andBlue:202];
    [arrayOfPolishes addObject:djPlayThatSong];
    NLNailPolish *bigSpender = [[NLNailPolish alloc]initWithLabValuesL:47 A:60.32 B:-5.93 andName:@"Big Spender" andRed:168 andGreen:57 andBlue:121];
    [arrayOfPolishes addObject:bigSpender];
    NLNailPolish *avenueMaintain = [[NLNailPolish alloc]initWithLabValuesL:66.58 A:-16.53 B:-42.15 andName:@"Avenue Maintain" andRed:108 andGreen:171 andBlue:234];
    [arrayOfPolishes addObject:avenueMaintain];
    
    
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
    //linkshare MERCHANDISE QUERY API
    //use this to find the information needed for the linkgenerator
    NSString *linkshareWebServicesToken = @"2624192b711c97206acbb22d18d91e6be4de91da0e89d1e876a9ab57bd958458";
    NSString *keyword = [NSString stringWithFormat:@"%@", polishMatched.name];
    NSString *category = @"Nail Polish";
    //3002 correlates to beauty.com
    NSString *merchant = @"3002";
    
   NSString *merchQueryAPIString= [NSString stringWithFormat:@"http://productsearch.linksynergy.com/productsearch?token=%@&keyword=\"%@\"&cat=\"%@\"&MaxResults=1&pagenumber=1&mid=%@&sort=retailprice&sorttype=asc&sort=productname&sorttype=asc", linkshareWebServicesToken, keyword, category, merchant];
    NSLog(@"%@", merchQueryAPIString);
    
    
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
