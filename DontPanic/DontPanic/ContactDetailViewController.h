//
//  DetailViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 03/12/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactViewController;
@interface ContactDetailViewController : UIViewController{
    
    UITextField *name;
    UITextField *phone;
    UITextField *email;
    
    ContactViewController *parentController;
    NSManagedObject *system;
    
}


@property (strong, nonatomic) id detailItem;

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *phone;
@property (nonatomic, retain) IBOutlet UITextField *email;
@property (nonatomic, retain) ContactViewController *parentController;
@property (nonatomic, retain) NSManagedObject *system;

- (id)initWithParentController:(ContactViewController *) aParentController system:(NSManagedObject *) aSystem;

- (IBAction)save:(id)sender;

-(void)setParent:(ContactViewController *)parent;

@end
