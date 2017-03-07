//
//  KSFormSection.m
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormSection.h"

@implementation KSFormSection

+ (instancetype)sectionWithTitle:(NSString*)title elements:(NSArray*)elements {
    return [[[self class] alloc] initWithTitle:title elements:elements];
}

- (id)initWithTitle:(NSString*)title elements:(NSArray*)elements {
    if (self = [super init]) {
        self.title = title;
        self.elements = elements;
    }
    return self;
}

@end
