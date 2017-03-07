//
//  KSFormParagraphTextElement.m
//  EweiHelp
//
//  Created by Kiwi on 2017/2/27.
//  Copyright © 2017年 KSFramework. All rights reserved.
//

#import "KSFormParagraphTextElement.h"
#import "KSFormConfig.h"

@interface KSFormParagraphTextElement () <UITextViewDelegate> {
    UILabel * _labelPlaceholder;
}
@property (nonatomic) NSString * placeholder;

@end

@implementation KSFormParagraphTextElement

+ (instancetype)elementWithKey:(NSString*)key defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder {
    KSFormParagraphTextElement * element = [[self class] elementWithKey:key];
    element.heightForRow = 100;
    
    // UI
    UIView * view = element.customView;
    
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.autocorrectionType = UITextAutocorrectionTypeNo;
    textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textView.secureTextEntry = NO;
    textView.font = [UIFont systemFontOfSize:14];
    textView.delegate = element;
    textView.keyboardType = UIKeyboardTypeDefault;
    textView.text = defaultValue;
    [view addSubview:textView];
    element.textView = textView;
    element.placeholder = placeholder;
    
    [[NSNotificationCenter defaultCenter] addObserver:element selector:@selector(notificationTextViewTextDidChange:) name:UITextViewTextDidChangeNotification object:textView];
    
    // Auto-Layout
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:8],
                           [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:-8],
                           [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:8],
                           [NSLayoutConstraint constraintWithItem:textView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:-8]]];
    
    return element;
}

- (void)setPlaceholder:(NSString*)placeholder {
    if (_labelPlaceholder == nil) {
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, _textView.frame.size.width - 16, _textView.font.lineHeight)];
        lab.font = _textView.font;
        lab.textColor = KSFormPlaceholderColor;
        lab.numberOfLines = 1;
        [_textView addSubview:lab];
        _labelPlaceholder = lab;
        
        // Auto-Layout
        lab.translatesAutoresizingMaskIntoConstraints = NO;
        [lab addConstraint:[NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:_textView.font.lineHeight]];
        [_textView addConstraints:@[[NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_textView attribute:NSLayoutAttributeTop multiplier:1 constant:8],
                                    [NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_textView attribute:NSLayoutAttributeLeft multiplier:1 constant:8],
                                    [NSLayoutConstraint constraintWithItem:lab attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_textView attribute:NSLayoutAttributeRight multiplier:1 constant:-8]]];
    }
    
    _labelPlaceholder.text = placeholder;
    _labelPlaceholder.hidden = ([_textView.text isKindOfClass:[NSString class]] && _textView.text.length > 0);
}

- (id)value {
    if ([_textView.text isKindOfClass:[NSString class]]) return _textView.text;
    return nil;
}
- (void)setValue:(id)value {
    _textView.text = value;
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:_textView];
}

- (BOOL)canBecomeFirstResponder {
    return [_textView canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [_textView canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    return [_textView becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [_textView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextField *)sender {
    [self.delegate elementWillBeginEditingIndexPath:self.indexPath];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextField *)textField {
    [self.delegate elementWillEndEditingIndexPath:self.indexPath];
    return YES;
}

#pragma mark - Notifications
- (void)notificationTextViewTextDidChange:(NSNotification*)sender {
    _labelPlaceholder.hidden = ([_textView.text isKindOfClass:[NSString class]] && _textView.text.length > 0);
    if ([self.delegate respondsToSelector:@selector(elementValueChangeHandler:)]) {
        [self.delegate elementValueChangeHandler:self];
    }
}

@end
