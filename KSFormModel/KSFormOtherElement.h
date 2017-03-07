//
//  KSFormOtherElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTitledElement.h"

@interface KSFormOtherElement : KSFormTitledElement

@property (assign, nonatomic) SEL selector;

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder selector:(SEL)selector;

@end
