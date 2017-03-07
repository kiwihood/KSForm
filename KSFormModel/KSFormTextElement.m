//
//  KSFormTextElement.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTextElement.h"

@interface KSFormTextElement () <UITextFieldDelegate>

@end

@implementation KSFormTextElement

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder {
    KSFormTextElement * element = [[self class] elementWithKey:key title:title];
    
    // UI
    UIView * view = element.customView;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleNone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.secureTextEntry = NO;
    textField.font = [UIFont systemFontOfSize:14];
    textField.delegate = element;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.text = defaultValue;
    textField.placeholder = placeholder;
    [view addSubview:textField];
    element.textField = textField;
    
    [[NSNotificationCenter defaultCenter] addObserver:element selector:@selector(notificationTextViewTextDidChange:) name:UITextViewTextDidChangeNotification object:textField];
    
    // Auto-Layout
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:KSFormContentLeftMargin + 8],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:-16]]];
    
    return element;
}

- (id)value {
    if ([_textField.text isKindOfClass:[NSString class]] && _textField.text.length > 0) return _textField.text;
    return nil;
}
- (void)setValue:(id)value {
    _textField.text = value;
}

- (BOOL)canBecomeFirstResponder {
    return [_textField canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [_textField canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    return [_textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [_textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)sender {
    [self.delegate elementWillBeginEditingIndexPath:self.indexPath];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.delegate elementWillEndEditingIndexPath:self.indexPath];
    return YES;
}

#pragma mark - Notifications
- (void)notificationTextViewTextDidChange:(NSNotification*)sender {
    if ([self.delegate respondsToSelector:@selector(elementValueChangeHandler:)]) {
        [self.delegate elementValueChangeHandler:self];
    }
}

@end
