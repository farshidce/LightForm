//
// Created by Farshid Ghods on 12/6/16.
// Copyright (c) 2016 Farshid Ghods. All rights reserved.
//#import "LightFormStyle.h"

#import "LightFormCell.h"
#import "LightFormStyle.h"
#import "LightFormCellData.h"
#import "LightFormCellData.h"


@implementation LightFormCell {
    void (^executeOnStateChange)(BOOL focused, NSString *input, BOOL error, BOOL returned);

    UITextField *_inputTextField;
    UILabel *_errorLabel;
    UIImageView *_accessoryImage;
    LightFormCellData *_data;
    BOOL isTextFieldSelected;
    BOOL errorVisible;
    BOOL placeholderVisible;

}

@synthesize data = _data;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    formStyle:(id <LightFormStyle> *)formStyle {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _inputTextField = [[UITextField alloc] init];
        _errorLabel = [[UILabel alloc] init];
        _accessoryImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_inputTextField];
        [self.contentView addSubview:_errorLabel];
        [self.contentView addSubview:_accessoryImage];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        isTextFieldSelected = NO;
        errorVisible = NO;
        placeholderVisible = YES;
        // textField constraints
        // errorLabel constraints
        [self.contentView addConstraints:[self constraintsForTextField]];
        [self.contentView addConstraints:[self constraintsForErrorLabel]];
        [self.contentView addConstraints:[self constraintsForAccessoryImage]];
    }
    // setting the constraint
    return self;
}

- (NSArray<NSLayoutConstraint *> *)constraintsForTextField {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_inputTextField
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:5.0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_inputTextField
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:5.0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                          toItem:_accessoryImage
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:5.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_errorLabel
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0
                                                                         constant:5.0];
    return @[leftConstraint, topConstraint,
            bottomConstraint, rightConstraint];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForErrorLabel {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_errorLabel
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.contentView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:5.0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_errorLabel
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:5.0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_errorLabel
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:5.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_errorLabel
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:5.0];
    return @[leftConstraint, topConstraint,
            bottomConstraint, rightConstraint];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForAccessoryImage {
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_accessoryImage
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                         toItem:_inputTextField
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.0
                                                                       constant:5.0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_accessoryImage
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.0
                                                                      constant:5.0];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_accessoryImage
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.0
                                                                        constant:5.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_accessoryImage
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:5.0];
    return @[leftConstraint, topConstraint,
            bottomConstraint, rightConstraint];
}


- (void)executeBlock:(void (^)(BOOL focused, NSString *input, BOOL error, BOOL returned))onStateChange {
    executeOnStateChange = onStateChange;
}

/**
 * sets the cell data
 * view
 * @param data
 */
- (void)setCellData:(LightFormCellData *)data {
    _data = data;
    if (_data) {
        errorVisible = _data.error && [_data.error length] > 0;
    }
    [self refreshView];
}

- (void)refreshView {
    if (self.style) {
        if (placeholderVisible) {
            if (_data && _data.placeholder) {
                if (_style) {
                    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
                    if (_style.placeholderColor) {
                        mutableDictionary[NSForegroundColorAttributeName] = _style.placeholderColor;
                    }
                    if (_style.placeholderFont) {
                        mutableDictionary[NSFontAttributeName] = _style.placeholderFont;
                    }
                    if ([mutableDictionary count] > 0) {
                        _inputTextField.placeholder = nil;
                        _inputTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                initWithString:_data.placeholder
                                    attributes:[NSDictionary dictionaryWithDictionary:mutableDictionary]];
                    }
                } else {
                    _inputTextField.attributedPlaceholder = nil;
                    _inputTextField.placeholder = _data.placeholder;
                }
            }
        } else {
            _inputTextField.placeholder = nil;
            _inputTextField.attributedPlaceholder = nil;
        }
        if (isTextFieldSelected) {
            if (_style) {
                if (_style.selectedBorderColor) {
                    self.layer.borderColor = _style.selectedBorderColor.CGColor;
                }
                if (_style.selectedBorderWidth) {
                    self.layer.borderWidth = _style.selectedBorderWidth;
                }
            }
        } else {
            if (_style) {
                if (_style.borderColor) {
                    self.layer.borderColor = _style.borderColor.CGColor;
                }
                if (_style.borderWidth) {
                    self.layer.borderWidth = _style.borderWidth;
                }
            }
        }
        if (errorVisible) {
            if (_style) {
                if (_style.errorFont) {
                    _errorLabel.font = _style.errorFont;
                }
                if (_style.errorColor) {
                    _errorLabel.textColor = _style.errorColor;
                }
                _errorLabel.textColor;
            }
            if (_data.error && [_data.error length] > 0) {
                _errorLabel.text = _data.error;
            }
        } else {
            _errorLabel.text = nil;
        }
    }
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [_inputTextField becomeFirstResponder];
    isTextFieldSelected = YES;
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, _inputTextField.text, errorVisible, YES);
    }
    [self refreshView];
    return YES;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    if ([_inputTextField isFirstResponder]) {
        [_inputTextField resignFirstResponder];
    }
    isTextFieldSelected = NO;
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, _inputTextField.text, errorVisible, YES);
    }
    [self refreshView];
    return YES;
}


// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    placeholderVisible = NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.text || [textField.text length] < 1) {
        placeholderVisible = YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    if (!textField.text || [textField.text length] < 1) {
        placeholderVisible = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (!string || [string length] < 1) {
        placeholderVisible = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    isTextFieldSelected = NO;
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, textField.text, errorVisible, YES);
    }
    return YES;
}

@end