//
//  MenuViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/10.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
@interface MenuViewController (){
    NSArray *menusectionicon1;
    NSArray *menusectionicon2;
    NSArray *menusectionicon;
}
@property (strong,nonatomic)NSArray *menu;//menu選單名稱
@property (strong,nonatomic)NSArray *section1;
@property (strong,nonatomic)NSArray *section2;
@property (strong,nonatomic)NSArray *sectionId1;
@property (strong,nonatomic)NSArray *sectionId2;
@end

@implementation MenuViewController
@synthesize menu,section1,section2;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.section1=[NSArray arrayWithObjects:@"公共藏書",@"書櫃", nil];
    self.section2=[NSArray arrayWithObjects:@"借閱紀錄",@"我的預約",@"收藏清單",@"好友清單",@"登出", nil];
    self.sectionId1=[NSArray arrayWithObjects:@"PublicBooks",@"MyBook", nil];
    self.sectionId2=[NSArray arrayWithObjects:@"BorrowRecord",@"Reservation",@"Favorite",@"Friends",@"Log", nil];
    self.menu=[NSArray arrayWithObjects:self.section1  ,self.section2, nil];
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    self.slidingViewController.underLeftWidthLayout=ECFullWidth;
    menusectionicon1=[[NSArray alloc]initWithObjects:@"menupic1.png",@"menupic2.png", nil];
    menusectionicon2=[[NSArray alloc]initWithObjects:@"menupic3.png",@"menupic4.png",@"menupic5.png",@"menupic6.png",@"menupic7.png", nil];
    menusectionicon=[[NSArray alloc]initWithObjects:menusectionicon1,menusectionicon2, nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menu count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return [self.section1 count];
    }
    else
        return [self.section2 count];
    
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"書櫃";
    }
    else
        return @"個人中心";

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.section==0){
        cell.textLabel.text =[NSString stringWithFormat:@"%@",[self.section1 objectAtIndex:indexPath.row]];
    }else if (indexPath.section == 1){
        cell.textLabel.text =[NSString stringWithFormat:@"%@",[self.section2 objectAtIndex:indexPath.row]];
    }
    cell.imageView.image=[UIImage imageNamed:[[menusectionicon objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
    cell.contentView.backgroundColor=[UIColor clearColor];//background color
    cell.textLabel.backgroundColor=[UIColor clearColor];//Lable background color
    //cell.selectionStyle=UITableViewCellSelectionStyleNone;//select color
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *newTopViewController;
    
    
    if(indexPath.section==0){
        NSString *identifier=[NSString stringWithFormat:@"%@",[self.sectionId1 objectAtIndex:indexPath.row]];
        newTopViewController=[self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
    }else if (indexPath.section == 1){
        NSString *identifier=[NSString stringWithFormat:@"%@",[self.sectionId2 objectAtIndex:indexPath.row]];
        newTopViewController=[self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
    }
        
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end
