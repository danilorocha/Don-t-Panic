//
//  DetailViewController.m
//  DontPanic
//
//  Created by Douglas Barbosa on 03/12/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import "ContactDetailViewController.h"
#import "ContactViewController.h"

@interface ContactDetailViewController ()
- (void)configureView;
@end

@implementation ContactDetailViewController


@synthesize detailItem = _detailItem;
@synthesize system;
@synthesize parentController;
@synthesize name;
@synthesize phone;
@synthesize email;

#pragma mark - Managing the detail item

- (id)initWithParentController:(ContactViewController *)aParentController system:(NSManagedObject *)aSystem{
    if ((self = [super init])) {
        self.parentController = aParentController;
        self.system = aSystem;
    }
    return self;
    
    
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
}

- (void)setParent:(ContactViewController *)parent{
    
    parentController = parent;
    
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        if(system != nil){
            name.text = [system valueForKey:@"name"];
            phone.text = [system valueForKey:@"phone"];
            email.text = [system valueForKey:@"email"];
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    system = _detailItem;
    [super viewDidLoad];
    
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)save:(id)sender{
    NSString *errorText = nil;
    
    NSManagedObject *tempSystem = nil;
    NSString *tempName = nil;
    NSString *tempPhone = nil;
    NSString *tempEmail = nil;
    
    //if(parentController != nil){
    if (system != nil) {
        tempName = [NSString stringWithString:(NSString *)[system valueForKey:@"name"]];
        tempPhone = [NSString stringWithString:(NSString *)[system valueForKey:@"phone"]];
        tempEmail = [NSString stringWithString:(NSString *)[system valueForKey:@"email"]];
        
        [system setValue:name.text forKey:@"name"];
        [system setValue:phone.text forKey:@"phone"];
        [system setValue:email.text forKey:@"email"];
        
    }
    else{
        tempSystem = [parentController insertContactWithName:name.text phone:phone.text email:email.text];
    }
    errorText = [parentController saveContext];
    
    if (errorText != nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:errorText delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        if (tempSystem != nil) {
            [[parentController.fetchedResultsController managedObjectContext] deleteObject:tempSystem];
        } 
        else {
            [system setValue:tempName forKey:@"name"];
            [system setValue:tempPhone forKey:@"phone"];
            [system setValue:tempEmail forKey:@"email"];
        }
    } 
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
    
    //}
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
