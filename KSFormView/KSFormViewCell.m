//
//  KSFormViewCell.m
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormViewCell.h"
#import "KSFormBooleanElement.h"

@implementation KSFormViewCell

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier {
    if ([self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }
    return self;
}

- (void)setSeparatorLastOne:(BOOL)lastOne leftInset:(CGFloat)left {
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        if (lastOne) {
            self.separatorInset = UIEdgeInsetsZero;
        } else {
            self.separatorInset = UIEdgeInsetsMake(0, left, 0, 0);
        }
    }
}

- (void)setItem:(KSFormElement *)item {
    for (UIView * sub in self.contentView.subviews) {
        [sub removeFromSuperview];
    }
    
    if (_editingMode) {
        for (UIView * sub in item.customView.subviews) {
            sub.userInteractionEnabled = YES;
        }
        self.accessoryType = item.accessoryType;
        if (item.editable) {
            self.selectionStyle = item.selectionStyle;
            UIView * backgroundView = [UIView new];
            backgroundView.backgroundColor = [UIColor whiteColor];
            self.backgroundView = backgroundView;
        } else {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView * backgroundView = [UIView new];
            backgroundView.backgroundColor = [UIColor colorWithWhite:0.9608 alpha:1];
            self.backgroundView = backgroundView;
        }
    } else {
        for (UIView * sub in item.customView.subviews) {
            sub.userInteractionEnabled = NO;
        }
        if ([item isKindOfClass:[KSFormBooleanElement class]]) {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        UIView * backgroundView = [UIView new];
        backgroundView.backgroundColor = [UIColor whiteColor];
        self.backgroundView = backgroundView;
    }
    
    //
    if (item.accessoryView && item.customView) {
        [self.contentView addSubview:item.customView];
        [self.contentView addSubview:item.accessoryView];
        
        // Auto-Layout
        UIView * view = self.contentView;
        UIView * acc = item.accessoryView;
        acc.translatesAutoresizingMaskIntoConstraints = NO;
        [acc addConstraints:@[[NSLayoutConstraint constraintWithItem:acc attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:acc.frame.size.width]]];
        [view addConstraints:@[[NSLayoutConstraint constraintWithItem:acc attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:acc attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:acc attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
        UIView * sub = item.customView;
        sub.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraints:@[[NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:acc attribute:NSLayoutAttributeLeft multiplier:1 constant:0]]];
    } else if (item.customView) {
        [self.contentView addSubview:item.customView];
        
        // Auto-Layout
        UIView * view = self.contentView;
        UIView * sub = item.customView;
        sub.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraints:@[[NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:0],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGRect contentFrame = self.contentView.frame;
//    contentFrame.origin.x += 128;
//    contentFrame.size.width -= 128;
//    self.contentView.frame = contentFrame;
}

@end
