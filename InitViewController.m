//
//  InitViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/10.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "InitViewController.h"
#import "ECSlidingViewController.h"
@interface InitViewController ()


@end

@implementation InitViewController
@synthesize location;
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

    self.topViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PublicBooks"];
    [self.slidingViewController setAnchorLeftPeekAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout=ECFullWidth;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
