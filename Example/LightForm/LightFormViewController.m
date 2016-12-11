//
//  LightFormViewController.m
//  LightForm
//
//  Created by Farshid Ghods on 12/8/16.
//  Copyright © 2016 Farshid Ghods. All rights reserved.
//

#import "LightFormViewController.h"
#import "LightFormCell.h"
#import "LightFormCellData.h"
#import "LightFormStyle.h"
#import "macrologger.h"

@interface LightFormViewController ()

@end

@implementation LightFormViewController


NSArray *form;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LightFormCell class] forCellReuseIdentifier:@"LightFormCell"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    form = [self createFormData];


    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [form count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LightFormCell"
                                                            forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[LightFormCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"LightFormCell"];
    }
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    LightFormCell *lightFormCell = (LightFormCell *) cell;
    lightFormCell.style = [[LightFormDefaultStyle alloc] init];
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

//[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LightFormCell cellHeightForData:[LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]]
                                  withStyle:[[LightFormDefaultStyle alloc] init]];
}


- (void)      tableView:(UITableView *)tableView
willDisplayUsernameCell:(LightFormCell *)cell
      forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell executeBlock:^(BOOL focused, NSString *input, BOOL error, BOOL returned, BOOL goToNext) {
        NSLog(@"executeBlock %d %d %d for cell at row %tu", focused, error, returned, indexPath.row);
        // if user has not entered any text but is focused show the errors
        // if user has entered some text then if they are compliant then dont show any error
        // otherwise show errors
        BOOL updatedNeeded = NO;
        if (input) {
            if (![LightFormViewController isUsernameCompliant:input]) {
                form[(NSUInteger) indexPath.row][@"errors"] = [LightFormViewController usernameCompliance:input];
            } else {
                [form[(NSUInteger) indexPath.row] removeObjectForKey:@"errors"];
            }
            updatedNeeded = YES;
        } else {
            if (focused) {
                form[(NSUInteger) indexPath.row][@"errors"] = [LightFormViewController usernameCompliance:input];
                updatedNeeded = YES;
            }
        }
        if (returned) {
            form[(NSUInteger) indexPath.row][@"value"] = input;
            [form[(NSUInteger) indexPath.row] removeObjectForKey:@"errors"];
        }
        if (goToNext) {
            UIResponder *nextResponder = [self.view viewWithTag:cell.tag + 1];
            [nextResponder becomeFirstResponder];
        }
        if (updatedNeeded) {
            cell.data = [LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]];
            [tableView beginUpdates];
            [tableView endUpdates];
        }
    }];
}

- (void)      tableView:(UITableView *)tableView
willDisplayPasswordCell:(LightFormCell *)cell
      forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell executeBlock:^(BOOL focused, NSString *input, BOOL error, BOOL returned, BOOL goToNext) {
        NSLog(@"executeBlock %d %d %d for cell at row %tu", focused, error, returned, indexPath.row);
        // if user has not entered any text but is focused show the errors
        // if user has entered some text then if they are compliant then dont show any error
        // otherwise show errors
        BOOL updatedNeeded = NO;
        if (input) {
            if (![LightFormViewController isPasswordCompliant:input]) {
                form[(NSUInteger) indexPath.row][@"errors"] = [LightFormViewController passwordCompliance:input];
            } else {
                [form[(NSUInteger) indexPath.row] removeObjectForKey:@"errors"];
            }
            updatedNeeded = YES;
        } else {
            if (focused) {
                form[(NSUInteger) indexPath.row][@"errors"] = [LightFormViewController passwordCompliance:input];
                updatedNeeded = YES;
            }
        }
        if (returned) {
            form[(NSUInteger) indexPath.row][@"value"] = input;
            [form[(NSUInteger) indexPath.row] removeObjectForKey:@"errors"];
        }
        if (updatedNeeded) {
            cell.data = [LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]];
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
    [cell executeBlock:^(BOOL focused, NSString *input, BOOL error, BOOL returned, BOOL goToNext) {
        NSString *password = form[1][@"value"];
        NSLog(@"executeBlock %d %d %d for cell at row %tu", focused, error, returned, indexPath.row);
        // if user has not entered any text but is focused show the errors
        // if user has entered some text then if they are compliant then dont show any error
        // otherwise show errors
        BOOL updatedNeeded = NO;
        if (input) {
            if ([LightFormViewController isConfirmPasswordCompliant:input originalPassword:password]) {
                [form[(NSUInteger) indexPath.row] removeObjectForKey:@"errors"];
            } else {
                form[(NSUInteger) indexPath.row][@"errors"] = [LightFormViewController confirmPasswordCompliance:input originalPassword:password];
            }
            updatedNeeded = YES;
        } else {
            if (focused) {
                form[(NSUInteger) indexPath.row][@"errors"] = [LightFormViewController passwordCompliance:input];
                updatedNeeded = YES;
            }
        }
        if (returned) {
            form[(NSUInteger) indexPath.row][@"value"] = input;
            [form[(NSUInteger) indexPath.row] removeObjectForKey:@"errors"];
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
//            @"accessoryImageUrl": @"email-icon-1.png",
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
    NSCharacterSet *symbol = [NSCharacterSet characterSetWithCharactersInString:symbolString];

    NSCharacterSet *uppercases = [NSCharacterSet uppercaseLetterCharacterSet];


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

        if ([password rangeOfCharacterFromSet:uppercases].location == NSNotFound) {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"x choose at least one uppercase character"
                        attributes:[self complianceFailureStringAttributes]]];
        } else {
            [compliances addObject:[[NSAttributedString alloc]
                    initWithString:@"√ choose at least one uppercase character"
                        attributes:[self complianceOkStringAttributes]]];
        }

        if ([password rangeOfCharacterFromSet:symbol].location == NSNotFound) {
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


+ (BOOL)isPasswordCompliant:(NSString *)password {
    NSString *symbolString = @"!@#$%^&*()-+=_";
    NSCharacterSet *symbol = [NSCharacterSet characterSetWithCharactersInString:symbolString];
    NSCharacterSet *uppercases = [NSCharacterSet uppercaseLetterCharacterSet];
    return password &&
            [password length] >= 8 &&
            [password rangeOfCharacterFromSet:symbol].location != NSNotFound &&
            [password rangeOfCharacterFromSet:uppercases].location != NSNotFound;
}

+ (NSDictionary *)complianceOkStringAttributes {
    return @{NSForegroundColorAttributeName: [UIColor greenColor],
            NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:13.0]};
}


+ (NSDictionary *)complianceInfoStringAttributes {
    return @{NSForegroundColorAttributeName: [UIColor grayColor],
            NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:13.0]};
}

+ (NSDictionary *)complianceFailureStringAttributes {
    return @{NSForegroundColorAttributeName: [UIColor redColor],
            NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:13.0]};
}

@end
