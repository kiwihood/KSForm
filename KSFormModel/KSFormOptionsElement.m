//
//  KSFormOptionsElement.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormOptionsElement.h"

@interface KSFormOptionsElement () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
//    NSInteger _numberOfComponents;
}
//@property (readonly) NSInteger numberOfComponents;

@end

@implementation KSFormOptionsElement

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title placeholder:(NSString*)placeholder {
    KSFormOptionsElement * element = [[self class] elementWithKey:key title:title];
    element.selectionStyle = UITableViewCellSelectionStyleDefault;
    element.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
    
    // Auto-Layout
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1 constant:KSFormContentLeftMargin + 8],
                           [NSLayoutConstraint constraintWithItem:textField attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:0]]];
    
    return element;
}

- (void)dealloc {
    if (_selections) {free(_selections); _selections = NULL;}
}

- (void)setEditable:(BOOL)editable {
    [super setEditable:editable];
    self.customView.userInteractionEnabled = NO;
}

- (short)getDefaultIndexOfOptions:(NSArray *)options {
    short index = KSFormOptionDefaultSelection;
    for (short i = 0; i < options.count; i ++) {
        id <KSFormOptionObject> item = [options objectAtIndex:i];
        if (item.isDefaultOption) {
            index = i;
        }
    }
    return index;
}
- (short)getIndexOfValue:(NSString*)value inOptions:(NSArray *)options {
    short index = 0;
    for (short i = 0; i < options.count; i ++) {
        id <KSFormOptionObject> item = [options objectAtIndex:i];
        if ([item.title isEqualToString:value]) {
            index = i;
        }
    }
    return index;
}

- (void)setOptions:(NSArray *)options {
    _options = options;
    
    int count = (int)self.numberOfComponents;
    _selections = malloc(count * sizeof(_selections));
    
    if ([_options isKindOfClass:[NSArray class]] && _options.count > 0) {
        _selections[0] = [self getDefaultIndexOfOptions:_options];
        
        // Avoid 'Default Value' as default
        if (_selections[0] == KSFormOptionDefaultSelection) {
            for (NSInteger i = 0; i < count; i ++) {
                _selections[i] = KSFormOptionDefaultSelection;
            }
            return;
        }
        
        NSInteger crtComponent = 0;
        id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
        NSMutableString * value = [NSMutableString stringWithString:item.title];
        while ([item.subOptions isKindOfClass:[NSArray class]] && item.subOptions.count > 0) {
            crtComponent ++;
            _selections[crtComponent] = [self getDefaultIndexOfOptions:item.subOptions];
            
//            NSLog(@"set - %d", _selections[crtComponent]);
            
            // Avoid 'Default Value' as default
            if (_selections[crtComponent] == KSFormOptionDefaultSelection) _selections[crtComponent] = 0;
//            NSLog(@"_selections [%td] = %d", crtComponent, _selections[crtComponent]);
            item = [item.subOptions objectAtIndex:_selections[crtComponent]];
            [value appendFormat:@" - %@", item.title];
        }
        
        _textField.text = value;
    }
}
- (NSInteger)selectionAtIndex:(NSInteger)index {
    return _selections[index];
}
- (void)setSelection:(NSInteger)selection atIndex:(NSInteger)index {
    _selections[index] = selection;
}

- (id)value {
    // Avoid 'Default Value' as default
    if (_selections[0] == KSFormOptionDefaultSelection) return nil;
    if (!([_options isKindOfClass:[NSArray class]] && _options.count > 0)) return nil;
    
    NSInteger crtComponent = 0;
    id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
    NSMutableArray * valueArr = [NSMutableArray arrayWithObject:item];
    while (crtComponent < self.numberOfComponents - 1) {
        crtComponent ++;
        // Avoid 'Default Value' as default
        if (_selections[crtComponent] == KSFormOptionDefaultSelection) break;
        
        if (!(item.subOptions.count > 0)) break;
        item = [item.subOptions objectAtIndex:_selections[crtComponent]];
        [valueArr addObject:item];
    }
    return valueArr;
}
- (NSString*)textValue {
    return self.textField.text;
}

- (void)setValue:(id)value {
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSInteger i = 0; i < ((NSArray*)value).count; i ++) {
            NSString * str = [value objectAtIndex:i];
            NSArray * options = _options;
            NSInteger depth = 0;
            while ([options isKindOfClass:[NSArray class]] && options.count > 0 && depth <= i) {
                NSInteger index = [self getIndexOfValue:str inOptions:options];
                [self setSelection:index atIndex:i];
                options = ((id <KSFormOptionObject>) [options objectAtIndex:index]).subOptions;
                depth ++;
            }
        }
        self.textField.text = [value componentsJoinedByString:@" - "];
    } else if ([value isKindOfClass:[NSString class]]) {
        self.textField.text = (NSString*)value;
    }
}

- (void)updateValue {
    if (_selections[0] == KSFormOptionDefaultSelection) return;
    if (!([_options isKindOfClass:[NSArray class]] && _options.count > 0)) return;
    NSInteger crtComponent = 0;
    id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
    NSMutableString * value = [NSMutableString stringWithString:item.title];
    while (crtComponent < self.numberOfComponents - 1) {
        crtComponent ++;
        // Avoid 'Default Value' as default
        if (_selections[crtComponent] == KSFormOptionDefaultSelection) break;
        
//        NSLog(@"%d", _selections[crtComponent]);
        
        if (!(item.subOptions.count > 0)) break;
        item = [item.subOptions objectAtIndex:_selections[crtComponent]];
        [value appendFormat:@" - %@", item.title];
    }
    _textField.text = value;
}

- (BOOL)canBecomeFirstResponder {
    return [_textField canBecomeFirstResponder];
}
- (BOOL)canResignFirstResponder {
    return [_textField canResignFirstResponder];
}
- (BOOL)becomeFirstResponder {
    if ([_options isKindOfClass:[NSArray class]] && _options.count > 0) {
        // Avoid 'Default Value' as default
        for (NSInteger i = 0; i < self.numberOfComponents; i ++) {
            if (_selections[i] == KSFormOptionDefaultSelection) {_selections[i] = 0;}
        }
        [self updateValue];
            
        _textField.inputView = [self pickerView];
        return [_textField becomeFirstResponder];
    } else {
        id <KSFormOptionsElementDelegate> delegate = (id <KSFormOptionsElementDelegate>)self.delegate;
        if ([delegate respondsToSelector:@selector(formOptionsElementRequiredData:complete:)]) {
            [delegate formOptionsElementRequiredData:self complete:^(NSArray *options) {
                @autoreleasepool {
                    if (options.count > 0) {
                        self.options = options;
                        // Avoid 'Default Value' as default
                        BOOL shouldInsert = NO;
                        for (NSInteger i = 0; i < self.numberOfComponents; i ++) {
//                            NSLog(@"_selections [%td] = %d", i, _selections[i]);
                            if (_selections[i] == KSFormOptionDefaultSelection) {_selections[i] = 0; shouldInsert = YES;}
                        }
                        if (shouldInsert) [self updateValue];
                        
                        _textField.inputView = [self pickerView];
                        [_textField becomeFirstResponder];
                    } else {
                        [self.delegate elementWillEndEditingIndexPath:self.indexPath];
                    }
                }
            }];
        }
        return NO;
    }
}
- (BOOL)resignFirstResponder {
    return [_textField resignFirstResponder];
}

// Calculate Depth of the sub-options
- (NSInteger)subOptionsDepth:(id <KSFormOptionObject>)item {
    NSInteger result = 0;
    if (item.subOptions.count > 0) {
        result = 1;
        NSInteger maxOne = 0;
        for (id <KSFormOptionObject> subItem in item.subOptions) {
            NSInteger subDepth = [self subOptionsDepth:subItem];
            if (maxOne < subDepth) {
                maxOne = subDepth;
            }
        }
        result += maxOne;
    }
    return result;
}

- (NSInteger)numberOfComponents {
    if (!(_options.count > 0)) return 0;
    if (_numberOfComponents <= 0) {
        _numberOfComponents = 1;
        NSInteger maxOne = 0;
        for (id <KSFormOptionObject> item in _options) {
            NSInteger number = [self subOptionsDepth:item];
            
            if (maxOne < number) {
                maxOne = number;
            }
        }
        _numberOfComponents += maxOne;
    }
    return _numberOfComponents;
}

/*
- (NSArray*)optionsHasSubOptions:(id <KSFormOptionObject>)item {
    NSMutableArray * optionsHasSub = [NSMutableArray array];
    if ([item.subOptions isKindOfClass:[NSArray class]] && item.subOptions.count > 0) {
        for (NSInteger i = 0; i < item.subOptions.count; i ++) {
            id <KSFormOptionObject> obj = [item.subOptions objectAtIndex:i];
            if ([obj.subOptions isKindOfClass:[NSArray class]] && obj.subOptions.count > 0) {
                [optionsHasSub addObject:obj];
            }
        }
    }
    if (optionsHasSub.count == 0) optionsHasSub = nil;
    return optionsHasSub;
}*/

- (UIPickerView*)pickerView {
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    for (NSInteger i = 0; i < self.numberOfComponents; i ++) {
        [pickerView selectRow:_selections[i] inComponent:i animated:NO];
    }
    return pickerView;
}

- (id <KSFormOptionObject>)selectedItem {
    // Avoid 'Default Value' as default
    if (_selections[0] == KSFormOptionDefaultSelection) return nil;
    return [self itemAtComponent:self.numberOfComponents - 1];
}
- (id <KSFormOptionObject>)itemAtComponent:(NSInteger)component {
    NSInteger crtComponent = 0;
    id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
    while (crtComponent < component && item.subOptions.count > 0) {
        crtComponent ++;
        // Avoid 'Default Value' as default
        if (_selections[crtComponent] == KSFormOptionDefaultSelection) return item;
        
        item = [item.subOptions objectAtIndex:_selections[crtComponent]];
    }
    return item;
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

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)sender {
    return self.numberOfComponents;
}
- (NSInteger)pickerView:(UIPickerView *)sender numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) return _options.count;
    NSInteger crtComponent = 0;
    id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
    id <KSFormOptionObject> item_parent = item;
    while (crtComponent < component) {
        if (!(item.subOptions.count > 0)) return 0;
        crtComponent ++;
        item_parent = item;
        item = [item.subOptions objectAtIndex:_selections[crtComponent]];
    }
    return item_parent.subOptions.count;
}
#pragma mark - UIPickerViewDelegate
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    NSString * text = nil;
    if (component == 0) {
        id <KSFormOptionObject> item = [_options objectAtIndex:row];
        text = item.title;
    }
    if (text == nil) {
        NSInteger crtComponent = 0;
        id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
        while (crtComponent < component - 1) {
            crtComponent ++;
            item = [item.subOptions objectAtIndex:_selections[crtComponent]];
        }
        item = [item.subOptions objectAtIndex:row];
        text = item.title;
    }
    
    UIFont * font = [UIFont systemFontOfSize:16];
    CGSize size = [text boundingRectWithSize:CGSizeMake(pickerView.frame.size.width / self.numberOfComponents, font.lineHeight * 2.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font;
    label.text = text;
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
//- (NSString *)pickerView:(UIPickerView *)sender titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    if (component == 0) {
//        id <KSFormOptionObject> item = [_options objectAtIndex:row];
//        return item.title;
//    }
//    NSInteger crtComponent = 0;
//    id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
//    while (crtComponent < component - 1) {
//        crtComponent ++;
//        item = [item.subOptions objectAtIndex:_selections[crtComponent]];
//    }
//    item = [item.subOptions objectAtIndex:row];
//    return item.title;
//}
- (void)pickerView:(UIPickerView *)sender didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_selections[component] != row) {
        _selections[component] = row;
        for (NSInteger i = component + 1; i < self.numberOfComponents; i ++) {
            _selections[i] = 0;
            [sender reloadComponent:i];
            [sender selectRow:_selections[i] inComponent:i animated:NO];
        }
        
        // value
        NSInteger crtComponent = 0;
        id <KSFormOptionObject> item = [_options objectAtIndex:_selections[crtComponent]];
        NSMutableString * value = [NSMutableString stringWithString:item.title];
        while (crtComponent < self.numberOfComponents - 1) {
            crtComponent ++;
            if (!(item.subOptions.count > 0)) break;
            item = [item.subOptions objectAtIndex:_selections[crtComponent]];
            [value appendFormat:@" - %@", item.title];
        }
        _textField.text = value;
        
        if ([self.delegate respondsToSelector:@selector(elementValueChangeHandler:)]) {
            [self.delegate elementValueChangeHandler:self];
        }
    }
}

@end
