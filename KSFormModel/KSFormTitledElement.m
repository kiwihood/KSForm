//
//  KSFormTitledElement.m
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTitledElement.h"

@implementation KSFormTitledElement

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title {
    return [[[self class] alloc] initWithKey:key title:title];
}

- (id)initWithKey:(NSString*)key {
    if (self = [super initWithKey:key]) {
        // Initialization Code
        UIView * view = self.customView;
        
        UIFont * font = [UIFont systemFontOfSize:14];
        UILabel * labT = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100 - 16, font.lineHeight)];
        labT.backgroundColor = [UIColor clearColor];
        labT.lineBreakMode = NSLineBreakByTruncatingTail;
        labT.textAlignment = NSTextAlignmentLeft;
        labT.textColor = [UIColor blackColor];
        labT.font = font;
        labT.numberOfLines = 2;
        [view addSubview:labT];
        _labTitle = labT;
        
        // Auto-Layout
        labT.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraints:@[[NSLayoutConstraint constraintWithItem:labT attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:16],
                               [NSLayoutConstraint constraintWithItem:labT attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]]];
        [labT addConstraints:@[[NSLayoutConstraint constraintWithItem:labT attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:84],
                               [NSLayoutConstraint constraintWithItem:labT attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:38]]];
    }
    return self;
}

- (instancetype)initWithKey:(NSString*)key title:(NSString*)title {
    if ([self initWithKey:key]) {
        // Initialization Code
        self.title = title;
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    NSString * title_text = self.title;
    if (self.required) title_text = [title_text stringByAppendingString:@"*"];
    _labTitle.text = title_text;
}

- (void)setRequired:(BOOL)required {
    [super setRequired:required];
    NSString * title_text = self.title;
    if (self.required) title_text = [title_text stringByAppendingString:@"*"];
    _labTitle.text = title_text;
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
    if (editable) {
        self.customView.userInteractionEnabled = YES;
        self.customView.alpha = 1;
    } else {
        self.customView.userInteractionEnabled = NO;
        self.customView.alpha = 0.5;
    }
}

@end
