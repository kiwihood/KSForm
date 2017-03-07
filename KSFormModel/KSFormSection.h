//
//  KSFormSection.h
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSFormSection : NSObject

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * footerDescription;// only for grouped style
@property (strong, nonatomic) NSArray * elements;

@property (assign, nonatomic) NSInteger section;

+ (instancetype)sectionWithTitle:(NSString*)title elements:(NSArray*)elements;

@end
