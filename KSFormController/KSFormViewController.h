//
//  KSFormViewController.h
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KSFormView, KSFormElement;

@interface KSFormViewController : UIViewController {
    UITableViewStyle _initializeTableViewStyle;
    KSFormView * _formView;
}

@property (strong, nonatomic) NSArray * formSections;
@property (assign, nonatomic) BOOL editingMode;

- (id)elementValueForKey:(NSString *)key;
- (__kindof KSFormElement*)elementForKey:(NSString*)key;

- (BOOL)checkAllElements;

@end
