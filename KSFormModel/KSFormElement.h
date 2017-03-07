//
//  KSFormElement.h
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KSFormContentLeftMargin 108

@class KSFormElement;

@protocol KSFormElementDelegate <NSObject>
- (void)elementWillBeginEditingIndexPath:(NSIndexPath*)indexPath;
- (void)elementWillEndEditingIndexPath:(NSIndexPath*)indexPath;
@optional
- (void)elementValueChangeHandler:(KSFormElement*)sender;
@end

@interface KSFormElement : NSObject

@property (unsafe_unretained, nonatomic) id <KSFormElementDelegate> delegate;

@property (strong, nonatomic) NSString * key;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSIndexPath * indexPath;
@property (strong, nonatomic) UIView * customView;
@property (strong, nonatomic) UIView * accessoryView;

@property (assign, nonatomic) CGFloat heightForRow;
@property (assign, nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property (assign, nonatomic) UITableViewCellAccessoryType accessoryType;
@property (assign, nonatomic) BOOL editable;
@property (assign, nonatomic) BOOL required;

@property (nonatomic) id value;
@property (nonatomic) NSString * textValue;

+ (instancetype)elementWithKey:(NSString*)key;
- (id)initWithKey:(NSString*)key;

- (BOOL)canBecomeFirstResponder;
- (BOOL)canResignFirstResponder;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;

@end
