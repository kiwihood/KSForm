//
//  KSFormDateToDateController.m
//  EweiHelp
//
//  Created by Kiwi on 16/6/30.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <objc/runtime.h>
#import "KSFormDateToDateController.h"
#import "KSFormViewCell.h"
#import "KSFormView.h"
#import "KSFormToolbar.h"
#import "KSFormSection.h"
#import "KSFormDateElement.h"

typedef void(^KSFormDateToDateCompletionHandler) (NSDate * dateStart, NSDate * dateEnd);

@interface KSFormDateToDateController () {
}
@property (strong, nonatomic) KSFormDateElement * element;
@property (strong, nonatomic) KSFormDateElement * elementDateStart;
@property (strong, nonatomic) KSFormDateElement * elementDateEnd;

@end

@implementation KSFormDateToDateController

const static char action_key;

- (instancetype)initWithElement:(KSFormDateElement*)element complete:(void(^)(NSDate * dateStart, NSDate * dateEnd))completionHandler {
    if (self = [super init]) {
        // Initialization Code
        self.element = element;
        self.elementDateStart = [KSFormDateElement elementWithKey:@"start" title:@"开始" defaultValue:element.dateStart placeholder:nil];
        self.elementDateEnd = [KSFormDateElement elementWithKey:@"end" title:@"结束" defaultValue:element.dateEnd placeholder:nil];
        self.elementDateStart.dateMode = self.elementDateEnd.dateMode = element.dateMode;
        self.elementDateStart.value = element.dateStart;
        self.elementDateEnd.value = element.dateEnd;
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &action_key, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.element.title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDonePressed:)];
    self.formSections = [NSArray arrayWithObjects:[KSFormSection sectionWithTitle:@"x" elements:@[_elementDateStart, _elementDateEnd]], nil];
}

- (void)btnDonePressed:(id)sender {
    KSFormDateToDateCompletionHandler completionHandler = objc_getAssociatedObject(self, &action_key);
    if (completionHandler) {
        @autoreleasepool {
            completionHandler(_elementDateStart.value, _elementDateEnd.value);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - KSFormDateElementDelegate
- (void)elementValueChangeHandler:(KSFormElement*)sender {
    if (self.element.dateMode == UIDatePickerModeTime) return;
    if (sender == self.elementDateStart) {
        NSDate * value = self.elementDateStart.value;
        NSDate * valueOther = self.elementDateEnd.value;
        if ([valueOther isKindOfClass:[NSDate class]]) {
            if ([value timeIntervalSince1970] > [valueOther timeIntervalSince1970]) {
                self.elementDateEnd.value = value;
            }
        } else {
            self.elementDateEnd.value = value;
        }
    } else if (sender == self.elementDateEnd) {
        NSDate * value = self.elementDateEnd.value;
        NSDate * valueOther = self.elementDateStart.value;
        if ([valueOther isKindOfClass:[NSDate class]]) {
            if ([valueOther timeIntervalSince1970] > [value timeIntervalSince1970]) {
                self.elementDateStart.value = value;
            }
        } else {
            self.elementDateStart.value = value;
        }
    }
}

@end
