//
//  KSFormTextElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTitledElement.h"

@interface KSFormTextElement : KSFormTitledElement

@property (strong, nonatomic) UITextField * textField;
@property (strong, nonatomic) NSString * regexpString;

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder;

@end
