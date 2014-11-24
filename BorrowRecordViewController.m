//
//  BorrowRecordViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/12.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "BorrowRecordViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "BorrowRecordCell.h"
#import "SBJson.h"
@interface BorrowRecordViewController (){
    NSString *account;
    NSMutableArray *borrowrecodImage;
    NSMutableArray *borrowrecodName;
    NSString *borrowrecordURL;
}

@end
#define DBNAME    @"SQLite3.sqlite"
#define NAME      @"name"
#define STATUES   @"statues"
#define TABLENAME @"PERSONINFO"
@implementation BorrowRecordViewController
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
            char *name = (char*)sqlite3_column_text(statement, 1);
            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
            
            int statues = sqlite3_column_int(statement, 2);
            
            
            NSLog(@"name:%@  statues:%d ",nsNameStr,statues);
            account=nsNameStr;
            
        }
        
    }
    //SQL資料庫
    borrowrecodImage=[[NSMutableArray alloc]init];
    borrowrecodName=[[NSMutableArray alloc]init];
    //POST
    /****************************************************************************************/
    //會員與新會員統計
    //宣告一個 NSMutableURLRequest 並給予一個記憶體空間
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://chis.slib.antslab.tw/api/profile/get_borrow_record"];
    //宣告要post的值
    NSString *httpBodyString=[NSString stringWithFormat:@"account=%@",account];
    
    
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
    NSLog(@"borrow_record=%@",returnvaluearray);
    for(int i=0;i<returnvaluearray.count;i++){  //個人書籍資料存放
        
        NSDictionary* search=returnvaluearray[i];
        borrowrecordURL=[NSString stringWithFormat:@"http://chis.slib.antslab.tw/api/ebook/get_book_cover/%@",search[@"file_id"]];
        [borrowrecodImage addObject:borrowrecordURL];
        [borrowrecodName addObject:search[@"name"]];
    }  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return borrowrecodName.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BorrowRecordCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"borrowrecordcell" forIndexPath:indexPath];
    
    [[cell borrowrecordImage]setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[borrowrecodImage objectAtIndex:indexPath.item]]]]];
    [[cell borrowrecordLable]setText:[borrowrecodName objectAtIndex:indexPath.item]];
    
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
