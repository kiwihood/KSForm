//
//  KSFormTitledElement.h
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormElement.h"

@interface KSFormTitledElement : KSFormElement {
    UILabel * _labTitle;
}

+ (instancetype)elementWithKey:(NSString*)key title:(NSString*)title;

@end
