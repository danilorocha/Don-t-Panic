//
//  RedButtonViewController.m
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import "RedButtonViewController.h"

@implementation RedButtonViewController

@synthesize testeBotao;
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
    apertado = FALSE;
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


-(IBAction)entrou:(id)sender{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"The Trakking will begin" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    if (apertado == TRUE){
        //[alerta release];
        testeBotao.text = @"Botão Desativado";
        apertado = FALSE;
    }        

    else{
        [alerta show];
        testeBotao.text = @"Botão Ativado";
        apertado = TRUE;
    }    
    
    
    
}





@end
