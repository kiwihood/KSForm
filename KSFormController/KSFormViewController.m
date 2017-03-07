//
//  KSFormViewController.m
//  KSFormControllerDemo
//
//  Created by Kiwi on 16/6/28.
//  Copyright © 2016年 KSFramework. All rights reserved.
//

#import "KSFormViewController.h"
#import "KSFormConfig.h"
#import "KSFormDateToDateController.h"
#import "KSFormMultiOptionsController.h"
#import "KSFormElementDetailController.h"
#import "KSFormViewCell.h"
#import "KSFormView.h"
#import "KSFormToolbar.h"
#import "KSFormSection.h"
#import "KSFormElement.h"
#import "KSFormOtherElement.h"
#import "KSFormDateElement.h"
#import "KSFormMultiOptionsElement.h"
#import "KSFormTextElement.h"
#import "KSFormMultiTextElement.h"

@interface KSFormViewController () <UITableViewDataSource, UITableViewDelegate, KSFormElementDelegate>

@property (strong, nonatomic) KSFormToolbar * toolbar;
@property (strong, nonatomic) NSLayoutConstraint * topLayoutConstraint;
@property (strong, nonatomic) NSLayoutConstraint * bottomLayoutConstraint;
@property (strong, nonatomic) NSLayoutConstraint * leftLayoutConstraint;
@property (strong, nonatomic) NSLayoutConstraint * rightLayoutConstraint;
@property (strong, nonatomic) NSIndexPath * editingIndexPath;

@end

@implementation KSFormViewController

- (instancetype)init {
    if (self = [super init]) {
        // Initialization Code
        _editingMode = YES;
        _initializeTableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KSFormBackgroundColor;
    if (_formView == nil) {
        _formView = [[KSFormView alloc] initWithFrame:self.view.bounds style:_initializeTableViewStyle];
        _formView.dataSource = self;
        _formView.delegate = self;
        [self.view addSubview:_formView];
        
        _formView.separatorInset = UIEdgeInsetsZero;
        if ([_formView respondsToSelector:@selector(setLayoutMargins:)]) {
            _formView.layoutMargins = UIEdgeInsetsZero;
        }
        
        // Toolbar
        self.toolbar = [KSFormToolbar toolbarWithDelegate:self];
        [self.view addSubview:_toolbar];
        
        // Add Auto-Layout
        _formView.translatesAutoresizingMaskIntoConstraints = NO;
        _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint * formL = [NSLayoutConstraint constraintWithItem:_formView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint * formR = [NSLayoutConstraint constraintWithItem:_formView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint * formT = [NSLayoutConstraint constraintWithItem:_formView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        NSLayoutConstraint * formB = [NSLayoutConstraint constraintWithItem:_formView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        NSLayoutConstraint * barL = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0];
        NSLayoutConstraint * barR = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0];
        NSLayoutConstraint * barB = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:44];
        NSLayoutConstraint * barH = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:44];
        self.bottomLayoutConstraint = barB;
        
        [self.view addConstraints:@[formL, formR, formT, formB, barL, barR, barB]];
        [_toolbar addConstraints:@[barH]];
    }
    _formView.tableFooterView = [UIView new];
    UIView * bkgV = [UIView new];
    bkgV.backgroundColor = self.view.backgroundColor;
    _formView.backgroundView = bkgV;
    _formView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)setFormSections:(NSArray *)formSections {
    _formSections = formSections;
    [_formView reloadData];
}

- (id)elementValueForKey:(NSString *)key {
    return ((KSFormElement*)[self elementForKey:key]).value;
}

- (KSFormElement*)elementForKey:(NSString*)key {
    KSFormElement * result = nil;
    for (NSInteger i = 0; i < _formSections.count; i ++) {
        KSFormSection * formSection = [_formSections objectAtIndex:i];
        for (NSInteger j = 0; j < formSection.elements.count; j ++) {
            KSFormElement * element = [formSection.elements objectAtIndex:j];
            if ([element.key isEqualToString:key]) {
                result = element;
                break;
            }
        }
        if (result) break;
    }
    return result;
}

- (BOOL)checkAllElements {
    BOOL noProblems = YES;
    
    for (NSInteger i = 0; i < _formSections.count; i ++) {
        KSFormSection * formSection = [_formSections objectAtIndex:i];
        for (NSInteger j = 0; j < formSection.elements.count; j ++) {
            KSFormElement * element = [formSection.elements objectAtIndex:j];
#ifdef DEBUG
            NSLog(@"checked %@ : %@", element.title, element.value);
#endif
            if (element.required) {
                if (!element.value) {
                    if ([element isKindOfClass:[KSFormTextElement class]] || [element isKindOfClass:[KSFormMultiTextElement class]]) {
                        [self showAlertMessage:[NSString stringWithFormat:@"请填写“%@”", element.title]];
                    } else {
                        [self showAlertMessage:[NSString stringWithFormat:@"请选择“%@”", element.title]];
                    }
                    noProblems = NO; break;
                }
            }
            if ([element isKindOfClass:[KSFormTextElement class]]) {
                KSFormTextElement * text_element = (KSFormTextElement*)element;
                if ([text_element.regexpString isKindOfClass:[NSString class]] && text_element.regexpString.length > 0) {
                    NSString * text = text_element.value;
                    NSRegularExpression * reg = [NSRegularExpression regularExpressionWithPattern:text_element.regexpString options:NSRegularExpressionCaseInsensitive error:nil];
                    if (reg && ([text isKindOfClass:[NSString class]])) {
                        if ([reg rangeOfFirstMatchInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, text.length)].length != text.length) {
                            [self showAlertMessage:[NSString stringWithFormat:@"请填写有效的“%@”", element.title]];
                            noProblems = NO; break;
                        }
                    }
                }
            }
        }
        if (!noProblems) break;
    }
    
    return noProblems;
}

- (void)setBottomConstraint:(CGFloat)constraint {
    [self.view removeConstraint:_bottomLayoutConstraint];
    self.bottomLayoutConstraint = [NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-constraint];
    [self.view addConstraint:_bottomLayoutConstraint];
    UIEdgeInsets insets = _formView.contentInset; insets.bottom = 44 + constraint;
    _formView.contentInset = _formView.scrollIndicatorInsets = insets;
}

- (void)setEditingMode:(BOOL)editingMode {
    _editingMode = editingMode;
    [_formView reloadData];
}

- (void)showAlertMessage:(NSString*)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)resignAllKeyboards {
    for (KSFormSection * section in self.formSections) {
        for (KSFormElement * item in section.elements) {
            [item resignFirstResponder];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(KSFormView *)sender {
    return _formSections.count;
}
- (NSInteger)tableView:(KSFormView *)sender numberOfRowsInSection:(NSInteger)section {
    KSFormSection * formSection = [_formSections objectAtIndex:section];
    return formSection.elements.count;
}
- (UITableViewCell *)tableView:(KSFormView *)sender cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"cell";
    KSFormViewCell * cell = [sender dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[KSFormViewCell alloc] initWithReuseIdentifier:identifier];
    }
    KSFormSection * formSection = [_formSections objectAtIndex:indexPath.section];
    KSFormElement * element = [formSection.elements objectAtIndex:indexPath.row];
    
    [cell setSeparatorLastOne:indexPath.row == [self tableView:sender numberOfRowsInSection:indexPath.section] - 1 leftInset:16];
    cell.editingMode = _editingMode;
    cell.item = element;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(KSFormView *)sender heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KSFormSection * formSection = [_formSections objectAtIndex:indexPath.section];
    KSFormElement * element = [formSection.elements objectAtIndex:indexPath.row];
    element.indexPath = indexPath; element.delegate = self;
    return element.heightForRow;
}
- (void)tableView:(KSFormView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KSFormSection * formSection = [_formSections objectAtIndex:indexPath.section];
    KSFormElement * element = [formSection.elements objectAtIndex:indexPath.row];
    if (_editingMode) {
        if (element.editable) {
            if ([element canBecomeFirstResponder]) {
                [element becomeFirstResponder];
            } else {
                [sender deselectRowAtIndexPath:indexPath animated:YES];
                [self resignAllKeyboards];
                if ([element isKindOfClass:[KSFormOtherElement class]]) {
                    KSFormOtherElement * otherElement = (KSFormOtherElement*)element;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    if ([self respondsToSelector:otherElement.selector]) [self performSelector:otherElement.selector withObject:otherElement];
#pragma clang diagnostic pop
                }
            }
        }
    } else {
        [sender deselectRowAtIndexPath:indexPath animated:YES];
        if ([element isKindOfClass:[KSFormOtherElement class]]) {
            KSFormOtherElement * otherElement = (KSFormOtherElement*)element;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self respondsToSelector:otherElement.selector]) [self performSelector:otherElement.selector withObject:otherElement];
#pragma clang diagnostic pop
        } else {
            if ([element isKindOfClass:[KSFormTextElement class]] || [element isKindOfClass:[KSFormMultiTextElement class]] || [element isKindOfClass:[KSFormOptionsElement class]] || [element isKindOfClass:[KSFormMultiOptionsElement class]] || [element isKindOfClass:[KSFormDateElement class]]) {
                KSFormElementDetailController * con = [[KSFormElementDetailController alloc] initWithTitle:element.title content:element.textValue];
                [self.navigationController pushViewController:con animated:YES];
            }
        }
    }
}
const static CGFloat marginForSection = 10;
- (CGFloat)tableView:(KSFormView *)sender heightForHeaderInSection:(NSInteger)section {
    if (sender.style == UITableViewStyleGrouped) {
        if (section == 0) return marginForSection + marginForSection;
        return marginForSection;
    }
    return 0;
}
- (CGFloat)tableView:(KSFormView *)sender heightForFooterInSection:(NSInteger)section {
    if (sender.style == UITableViewStyleGrouped) {
        KSFormSection * formSection = [_formSections objectAtIndex:section];
        if ([formSection.footerDescription isKindOfClass:[NSString class]] && formSection.footerDescription.length > 0) {
            CGFloat height = marginForSection;
            NSString * text = formSection.footerDescription;
            CGSize size = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
            height += size.height + 0.5;
            return height + marginForSection;
        }
        if (section == [self numberOfSectionsInTableView:sender] - 1) return marginForSection + marginForSection;
        return marginForSection;
    }
    return 0;
}
- (UIView *)tableView:(KSFormView *)sender viewForHeaderInSection:(NSInteger)section {
    if (sender.style == UITableViewStyleGrouped) {
        // do nothing
    }
    return nil;
}
- (UIView *)tableView:(KSFormView *)sender viewForFooterInSection:(NSInteger)section {
    if (sender.style == UITableViewStyleGrouped) {
        KSFormSection * formSection = [_formSections objectAtIndex:section];
        if ([formSection.footerDescription isKindOfClass:[NSString class]] && formSection.footerDescription.length > 0) {
            UIView * view = [[UIView alloc] init];
            UIFont * font = [UIFont systemFontOfSize:14];
            NSString * text = formSection.footerDescription;
            CGSize size = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 32, 400) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(16, marginForSection, size.width, size.height)];
            lab.textColor = KSFormGrayTextColor;
            lab.font = font;
            lab.text = text;
            [view addSubview:lab];
            return view;
        }
    }
    return nil;
}


#pragma mark - KSFormElementDelegate
- (void)elementWillBeginEditingIndexPath:(NSIndexPath*)indexPath {
    if (self.editingIndexPath.section == indexPath.section && self.editingIndexPath.row == indexPath.row) return;
    self.editingIndexPath = indexPath;
    KSFormSection * formSection = [_formSections objectAtIndex:indexPath.section];
    KSFormElement * element = [formSection.elements objectAtIndex:indexPath.row];
    CGRect editingCellFrame = [_formView rectForRowAtIndexPath:_editingIndexPath];
    editingCellFrame = [_formView convertRect:editingCellFrame toView:self.view];
    if (editingCellFrame.origin.y < 64) {
        [UIView animateWithDuration:0.1 animations:^{
            [_formView setContentOffset:CGPointMake(0, _formView.contentOffset.y - (64 - editingCellFrame.origin.y)) animated:NO];
        } completion:^(BOOL finished) {
            [element becomeFirstResponder];
        }];
    } else {
        CGFloat offsetY = (editingCellFrame.origin.y + editingCellFrame.size.height) - (_formView.frame.origin.y + _formView.frame.size.height);
        if (offsetY > 0) {
            [UIView animateWithDuration:0.05 animations:^{
                [_formView setContentOffset:CGPointMake(0, _formView.contentOffset.y + offsetY) animated:NO];
            } completion:^(BOOL finished) {
                [element becomeFirstResponder];
            }];
        }
    }
#ifdef DEBUG
//    NSLog(@"begin - %@", [NSNumber numberWithInteger:_editingIndexPath.row]);
#endif
}
- (void)elementWillEndEditingIndexPath:(NSIndexPath*)indexPath {
    [_formView performSelector:@selector(deselectRowAtIndexPath:animated:) withObject:indexPath afterDelay:0.01];
//    [_formView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - KSFormDateElementDelegate
- (void)formDateElementSelectDateToDate:(KSFormDateElement*)sender {
    if (self.navigationController.visibleViewController != self) return;
    [_formView deselectRowAtIndexPath:[_formView indexPathForSelectedRow] animated:YES];
    KSFormDateToDateController * con = [[KSFormDateToDateController alloc] initWithElement:sender complete:^(NSDate *dateStart, NSDate *dateEnd) {
        if ([dateStart isKindOfClass:[NSDate class]] && [dateEnd isKindOfClass:[NSDate class]]) {
            sender.value = @{KSFormDateStartKey:dateStart, KSFormDateEndKey:dateEnd};
        }
    }];
    [self.navigationController pushViewController:con animated:YES];
    [self resignAllKeyboards];
}

#pragma mark - KSFormMultiOptionsElementDelegate
- (void)formMultiOptionsElementTriggered:(KSFormMultiOptionsElement*)sender {
    [_formView deselectRowAtIndexPath:[_formView indexPathForSelectedRow] animated:YES];
    KSFormMultiOptionsController * con = [[KSFormMultiOptionsController alloc] initWithElement:sender complete:^(NSArray *selectedObjects) {
        [sender updateValue];
    }];
    [self.navigationController pushViewController:con animated:YES];
    [self resignAllKeyboards];
}

#pragma mark - KSFormToolbarDelegate
- (void)formToolbarBackPressed:(id)sender {
#ifdef DEBUG
//    NSLog(@"back %@", [NSNumber numberWithInteger:_editingIndexPath.row]);
#endif
    KSFormSection * formSection = [_formSections objectAtIndex:_editingIndexPath.section];
    KSFormElement * element = nil;
    if (_editingIndexPath.row > 0) element = [formSection.elements objectAtIndex:_editingIndexPath.row - 1];
    else if (_editingIndexPath.section > 0) {
        formSection = [_formSections objectAtIndex:_editingIndexPath.section - 1];
        element = [formSection.elements objectAtIndex:formSection.elements.count - 1];
    }
    if (element.editable && [element canBecomeFirstResponder]) {
        [_formView selectRowAtIndexPath:element.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [element becomeFirstResponder];
    } else [self formToolbarDonePressed:nil];
}
- (void)formToolbarNextPressed:(id)sender {
#ifdef DEBUG
//    NSLog(@"next %@", [NSNumber numberWithInteger:_editingIndexPath.row]);
#endif
    KSFormSection * formSection = [_formSections objectAtIndex:_editingIndexPath.section];
    KSFormElement * element = nil;
    if (_editingIndexPath.row + 1 < formSection.elements.count) element = [formSection.elements objectAtIndex:_editingIndexPath.row + 1];
    else if (_editingIndexPath.section + 1 < _formSections.count) {
        formSection = [_formSections objectAtIndex:_editingIndexPath.section + 1];
        element = [formSection.elements objectAtIndex:0];
    }
    if (element.editable && [element canBecomeFirstResponder]) {
        [_formView selectRowAtIndexPath:element.indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        [element becomeFirstResponder];
    } else [self formToolbarDonePressed:nil];
}
- (void)formToolbarDonePressed:(id)sender {
#ifdef DEBUG
//    NSLog(@"done %@", [NSNumber numberWithInteger:_editingIndexPath.row]);
#endif
    KSFormSection * formSection = [_formSections objectAtIndex:_editingIndexPath.section];
    KSFormElement * element = [formSection.elements objectAtIndex:_editingIndexPath.row];
    if ([element canResignFirstResponder]) [element resignFirstResponder];
}

#pragma mark - Notifications
- (void)notificationKeyboardWillShow:(NSNotification*)sender {
    NSDictionary* userInfo = [sender userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationOptions animationCurve;
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
                     animations:^{
                         [self setBottomConstraint:keyboardEndFrame.size.height];
                         [self.view layoutIfNeeded];
                         // scroll if needed
                         CGRect editingCellFrame = [_formView rectForRowAtIndexPath:_editingIndexPath];
                         editingCellFrame = [_formView convertRect:editingCellFrame toView:self.view];
                         CGFloat offsetY = (editingCellFrame.origin.y + editingCellFrame.size.height) - (keyboardEndFrame.origin.y - 44);
                         if (offsetY > 0) {
                             [_formView setContentOffset:CGPointMake(0, _formView.contentOffset.y + offsetY) animated:NO];
                         }
                     } completion:^(BOOL finished){
                     }];
}
- (void)notificationKeyboardWillHide:(NSNotification*)sender {
    NSDictionary* userInfo = [sender userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationOptions animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration delay:0 options:animationCurve
                     animations:^{
                         [self setBottomConstraint:-44];
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished){
                     }];
}

@end
