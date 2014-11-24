//
//  MyBookViewController.h
//  MyLibrary
//
//  Created by Ants Lab on 13/9/11.
//  Copyright (c) 2013年 Ants Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
@interface MyBookViewController : UICollectionViewController{
    sqlite3 *db;
}
@property(strong,nonatomic) UIButton *menuBtn;
@end
