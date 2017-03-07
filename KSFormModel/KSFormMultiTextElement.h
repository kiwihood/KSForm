//
//  KSFormMultiTextElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTextElement.h"

@interface KSFormMultiTextElement : KSFormTextElement

@property (strong, nonatomic) UITextView * textView;

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder;

@end
