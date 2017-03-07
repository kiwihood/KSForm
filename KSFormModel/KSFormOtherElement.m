//
//  KSFormOtherElement.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormOtherElement.h"

@interface KSFormOtherElement ()

@property (strong, nonatomic) UITextField * textField;

@end

@implementation KSFormOtherElement

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder selector:(SEL)selector {
    KSFormOtherElement * element = [[self class] elementWithKey:key title:title];
    element.selectionStyle = UITableViewCellSelectionStyleDefault;
    element.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    element.selector = selector;
    
    // UI
    UIView * view = element.customView;
    view.userInteractionEnabled = NO;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:14];
    textField.text = defaultValue;
    textField.placeholder = placeholder;
    [view addSubview:textField];
    element.textField = textField;
    
    // Auto-Layout
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:KSFormContentLeftMargin + 8],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
    
    return element;
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
    self.customView.userInteractionEnabled = NO;
}

- (id)value {
    if ([_textField.text isKindOfClass:[NSString class]] && _textField.text.length > 0) return _textField.text;
    return nil;
}
- (void)setValue:(id)value {
    _textField.text = value;
}

@end
