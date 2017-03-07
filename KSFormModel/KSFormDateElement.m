//
//  KSFormDateElement.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormDateElement.h"

@interface KSFormDateElement () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField * textField;

@end

@implementation KSFormDateElement

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(id)defaultValue placeholder:(NSString*)placeholder {
    KSFormDateElement * element = [[self class] elementWithKey:key title:title];
    element.selectionStyle = UITableViewCellSelectionStyleDefault;
    element.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    element.dateMode = UIDatePickerModeDate;
    
    // UI
    UIView * view = element.customView;
    view.userInteractionEnabled = NO;
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = placeholder;
    textField.delegate = element;
    textField.tintColor = [UIColor clearColor];
    [view addSubview:textField];
    element.textField = textField;
    
    if ([defaultValue isKindOfClass:[NSDictionary class]]) {
//        NSDictionary * defaultDic = (NSDictionary*)defaultValue;
//        element.dateStart = [defaultDic objectForKey:KSFormDateStartKey];
//        element.dateEnd = [defaultDic objectForKey:KSFormDateEndKey];
        element.value = defaultValue;
    } else if ([defaultValue isKindOfClass:[NSDate class]]) {
        element.value = defaultValue;
    }
    
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
    if (_dateToDate && self.dateStart && self.dateEnd) {
        return @{KSFormDateStartKey:self.dateStart, KSFormDateEndKey:self.dateEnd};
    }
//    if (_textField.text.hasValue) {
//        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
//        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
//        BOOL hasAMPM = containsA.location != NSNotFound;
//        NSString * timeFormatter;
//        // 12-hours style
//        if (hasAMPM) {
//            timeFormatter = @"h:mm a";
//        } else {// 24-hours style
//            timeFormatter = @"HH:mm";
//        }
//        NSString * formatter = @"yyyy-M-dd";
//        if (_dateMode == UIDatePickerModeDateAndTime) formatter = [formatter stringByAppendingFormat:@" %@", timeFormatter];
//        else if (_dateMode == UIDatePickerModeTime) formatter = timeFormatter;
//        
//        return [NSDate dateFromString:_textField.text formatter:formatter];
//    }
    return _date;
}
- (NSString*)textValue {
    return self.textField.text;
}

- (void)setValue:(NSDate*)value {
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dateDic = (NSDictionary*)value;
        self.dateStart = [dateDic objectForKey:KSFormDateStartKey];
        self.dateEnd = [dateDic objectForKey:KSFormDateEndKey];
        return;
    } else if ([value isKindOfClass:[NSDate class]]) {
        self.date = value;
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM = containsA.location != NSNotFound;
        NSString * timeFormatter;
        // 12-hours style
        if (hasAMPM) {
            timeFormatter = @"h:mm a";
        } else {// 24-hours style
            timeFormatter = @"H:mm";
        }
        NSString * format = @"yyyy-M-dd";
        if (_dateMode == UIDatePickerModeDateAndTime) format = [format stringByAppendingFormat:@" %@", timeFormatter];
        else if (_dateMode == UIDatePickerModeTime) format = timeFormatter;
        
        _textField.text = [self stringFromDate:value format:format];
    }
}

- (void)setDateMode:(UIDatePickerMode)dateMode {
    if (_dateMode != dateMode) {
        _dateMode = dateMode;
    }
}

- (BOOL)canBecomeFirstResponder {
    return [_textField canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [_textField canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    if (_dateToDate) {
        // For Date To Date Only
        id <KSFormDateElementDelegate> deleagte = (id <KSFormDateElementDelegate>) self.delegate;
        if ([deleagte respondsToSelector:@selector(formDateElementSelectDateToDate:)]) {
            [deleagte formDateElementSelectDateToDate:self];
        }
        return NO;
    }
    // avoid nil date
    if (!([_textField.text isKindOfClass:[NSString class]] && _textField.text.length > 0)) self.value = [NSDate date];
    
    _textField.inputView = [self pickerView];
    return [_textField becomeFirstResponder];
}
- (BOOL)resignFirstResponder {
    return [_textField resignFirstResponder];
}

- (UIDatePicker*)pickerView {
    UIDatePicker * pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    pickerView.datePickerMode = self.dateMode;
    pickerView.date = self.value;
    [pickerView addTarget:self action:@selector(pickerValueDidChange:) forControlEvents:UIControlEventValueChanged];
    return pickerView;
}
- (void)pickerValueDidChange:(UIDatePicker*)sender {
    self.value = sender.date;
    
    if ([self.delegate respondsToSelector:@selector(elementValueChangeHandler:)]) {
        [self.delegate elementValueChangeHandler:self];
    }
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

/* 
 --- For Date To Date Only ---
 */

- (void)setDateToDate:(BOOL)dateToDate {
    _dateToDate = dateToDate;
    [self updateDateInField];
}

- (void)setDateStart:(NSDate *)dateStart {
    _dateStart = dateStart;
    [self updateDateInField];
}

- (void)setDateEnd:(NSDate *)dateEnd {
    _dateEnd = dateEnd;
    [self updateDateInField];
}

- (void)updateDateInField {
    if ([_dateStart isKindOfClass:[NSDate class]] && [_dateEnd isKindOfClass:[NSDate class]]) {
        NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
        NSRange containsA = [formatStringForHours rangeOfString:@"a"];
        BOOL hasAMPM = containsA.location != NSNotFound;
        NSString * timeFormatter;
        // 12-hours style
        if (hasAMPM) {
            timeFormatter = @"h:mm a";
        } else {// 24-hours style
            timeFormatter = @"H:mm";
        }
        NSString * format = @"yyyy-M-dd";
        if (_dateMode == UIDatePickerModeDateAndTime) format = [format stringByAppendingFormat:@" %@", timeFormatter];
        else if (_dateMode == UIDatePickerModeTime) format = timeFormatter;
        
        NSString * dateStartStr = [self stringFromDate:_dateStart format:format];
        NSString * dateEndStr = [self stringFromDate:_dateEnd format:format];
        _textField.text = [NSString stringWithFormat:@"%@ ~ %@", dateStartStr, dateEndStr];
    }
}

- (NSString*)stringFromDate:(NSDate*)date format:(NSString*)format {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString * res = [formatter stringFromDate:date];
    if ([res hasPrefix:@"0"]) {
        res = [res substringFromIndex:1];
    }
    return res;
}

@end
