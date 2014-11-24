//
//  CategoryViewController.h
//  MyLibrary
//
//  Created by Ants Lab on 13/9/13.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UICollectionViewController
@property NSMutableArray *categoryName;
@property NSMutableArray *categoryid;
@property NSString *sent;
@property(strong,nonatomic) UIButton *menuBtn;
@end
