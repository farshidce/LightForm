//
//  LightFormViewController.m
//  LightForm
//
//  Created by Farshid Ghods on 12/8/16.
//  Copyright © 2016 Farshid Ghods. All rights reserved.
//

#import <LightForm/LightFormCellData.h>
#import <LightForm/LightFormCell.h>
#import <LightForm/LightForm.h>
#import "LightFormViewController.h"

@interface LightFormViewController ()

@end

@implementation LightFormViewController


NSArray *form;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LightFormCell class] forCellReuseIdentifier:@"LightFormCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DemoSectionCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    form = [self createFormData];
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [form count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = nil;
    if (indexPath.section == 0) {
        cellIdentifier = @"DemoSectionCell";
    } else if (indexPath.section == 1) {
        cellIdentifier = @"LightFormCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                            forIndexPath:indexPath];
    if (cell == nil) {
        if ([cellIdentifier isEqualToString:@"DemoSectionCell"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        }
        if ([cellIdentifier isEqualToString:@"LightFormCell"]) {
            cell = [[LightFormCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:cellIdentifier];
        }
    }
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self tableView:tableView willDisplayHeaderCell:cell];
    } else if (indexPath.section == 1) {
        [self tableView:tableView willDisplayLightFormCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)    tableView:(UITableView *)tableView
willDisplayHeaderCell:(UITableViewCell *)cell {
    cell.textLabel.text = @"LightForm Demo";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)       tableView:(UITableView *)tableView
willDisplayLightFormCell:(UITableViewCell *)cell
       forRowAtIndexPath:(NSIndexPath *)indexPath {
    LightFormCell *lightFormCell = (LightFormCell *) cell;
    lightFormCell.style = [self createCellStyle];
    lightFormCell.data = [LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]];
    if ([form[(NSUInteger) indexPath.row][@"key"] isEqualToString:@"username"]) {
        [self tableView:tableView
willDisplayUsernameCell:lightFormCell
      forRowAtIndexPath:indexPath];
    } else if ([form[(NSUInteger) indexPath.row][@"key"] isEqualToString:@"password"]) {
        [self tableView:tableView
willDisplayPasswordCell:lightFormCell
      forRowAtIndexPath:indexPath];
    } else if ([form[(NSUInteger) indexPath.row][@"key"] isEqualToString:@"confirm"]) {
        [self        tableView:tableView
willDisplayConfirmPasswordCell:lightFormCell
             forRowAtIndexPath:indexPath];
    }
    [cell setNeedsLayout];
}

- (LightFormDefaultStyle *)createCellStyle {
    LightFormDefaultStyle *style = [[LightFormDefaultStyle alloc] init];
    style.autocorrectionType = UITextAutocorrectionTypeNo;
    // set the border color to dark blue when not selected
    style.borderColor = UIColor.blackColor;
    // set the border color to orange when selected
    style.selectedBorderColor = UIColor.orangeColor;
    return style;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 40.0;
    } else {
        return [LightFormCell cellHeightForData:[LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]]
                                      withStyle:[[LightFormDefaultStyle alloc] init]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return 0;
}


- (void)      tableView:(UITableView *)tableView
willDisplayUsernameCell:(LightFormCell *)cell
      forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        NSLog(@"executeBlock %d %d for cell at row %tu", focused, returned, indexPath.row);
        // if user has not entered any text but is focused show the validations
        // if user has entered some text then if they are compliant then dont show any of the validations
        BOOL updateNeeded = input != nil || focused;
        if (input) {
            data.validations = [LightFormViewController isUsernameCompliant:input] ? nil : [LightFormViewController usernameCompliance:input];
        } else if (focused) {
            data.validations = [LightFormViewController usernameCompliance:input];
        }
        if (returned) {
            data.value = input;
            data.validations = nil;
        }
        if (goToNext) {
            UIResponder *nextResponder = [self.view viewWithTag:cell.tag + 1];
            [nextResponder becomeFirstResponder];
        }
        if (updateNeeded) {
            [tableView beginUpdates];
            [tableView endUpdates];
        }
    }];
}

- (void)      tableView:(UITableView *)tableView
willDisplayPasswordCell:(LightFormCell *)cell
      forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        NSLog(@"executeBlock %d %d for cell at row %tu", focused, returned, indexPath.row);
        // if user has not entered any text but is focused show the validations
        // if user has entered some text then if they are compliant then dont show any error
        // otherwise show validations
        BOOL updateNeeded = input != nil || focused;
        if (input) {
            data.validations = [LightFormViewController isPasswordCompliant:input] ?
                    nil : [LightFormViewController passwordCompliance:input];
        } else if (focused) {
            data.validations = [LightFormViewController passwordCompliance:input];
        }
        if (returned) {
            data.value = input;
            data.validations = nil;
        }
        if (updateNeeded) {
            [tableView beginUpdates];
            [tableView endUpdates];
        }
        if (goToNext) {
            UIResponder *nextResponder = [self.view viewWithTag:cell.tag + 1];
            [nextResponder becomeFirstResponder];
        }
    }];
}

- (void)             tableView:(UITableView *)tableView
willDisplayConfirmPasswordCell:(LightFormCell *)cell
             forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        NSString *password = form[1][@"value"];
        BOOL updatedNeeded = input != nil || focused;
        if (input) {
            data.validations = [LightFormViewController isConfirmPasswordCompliant:input originalPassword:password] ?
                    nil : [LightFormViewController confirmPasswordCompliance:input originalPassword:password];
        } else if (focused) {
            data.validations = [LightFormViewController passwordCompliance:input];
        }
        if (returned) {
            data.value = input;
            data.validations = nil;
        }
        if (updatedNeeded) {
            cell.data = [LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]];
            [tableView beginUpdates];
            [tableView endUpdates];
        }
    }];
}


- (NSArray *)createFormData {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [mutableArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{
            @"key": @"username",
            @"placeholder": @"Username",
            @"accessoryImageUrl": @"email-icon-1.png",
            @"hasNext": @(YES)
    }]];
    [mutableArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{
            @"key": @"password",
            @"placeholder": @"Password",
            @"hasNext": @(YES),
            @"secureEntry": @(YES),
            @"accessoryImageUrl": @"email-icon-1.png"
    }]];
    [mutableArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{
            @"key": @"confirm",
            @"placeholder": @"Confirm Password",
            @"secureEntry": @(YES),
            @"accessoryImageUrl": @"email-icon-1.png",
            @"hasNext": @(NO)
    }]];
    return [NSArray arrayWithArray:mutableArray];
}

+ (NSArray *)passwordCompliance:(NSString *)password {
    NSMutableArray *compliances = [NSMutableArray new];
    NSString *symbolString = @"!@#$%^&*()-+=_";
    if (password) {
        if ([password length] < 8) {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"x at least 8 characters"
                        attributes:[self complianceFailureStringAttributes]]];
        } else {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"√ at least 8 characters"
                        attributes:[self complianceOkStringAttributes]]];
        }

        if ([password rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location == NSNotFound) {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"x choose at least one uppercase character"
                        attributes:[self complianceFailureStringAttributes]]];
        } else {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"√ choose at least one uppercase character"
                        attributes:[self complianceOkStringAttributes]]];
        }

        if ([password rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:symbolString]].location == NSNotFound) {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:[NSString stringWithFormat:@"x use a symobl(%@)", symbolString]
                        attributes:[self complianceFailureStringAttributes]]];
        } else {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:[NSString stringWithFormat:@"√ use a symobl(%@)", symbolString]
                        attributes:[self complianceOkStringAttributes]]];
        }

    } else {
        [compliances addObject:[[NSAttributedString alloc]
                initWithString:@"x at least 8 characters"
                    attributes:[self complianceInfoStringAttributes]]];
        [compliances addObject:[[NSAttributedString alloc]
                initWithString:@"x choose at least one uppercase character"
                    attributes:[self complianceInfoStringAttributes]]];
        [compliances addObject:[[NSAttributedString alloc]
                initWithString:[NSString stringWithFormat:@"x use a symobl(%@)", symbolString]
                    attributes:[self complianceInfoStringAttributes]]];
    }
    return [NSArray arrayWithArray:compliances];
}

+ (NSArray *)usernameCompliance:(NSString *)username {
    NSMutableArray *compliances = [NSMutableArray new];
    if (username) {
        if ([username length] < 8) {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"x at least 8 characters"
                        attributes:[self complianceFailureStringAttributes]]];
        } else {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"√ at least 8 characters"
                        attributes:[self complianceOkStringAttributes]]];
        }
    } else {
        [compliances addObject:[[NSAttributedString alloc]
                initWithString:@"x at least 8 characters"
                    attributes:[self complianceInfoStringAttributes]]];
    }
    return [NSArray arrayWithArray:compliances];
}


+ (NSArray *)confirmPasswordCompliance:(NSString *)confirmPassword originalPassword:(NSString *)password {
    NSMutableArray *compliances = [NSMutableArray new];
    if (confirmPassword) {
        if ([confirmPassword isEqualToString:password]) {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"√ re-enter the password"
                        attributes:[self complianceOkStringAttributes]]];
        } else {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"x re-enter the password"
                        attributes:[self complianceFailureStringAttributes]]];
        }
    } else {
        [compliances addObject:[[NSAttributedString alloc]
                initWithString:@"x re-enter the password"
                    attributes:[self complianceInfoStringAttributes]]];
    }
    return [NSArray arrayWithArray:compliances];
}

+ (BOOL)isUsernameCompliant:(NSString *)username {
    return username && [username length] > 8;
}


+ (BOOL)isConfirmPasswordCompliant:(NSString *)confirmPassword originalPassword:(NSString *)password {
    return confirmPassword && [confirmPassword isEqualToString:password];
}


/**
 * check whether password has
 *  - at least 8 characters
 *  - has at least one lower and one upper case
 *  - has at least one symbol
 * @param password
 * @return
 */
+ (BOOL)isPasswordCompliant:(NSString *)password {
    NSString *symbolString = @"!@#$%^&*()-+=_";
    return password &&
            [password length] >= 8 &&
            [password rangeOfCharacterFromSet:
                    [NSCharacterSet characterSetWithCharactersInString:symbolString]].location != NSNotFound &&
            [password rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound;
}

+ (NSDictionary *)complianceOkStringAttributes {
    return @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.25 green:0.39 blue:0.13 alpha:1.0],
            NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:13.0]};
}


+ (NSDictionary *)complianceInfoStringAttributes {
    return @{NSForegroundColorAttributeName: [UIColor grayColor],
            NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:13.0]};
}

+ (NSDictionary *)complianceFailureStringAttributes {
    return @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.94 green:0.15 blue:0.66 alpha:1.0],
            NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:13.0]};
}

@end
