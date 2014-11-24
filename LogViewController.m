//
//  LogViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/11.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "LogViewController.h"
#import "SBJson.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "NextViewController.h"
@interface LogViewController (){
    NSString * accounts;
    NSString * a_id;
    int logstatus;
}

@end
//sqlite
#define DBNAME    @"SQLite3.sqlite"
#define NAME      @"name"
#define STATUES   @"statues"
#define TABLENAME @"PERSONINFO"
//sqlite

@implementation LogViewController
@synthesize menuBtn;
@synthesize account;
@synthesize password;
@synthesize loginbutton;
@synthesize logoutbutton;
@synthesize acclable;
@synthesize passlable;
@synthesize  test;
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
    //MenuBoutton
    self.view.layer.shadowOpacity=0.75f;
    self.view.layer.shadowRadius=10.0f;
    self.view.layer.shadowColor=[UIColor blackColor].CGColor;
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    self.menuBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame=CGRectMake(8, 10, 35, 35);
    [menuBtn setBackgroundImage:[UIImage imageNamed:@"menubutton.png"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(revealMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    //MenuBoutton
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"數據庫打開失敗1");
    }
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement;
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
    }
    else {
        NSLog(@"尚未建造");
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, statues INTEGER ,a_id TEXT)";
        [self execSql:sqlCreateTable];
        NSString *sql1 = [NSString stringWithFormat:@"INSERT INTO '%@' (name, statues, a_id) VALUES ('%@',0,'%@' )",TABLENAME,@"",@""];
        [self execSql:sql1];
        //[logoutbutton setHidden:YES];
    }
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
    
        NSLog(@"以建立");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            int statues = sqlite3_column_int(statement, 2);
            char *a_idstring=(char*)sqlite3_column_text(statement, 3);
            NSString *ma_id = [[NSString alloc]initWithUTF8String:a_idstring];
            NSLog(@"name:%@  statues:%d  a_id=%@ ",nsNameStr,statues,ma_id);
            if(statues==0){
                [logoutbutton setHidden:NO];
            }
            if(statues==1){
                [loginbutton setHidden:YES];
                [account setHidden:YES];
                [password setHidden:YES];
            }
            
        }
    }
    
    sqlite3_close(db);

}
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL,&err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"數據庫打開失敗!");
    }
}

-(IBAction)loginbutton:(id)sender{
    
    NSLog(@"account=%@",account.text);
    NSLog(@"password=%@",password.text);

    NSString *kstudent=@"kstudent"; //testID
    NSString *pass=@"1234";         //testpasswd
    NSString *type=@"3";
    //NSString *device_id=@"5555";
    //NSString *device_name=@"4444";
    account.text=kstudent;
    password.text=pass;
    UIDevice *device=[UIDevice currentDevice];
    NSString *device_id=[device uniqueIdentifier];
    NSString *device_name=[device name];
    
    //POST
    /****************************************************************************************/
    //會員與新會員統計
    //宣告一個 NSMutableURLRequest 並給予一個記憶體空間
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://chis.slib.antslab.tw/api/login"];
    //宣告要post的值
    NSString *httpBodyString=[NSString stringWithFormat:@"account=%@&type=%@&device_id=%@&device_name=%@&passwd=%@",account.text,type,device_id,device_name,password.text];
    
    
    //account=kstudent
    //password=1234
    
    NSLog(@"httpBodyString = %@",httpBodyString);
    //設定連線位置
    [request setURL:connection];
    //設定連線方式
    [request setHTTPMethod:@"POST"];
    //將編碼改為UTF8
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //轉換為NSData傳送
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //看request出來的值
    NSString *returnvalue=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSArray* returnvaluearray =[returnvalue JSONValue];
    NSLog(@"return=%@",returnvaluearray);
    
    NSDictionary* search=returnvaluearray;
    a_id=search[@"a_id"];
    accounts=search[@"account"];
    logstatus=[search[@"status"] intValue];
    NSLog(@"status=%d",logstatus);
    NSLog(@"account=%@",accounts);
    NSLog(@"a_id=%@",a_id);
    if(logstatus==1){
        
        NSString *updateSq1=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TABLENAME,STATUES,@"1",STATUES,@"0"];
        NSString *updateSq2=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TABLENAME,NAME,accounts,NAME,@""];
        NSString *updateSq3=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TABLENAME,@"a_id",a_id,@"a_id",@""];
        
        [self execSql:updateSq1];
        [self execSql:updateSq2];
        [self execSql:updateSq3];
        
        [logoutbutton setHidden:NO];
        [loginbutton setHidden:YES];
        [account setHidden:YES];
        [password setHidden:YES];
        [acclable setHidden:YES];
        [passlable setHidden:YES];
        
        
    }
    
}
-(IBAction)logoutbutton:(id)sender{
    
    NSString *kstudent=@"kstudent"; //testID
    UIDevice *device=[UIDevice currentDevice];
    NSString *device_id=[device uniqueIdentifier];
    
    //POST
    /****************************************************************************************/
    //會員與新會員統計
    //宣告一個 NSMutableURLRequest 並給予一個記憶體空間
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://chis.slib.antslab.tw/api/logout"];
    //宣告要post的值
    NSString *httpBodyString=[NSString stringWithFormat:@"account=%@&device_id=%@",kstudent,device_id];
    
    
    //account=kstudent
    //password=1234
    
    NSLog(@"httpBodyString = %@",httpBodyString);
    //設定連線位置
    [request setURL:connection];
    //設定連線方式
    [request setHTTPMethod:@"POST"];
    //將編碼改為UTF8
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //轉換為NSData傳送
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //看request出來的值
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    
    NSString *updateSq1=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TABLENAME,STATUES,@"0",STATUES,@"1"];
    NSString *updateSq2=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TABLENAME,NAME,@"",STATUES,accounts];
    NSString *updateSq3=[NSString stringWithFormat:@"UPDATE %@ SET %@ = '%@' WHERE %@ = '%@'",TABLENAME,@"a_id",@"",@"a_id",a_id];
    [self execSql:updateSq1];
    [self execSql:updateSq2];
    [self execSql:updateSq3];
    [logoutbutton setHidden:YES];
    [loginbutton setHidden:NO];
    [account setHidden:NO];
    [password setHidden:NO];
    [acclable setHidden:NO];
    [passlable setHidden:NO];

    
}

-(IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)testbutton:(id)sender{
    UIViewController *newTopViewController;
    newTopViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"Next"];
    self.slidingViewController.topViewController = newTopViewController;
    [self.slidingViewController resetTopView];

    //[self.slidingViewController resetTopView];
     //[self.slidingViewController resetTopView];
    //[self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        //CGRect frame = self.slidingViewController.topViewController.view.frame;
        //self.slidingViewController.topViewController = newTopViewController;
        //self.slidingViewController.topViewController.view.frame = frame;
        //[self.slidingViewController resetTopView];
    //}];

}
@end
