//
//  DetailViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 03/12/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactDetailViewController : UIViewController


@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
