//
//  RedButtonViewController.m
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import "RedButtonViewController.h"

@implementation RedButtonViewController

@synthesize trakingInfo;
@synthesize botao;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    apertado = NO;
    trakingInfo.text = @"Tracking disabled";
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)showConfirmAlert
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Attention!"];
	[alert setMessage:@"Do you want to begin the tracking?"];
	[alert setDelegate:self];
	[alert addButtonWithTitle:@"Yes"];
	[alert addButtonWithTitle:@"No"];
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        apertado = YES;
        trakingInfo.text = @"Tracking in progress";
		NSLog(@"Apertou Sim");
	}
	else if (buttonIndex == 1)
	{
		NSLog(@"apertou NO");
	}
}



-(IBAction)sendInfo:(id)sender{
    
    if (apertado == YES){
        apertado = NO;
        trakingInfo.text = @"Tracking disabled";
        
    }        

    else{
        [self showConfirmAlert];
    }    
    
    
    
}





@end
