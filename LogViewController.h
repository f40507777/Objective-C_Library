//
//  LogViewController.h
//  MyLibrary
//
//  Created by Ants Lab on 13/9/11.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface LogViewController : UIViewController
{
    sqlite3 *db;
}
@property(strong,nonatomic) UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginbutton;
@property (weak, nonatomic) IBOutlet UIButton *logoutbutton;
@property (weak, nonatomic) IBOutlet UILabel *acclable;
@property (weak, nonatomic) IBOutlet UILabel *passlable;
@property (weak,nonatomic) IBOutlet UIButton *test;

-(IBAction)loginbutton:(id)sender;
-(IBAction)logoutbutton:(id)sender;
-(IBAction)testbutton:(id)sender;
@end
