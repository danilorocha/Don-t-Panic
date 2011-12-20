//
//  UserViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface UserViewController : UIViewController <NSFetchedResultsControllerDelegate>{
    UITextField *userText;
    UITextField *passText;
    NSManagedObject *user;

} 

- (IBAction)removerTeclado:(id)sender;
- (IBAction)insertUser;

@property(nonatomic, retain) IBOutlet UITextField *userText;
@property(nonatomic, retain) IBOutlet UITextField *passText;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObject *user;

@end
