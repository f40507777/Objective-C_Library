//
//  MyBookViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/11.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "MyBookViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "MyBookCell.h"
#import "SBJson.h"
@interface MyBookViewController (){
    NSMutableArray *mybookImages;
    NSMutableArray *mybookName;
    NSString *account;
    NSDictionary* search;
    NSString *bookcoverurl;
}

@end

#define DBNAME    @"SQLite3.sqlite"
#define NAME      @"name"
#define STATUES   @"statues"
#define TABLENAME @"PERSONINFO"

@implementation MyBookViewController
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
//Title
    UILabel *title=[[UILabel alloc]init];
    title.frame=CGRectMake(50, 10, self.view.frame.size.width, 40);
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=@"書櫃";
    title.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:21];
    [self.view addSubview:title];
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
    
    //POST
    /****************************************************************************************/
    //會員與新會員統計
    //宣告一個 NSMutableURLRequest 並給予一個記憶體空間
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //宣告一個 NSURL 並給予記憶體空間、連線位置
    NSURL *connection = [[NSURL alloc] initWithString:@"http://chis.slib.antslab.tw/api/ebook/borrow_list"];
    //宣告要post的值
    NSString *httpBodyString=[NSString stringWithFormat:@"account=%@",account];
    //NSString *httpBodyString=[NSString stringWithFormat:@"a_id=57"];
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
    mybookImages=[[NSMutableArray alloc]init];
    mybookName=[[NSMutableArray alloc]init];
    for(int i=0;i<returnvaluearray.count;i++){  //個人書籍資料存放
        search=returnvaluearray[i];        
        bookcoverurl=[NSString stringWithFormat:@"http://chis.slib.antslab.tw/api/ebook/get_book_cover/%@",search[@"file_id"]];
        [mybookImages addObject:bookcoverurl];
        [mybookName addObject:search[@"name"]];
    }
    
    

    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return mybookName.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyBookCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"mybookcell" forIndexPath:indexPath];
    //[cell.mybookLable setNumberOfLines:0];
    [cell.mybookLable sizeToFit];
    cell.mybookLable.numberOfLines=0;
    [[cell mybookImage]setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[mybookImages objectAtIndex:indexPath.item]]]]];
    [[cell mybookLable]setText:[mybookName objectAtIndex:indexPath.item]];

    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)revealMenu:(id)sender{
    [self.slidingViewController anchorTopViewTo:ECRight];
}
@end
