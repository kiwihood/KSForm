//
//  KSFormMultiOptionsElement.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormMultiOptionsElement.h"

@implementation KSFormMultiOptionsElement
@synthesize options = _options;

- (void)setOptions:(NSArray *)options {
    _options = options;
    _selections = malloc(_options.count * sizeof(_selections));
    for (int i = 0; i < _options.count; i ++) {
        id <KSFormOptionObject> item = [_options objectAtIndex:i];
        _selections[i] = item.isDefaultOption ? 1 : 0;
    }
    
    // to update field
    [self updateValue];
}

- (id)value {
    NSMutableArray * selections = [NSMutableArray array];
    for (int i = 0; i < _options.count; i ++) {
        id <KSFormOptionObject> item = [_options objectAtIndex:i];
        if (_selections[i]) {
            [selections addObject:item];
        }
    }
    return selections;
}
- (void)setValue:(id)value {
//    NSMutableArray * selections_title_arr = [NSMutableArray array];
//    for (int i = 0; i < _options.count; i ++) {
//        id <KSFormOptionObject> item = [_options objectAtIndex:i];
//        if (_selections[i]) {
//            [selections_title_arr addObject:item.title];
//        }
//    }
//    self.textField.text = [selections_title_arr componentsJoinedByString:@"、"];
    if ([value isKindOfClass:[NSArray class]]) {
        for (NSString * str in value) {
            for (int i = 0; i < _options.count; i ++) {
                id <KSFormOptionObject> item = [_options objectAtIndex:i];
                if ([item.title isEqualToString:str]) {
                    [self setChecked:YES forIndex:i];
                }
            }
        }
        self.textField.text = [value componentsJoinedByString:@"、"];
    } else if ([value isKindOfClass:[NSString class]]) {
        self.textField.text = (NSString*)value;
    }
}

- (void)updateValue {
    NSMutableArray * selections_title_arr = [NSMutableArray array];
    for (int i = 0; i < _options.count; i ++) {
        id <KSFormOptionObject> item = [_options objectAtIndex:i];
        if (_selections[i]) {
            [selections_title_arr addObject:item.title];
        }
    }
    self.textField.text = [selections_title_arr componentsJoinedByString:@"、"];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canResignFirstResponder {
    return NO;
}
- (BOOL)becomeFirstResponder {
    id <KSFormMultiOptionsElementDelegate> deleagte = (id <KSFormMultiOptionsElementDelegate>) self.delegate;
    if ([deleagte respondsToSelector:@selector(formMultiOptionsElementTriggered:)]) {
        [deleagte formMultiOptionsElementTriggered:self];
    }
    return NO;
}
- (BOOL)resignFirstResponder {
    return NO;
}

- (BOOL)getCheckedForIndex:(int)index {
    return _selections[index] > 0;
}
- (void)setChecked:(BOOL)checked forIndex:(int)index {
    _selections[index] = checked ? 1 : 0;
}

@end
