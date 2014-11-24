//
//  FriendsViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/12.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "FriendsViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "FriendsCell.h"
#import "SBJson.h"
@interface FriendsViewController (){
    NSString *a_id;
    NSMutableArray *friendsImage;
    NSMutableArray *friendsName;
    NSString *friendsURL;
}

@end
#define DBNAME    @"SQLite3.sqlite"
#define NAME      @"name"
#define STATUES   @"statues"
#define TABLENAME @"PERSONINFO"
@implementation FriendsViewController
@synthesize  menuBtn;
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
    //SQL資料庫
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
        NSLog(@"以建立");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *a_idstring=(char*)sqlite3_column_text(statement, 3);
            a_id= [[NSString alloc]initWithUTF8String:a_idstring]; 
        }
    }
    //SQL資料庫
    friendsImage=[[NSMutableArray alloc]init];
    friendsName=[[NSMutableArray alloc]init];
    //POST
    /****************************************************************************************/
    //會員與新會員統計
    //宣告一個 NSMutableURLRequest 並給予一個記憶體空間
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://chis.slib.antslab.tw/api/profile/get_friends"];
    //宣告要post的值
    NSString *httpBodyString=[NSString stringWithFormat:@"a_id=%@",a_id];
    
    
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
    NSDictionary* search=returnvaluearray;
    NSArray* friendsdata=search[@"data"];
    for(int i=0;i<friendsdata.count;i++){
        NSDictionary* friendsearch=friendsdata[i];
        friendsURL=[NSString stringWithFormat:@"http://chis.slib.antslab.tw/api/ebook/get_header_pic/%@",friendsearch[@"a_id"]];
        [friendsImage addObject:friendsURL];
        [friendsName addObject:friendsearch[@"name"]];        
    }
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return friendsName.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"freindscell" forIndexPath:indexPath];
    
    [[cell friendsImage]setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[friendsImage objectAtIndex:indexPath.item]]]]];
    [[cell friendsLable]setText:[friendsName objectAtIndex:indexPath.item]];
    
    return cell;
}
-(IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
