//
//  KSFormElement.m
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormElement.h"
#import "KSFormConfig.h"

@implementation KSFormElement

+ (instancetype)elementWithKey:(NSString*)key {
    return [[[self class] alloc] initWithKey:key];
}

- (id)initWithKey:(NSString*)key {
    if (self = [super init]) {
        self.heightForRow = DefaultCellHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.editable = YES;
        self.key = key;
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        self.customView = view;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)value {
    // to be implemented in sub-classes
    return nil;
}

- (NSString*)textValue {
    // to be implemented in sub-classes
    return [self value];
}

- (BOOL)canBecomeFirstResponder {
    // to be implemented in sub-classes
    return NO;
}
- (BOOL)canResignFirstResponder {
    // to be implemented in sub-classes
    return NO;
}
- (BOOL)becomeFirstResponder {
    // to be implemented in sub-classes
    return NO;
}
- (BOOL)resignFirstResponder {
    // to be implemented in sub-classes
    return NO;
}

- (void)setAccessoryView:(UIView *)accessoryView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    _accessoryView = accessoryView;
}

@end
