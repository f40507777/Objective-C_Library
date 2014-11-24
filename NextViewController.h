//
//  NextViewController.h
//  MyLibrary
//
//  Created by Ants Lab on 13/9/13.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NextViewController : UIViewController
@property (weak,nonatomic) IBOutlet UIButton *back;
@property(strong,nonatomic) UIButton *menuBtn;
-(IBAction)backbt:(id)sender;

@end
