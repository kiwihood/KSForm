//
//  KSFormBooleanElement.h
//  EweiHelp
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormTitledElement.h"

@interface KSFormBooleanElement : KSFormTitledElement

@property (strong, nonatomic) UISwitch * checkSwitch;

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title defaultValue:(BOOL)defaultValue;

@end
