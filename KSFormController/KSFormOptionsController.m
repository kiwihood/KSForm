//
//  KSFormOptionsController.m
//  EweiHelp
//
//  Created by Kiwi on 16/7/1.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import <objc/runtime.h>
#import "KSFormOptionsController.h"
#import "KSFormConfig.h"
#import "KSFormOptionCell.h"
#import "KSFormOptionsElement.h"

@interface KSFormOptionsController () <UITableViewDataSource, UITableViewDelegate> {
    UITableView * _tableView;
}
@property (strong, nonatomic) KSFormOptionsElement * element;

@end

@implementation KSFormOptionsController

const static char action_key;

- (instancetype)initWithElement:(KSFormOptionsElement*)element complete:(void(^)(NSArray * selectedObjects))completionHandler {
    if (self = [super init]) {
        // Initialization Code
        self.element = element;
        objc_removeAssociatedObjects(self);
        objc_setAssociatedObject(self, &action_key, completionHandler, OBJC_ASSOCIATION_COPY);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KSFormBackgroundColor;
    self.navigationItem.title = _element.title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDonePressed:)];
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
        
        _tableView.separatorInset = UIEdgeInsetsZero;
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        
        // Add Auto-Layout
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * formL = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint * formR = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint * formT = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint * formB = [NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        
        [self.view addConstraints:@[formL, formR, formT, formB]];
    }
    _tableView.tableFooterView = [UIView new];
    UIView * bkgV = [UIView new];
    bkgV.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = bkgV;
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)btnDonePressed:(id)sender {
//    KSFormMultiOptionsCompletionHandler completionHandler = objc_getAssociatedObject(self, &action_key);
//    if (completionHandler) {
//        @autoreleasepool {
//            _element.value = nil;
//            completionHandler(_element.value);
//        }
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)sender {
    return 1;
}
- (NSInteger)tableView:(UITableView *)sender numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    id <KSFormOptionObject> item = nil;
    for (id <KSFormOptionObject> item0 in _element.options) {
        if (item0.isOpened) {
            numberOfRows += item0.subOptions.count;
            item = item0;
            break;
        }
    }
    if (item) {
        while (item.isOpened) {
            item = nil;
            for (id <KSFormOptionObject> item0 in item.subOptions) {
                if (item0.isOpened) {
                    numberOfRows += item0.subOptions.count;
                    item = item0;
                    break;
                }
            }
        }
    }
    return _element.options.count;
}
- (UITableViewCell *)tableView:(UITableView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    KSFormOptionCell * cell = [sender dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[KSFormOptionCell alloc] initWithReuseIdentifier:identifier];
    }
    id <KSFormOptionObject> item = [_element.options objectAtIndex:indexPath.row];
    cell.item = item;
//    cell.checked = [_element getCheckedForIndex:(int)indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [sender deselectRowAtIndexPath:indexPath animated:YES];
//    BOOL checked = ![_element getCheckedForIndex:(int)indexPath.row];
//    [_element setChecked:checked forIndex:(int)indexPath.row];
//    KSFormOptionCell * cell = (KSFormOptionCell*)[sender cellForRowAtIndexPath:indexPath];
//    cell.checked = checked;
}

@end
