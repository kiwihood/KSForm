//
//  KSFormBooleanElement.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormBooleanElement.h"

@implementation KSFormBooleanElement

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(BOOL)defaultValue {
    KSFormBooleanElement * element = [[self class] elementWithKey:key title:title];
    
    // UI
    UIView * view = element.customView;
    
    UISwitch * chSwitch = [[UISwitch alloc] init];
//    chSwitch.onTintColor = Color_Key;
    [chSwitch setOn:defaultValue];
    [chSwitch addTarget:element action:@selector(valueChangeHandler:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:chSwitch];
    element.checkSwitch = chSwitch;
    
    
    // Auto-Layout
    chSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraints:@[[NSLayoutConstraint constraintWithItem:chSwitch attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1 constant:-16],
                           [NSLayoutConstraint constraintWithItem:chSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]]];
    [chSwitch addConstraints:@[[NSLayoutConstraint constraintWithItem:chSwitch attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:chSwitch.bounds.size.width],
                          [NSLayoutConstraint constraintWithItem:chSwitch attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:chSwitch.bounds.size.height]]];
    
    return element;
}

- (id)value {
    return [NSNumber numberWithBool:_checkSwitch.isOn];
}
- (void)setValue:(id)value {
    [_checkSwitch setOn:[value boolValue]];
}

- (void)valueChangeHandler:(id)sender {
    if ([self.delegate respondsToSelector:@selector(elementValueChangeHandler:)]) {
        [self.delegate elementValueChangeHandler:self];
    }
}

@end
