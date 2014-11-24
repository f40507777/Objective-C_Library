//
//  MainViewController.m
//  MyLibrary
//
//  Created by Ants Lab on 13/9/10.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import "PublicBooksViewController.h"
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "PublicBooksCell.h"
#import "SBJson.h"
#import "CategoryViewController.h"
@interface PublicBooksViewController (){
    NSArray *categoryImages;
    NSMutableArray *categoryNames;
    NSDictionary* bookInfo;
    NSDictionary* search;
    NSMutableArray *childcategoryNames;
    NSMutableArray *childcategoryParent_id;
    NSString *catenumber;
}

@end


@implementation PublicBooksViewController

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
    self.navigationController.navigationBarHidden=YES;
//Title
    UILabel *title=[[UILabel alloc]init];
    title.frame=CGRectMake(50, 10, self.view.frame.size.width, 40);
    title.textColor=[UIColor whiteColor];
    title.backgroundColor=[UIColor clearColor];
    title.text=@"公共藏書";
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

//Data
    
    NSString* content=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://chis.slib.antslab.tw/api/ebook/get_category/"] encoding:NSUTF8StringEncoding error:nil];
    NSArray* librarydatas=[content JSONValue];
    categoryImages=[[NSArray alloc]initWithObjects:@"cate1-1.png",@"cate1-2.png",@"cate1-3.png",@"cate1-4.png",@"cate1-5.png",@"cate1-6.png",@"cate1-7.png",@"cate1-8.png",@"cate1.png",@"cate1-2.png",nil];
    categoryNames=[[NSMutableArray alloc]init];
    childcategoryNames=[[NSMutableArray alloc]init];
    childcategoryParent_id=[[NSMutableArray alloc]init];
    for(int i=0;i<librarydatas.count;i++){
        bookInfo=librarydatas[i];
        if(bookInfo[@"parent_id"]==[NSNull null]){
            [categoryNames addObject:bookInfo[@"name"]];
        }
        else{
            [childcategoryNames addObject:bookInfo[@"name"]];
            [childcategoryParent_id addObject:bookInfo[@"parent_id"]];
        }
    }
}

//Rota
/*-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    if (toInterfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
    }
    else if (toInterfaceOrientation==UIInterfaceOrientationLandscapeRight){
    }
    else if (toInterfaceOrientation==UIInterfaceOrientationPortrait){
    }
    else if (toInterfaceOrientation==UIInterfaceOrientationPortraitUpsideDown){
    }
}*/
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CategoryViewController* categoryVC=(CategoryViewController*)[segue destinationViewController];
    categoryVC.sent=@"bingo";
    /*if([[segue identifier] isEqualToString:@"category"]){
        CategoryViewController* categoryVC=(CategoryViewController*)[segue destinationViewController];
        categoryVC.categoryid=[[NSMutableArray alloc]init];
        categoryVC.categoryName=[[NSMutableArray alloc]init];
        NSArray *indexPath=[self.collectionView indexPathsForSelectedItems];
        NSIndexPath *index=[indexPath objectAtIndex:0];
        catenumber=[[NSString alloc]initWithFormat:@"%d",index.row+1];
        for (int i=0; i<childcategoryNames.count; i++) {
            if ([catenumber isEqualToString:childcategoryParent_id[i]]){
                [categoryVC.categoryName addObject:childcategoryNames[i]];
                [categoryVC.categoryid addObject:childcategoryParent_id[i]];
            }
        }
    }*/

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *newTopViewController;
    newTopViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"Category"];
    self.slidingViewController.topViewController = newTopViewController;
    [self.slidingViewController resetTopView];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return categoryNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PublicBooksCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"publicbookscell" forIndexPath:indexPath];
    [[cell categoryImage]setImage:[UIImage imageNamed:[categoryImages objectAtIndex:indexPath.item]]];
    [[cell categoryLable]setText:[categoryNames objectAtIndex:indexPath.item]];
    
    
    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
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
