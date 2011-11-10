//
//  RedButtonViewController.h
//  DontPanic
//
//  Created by Douglas Barbosa on 09/11/11.
//  Copyright (c) 2011 UFBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedButtonViewController : UIViewController{

    UILabel *testeBotao;
    UIButton *botao;
    
    BOOL apertado;



}


@property(nonatomic, retain) IBOutlet UILabel *testeBotao;
@property(nonatomic, retain) IBOutlet UIButton *botao;


-(IBAction)entrou:(id)sender;


@end
