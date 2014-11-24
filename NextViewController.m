//
//  NextViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/13.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "NextViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "LogViewController.h"
#import "SBJson.h"
@interface NextViewController ()

@end

@implementation NextViewController
@synthesize back;
@synthesize menuBtn;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LogViewController*logview=[[LogViewController alloc]init];
    [logview dismissModalViewControllerAnimated:YES];
    //MenuBoutton
    self.view.layer.shadowOpacity=0.75f;
    self.view.layer.shadowRadius=10.0f;
    self.view.layer.shadowColor=[UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame=CGRectMake(8, 10, 35, 35);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menubutton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}
-(IBAction)backbt:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
