//
//  KSFormOptionCell.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormOptionCell.h"

@implementation KSFormOptionCell

- (instancetype)initWithReuseIdentifier:(NSString*)reuseIdentifier {
    if ([self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        // Initialization code
//        self.textLabel.font = [UIFont systemFontOfSize:14];
        
        UIFont * font = [UIFont systemFontOfSize:16];
        UILabel * lab = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, 100, font.lineHeight)];
        lab.numberOfLines = 1;
        lab.backgroundColor = [UIColor clearColor];
        lab.lineBreakMode = NSLineBreakByTruncatingTail;
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor blackColor];
        lab.font = font;
        [self.contentView addSubview:lab];
        _textLabel = lab;
        
        // Auto-Layout
        UIView * view = self.contentView;
        UIView * sub = _textLabel;
        sub.translatesAutoresizingMaskIntoConstraints = NO;
        [view addConstraints:@[[NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:8],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:-8],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:16],
                               [NSLayoutConstraint constraintWithItem:sub attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:-16]]];
    }
    return self;
}

- (void)setChecked:(BOOL)checked {
    _checked = checked;
    if (checked) self.accessoryType = UITableViewCellAccessoryCheckmark;
    else self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setItem:(id <KSFormOptionObject>)item {
    _textLabel.text = item.title;
}

@end
