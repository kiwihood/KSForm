//
//  KSFormParagraphTextElement.h
//  EweiHelp
//
//  Created by Kiwi on 2017/2/27.
//  Copyright © 2017年 KSFramework. All rights reserved.
//

#import "KSFormElement.h"

@interface KSFormParagraphTextElement : KSFormElement

@property (strong, nonatomic) UITextView * textView;

+ (instancetype)elementWithKey:(NSString*)key defaultValue:(NSString*)defaultValue placeholder:(NSString*)placeholder;

@end
