#import "LightFormCell.h"
#import "LightFormStyle.h"
#import "LightFormCellData.h"


@implementation LightFormCell {
    void (^executeOnStateChange)(BOOL focused, NSString *input, BOOL error, BOOL returned, BOOL goToNext);

    UITextField *_inputTextField;
    UIView *_containerView;
    UILabel *_errorLabel;
    UIImageView *_accessoryImage;
    LightFormCellData *_data;
    BOOL isTextFieldSelected;
    BOOL errorVisible;
    BOOL placeholderVisible;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    return [self initWithStyle:style
               reuseIdentifier:reuseIdentifier
                     formStyle:[[LightFormDefaultStyle alloc] init]];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    formStyle:(id <LightFormStyle>)formStyle {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.style = formStyle;
        isTextFieldSelected = NO;
        errorVisible = NO;
        placeholderVisible = YES;
        [self initCellStyle];
        _accessoryImage = [self createAccessoryImageView];
        _errorLabel = [self createErrorLabel];
        _inputTextField = [self createInputTextField];
        _containerView = [self createContainerViewWith:_inputTextField
                                            errorLabel:_errorLabel
                                    accessoryImageView:_accessoryImage];
        [_containerView addConstraints:[self constraintsForTextField]];
        [_containerView addConstraints:[self constraintsForErrorLabel]];
        [_containerView addConstraints:[self constraintsForAccessoryImage]];

        [self.contentView addSubview:_containerView];
        [self.contentView addConstraints:[self constraintsForContainerView]];
    }
    // setting the constraint
    return self;
}


- (void)initCellStyle {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (UITextField *)createInputTextField {
    UITextField *inputTextField = [[UITextField alloc] init];
    inputTextField.userInteractionEnabled = YES;
    inputTextField.textAlignment = NSTextAlignmentLeft;
    inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [inputTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    inputTextField.delegate = self;
    return inputTextField;
}

- (UILabel *)createErrorLabel {
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.textAlignment = NSTextAlignmentLeft;
    [errorLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    errorLabel.lineBreakMode = NSLineBreakByWordWrapping;
    errorLabel.numberOfLines = 0;
    return errorLabel;
}

- (UIImageView *)createAccessoryImageView {
    UIImageView *accessoryImage = [[UIImageView alloc] init];
    [accessoryImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [accessoryImage clipsToBounds];
    accessoryImage.contentMode = UIViewContentModeCenter;
    return accessoryImage;

}


- (UIView *)createContainerViewWith:(UITextField *)inputTextField
                         errorLabel:(UILabel *)errorLabel
                 accessoryImageView:(UIImageView *)accessoryImageView {
    UIView *containerView = [[UIView alloc] init];
    [containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:inputTextField];
    [containerView addSubview:errorLabel];
    [containerView addSubview:accessoryImageView];
    return containerView;
}


- (NSArray<NSLayoutConstraint *> *)constraintsForContainerView {
    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-15-[containerView]-15-|"
                                options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil
                                  views:@{@"containerView": _containerView}];
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-7-[containerView]|" //V:|-7-[containerView]-7-|
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"containerView": _containerView}];
    return [vertical arrayByAddingObjectsFromArray:horizontal];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForTextField {
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-10-[inputTextField(25)]-5-[errorLabel(>=0)]|"
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"inputTextField": _inputTextField,
                                          @"errorLabel": _errorLabel}];
    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-15-[inputTextField]-15-[accessoryImage]-25-|"
//            constraintsWithVisualFormat:@"H:|-15-[inputTextField]-15-|"
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"inputTextField": _inputTextField,
                                          @"accessoryImage": _accessoryImage}];
    return [vertical arrayByAddingObjectsFromArray:horizontal];
}

- (NSArray<NSLayoutConstraint *> *)constraintsForErrorLabel {

    NSArray<NSLayoutConstraint *> *horizontal = [NSLayoutConstraint
            constraintsWithVisualFormat:@"H:|-15-[errorLabel]-15-[accessoryImage(20)]-|"
//            constraintsWithVisualFormat:@"H:|-15-[errorLabel]-15-|"
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"errorLabel": _errorLabel,
                                          @"accessoryImage": _accessoryImage}];
    return horizontal;

}

- (NSArray<NSLayoutConstraint *> *)constraintsForAccessoryImage {
    NSArray<NSLayoutConstraint *> *vertical = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:|-20-[accessoryImage(20)]"
                                options:NSLayoutFormatDirectionLeadingToTrailing
                                metrics:nil
                                  views:@{@"accessoryImage": _accessoryImage}];
    return vertical;
}


- (void)executeBlock:(void (^)(BOOL focused, NSString *input, BOOL error, BOOL returned, BOOL goToNext))onStateChange {
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
        errorVisible = _data.errors && [_data.errors count] > 0;
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
                    } else {
                        _inputTextField.attributedPlaceholder = nil;
                        _inputTextField.placeholder = _data.placeholder;
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

            if (_style.selectedBorderColor) {
                _containerView.layer.borderColor = _style.selectedBorderColor.CGColor;
            }
            if (_style.selectedBorderWidth) {
                _containerView.layer.borderWidth = _style.selectedBorderWidth;
            }
            _containerView.layer.cornerRadius = 5.0;

        } else {

            if (_style.borderColor) {
                _containerView.layer.borderColor = _style.borderColor.CGColor;
            }
            if (_style.borderWidth) {
                _containerView.layer.borderWidth = _style.borderWidth;
            }
            _containerView.layer.cornerRadius = 5.0;

        }
        if (errorVisible) {
            NSMutableDictionary *defaultAttributes = [NSMutableDictionary new];
            if (_style.errorFont) {
                defaultAttributes[NSFontAttributeName] = _style.errorFont;
            }
            if (_style.errorColor) {
                defaultAttributes[NSForegroundColorAttributeName] = _style.errorColor;
            }
            NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
            mutableDictionary[NSForegroundColorAttributeName] = _style.titleColor;
            __block NSUInteger numberOfLines = 0;
            mutableDictionary[NSFontAttributeName] = _style.placeholderFont;
            if (_data.errors && [_data.errors count] > 0) {
                NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
                [_data.errors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isKindOfClass:[NSString class]]) {
                        NSString *line = nil;
                        if (idx < _data.errors.count - 1) {
                            line = [NSString stringWithFormat:@"%@\n", obj];
                        } else {
                            line = [NSString stringWithFormat:@"%@", obj];
                        }
                        [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                                initWithString:line
                                    attributes:[NSDictionary dictionaryWithDictionary:defaultAttributes]]];
                    } else if ([obj isKindOfClass:[NSAttributedString class]]) {
                        [mutableAttributedString appendAttributedString:obj];
                        if (idx < _data.errors.count - 1) {
                            [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                                    initWithString:@"\n" attributes:nil]];
                        }
                    }
                    numberOfLines++;
//                    _errorLabelHeightConstraint.constant = height;
                }];
                _errorLabel.text = nil;
                _errorLabel.attributedText = mutableAttributedString;
                [_errorLabel sizeToFit];
                [_containerView sizeToFit];
//                _errorLabelHeightConstraint.constant = 10;
            }
        } else {
            _errorLabel.attributedText = nil;
            _errorLabel.text = nil;
            [_errorLabel sizeToFit];
            [_containerView sizeToFit];
        }
        if (_data.accessoryImageUrl) {
            _accessoryImage.image = [UIImage imageNamed:_data.accessoryImageUrl];
        } else {
            _accessoryImage.image = nil;
        }
    } else {
        _errorLabel.attributedText = nil;
        _errorLabel.text = nil;
        _inputTextField.text = nil;
        _inputTextField.attributedPlaceholder = nil;
        _accessoryImage.image = nil;
    }
    _inputTextField.secureTextEntry = _data && _data.secureEntry;
}



// UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_data && _data.hasNext) {
        textField.returnKeyType = UIReturnKeyNext;
    } else {
        textField.returnKeyType = UIReturnKeyGo;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    placeholderVisible = NO;
    isTextFieldSelected = YES;
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, _inputTextField.text, errorVisible, NO, NO);
    }
    [self refreshView];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!textField.attributedText.string || [textField.attributedText.string length] < 1) {
        placeholderVisible = YES;
    }
    isTextFieldSelected = NO;
    [self refreshView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) {
    if (!textField.attributedText.string || [textField.attributedText.string length] < 1) {
        placeholderVisible = YES;
    }
    isTextFieldSelected = NO;
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, textField.text, errorVisible, YES, NO);
    }
    [self refreshView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *replacementText = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];
    mutableDictionary[NSForegroundColorAttributeName] = _style.titleColor;
    mutableDictionary[NSFontAttributeName] = _style.placeholderFont;
    _inputTextField.attributedText = [[NSAttributedString alloc]
            initWithString:replacementText
                attributes:[NSDictionary dictionaryWithDictionary:mutableDictionary]];
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, replacementText, errorVisible, NO, NO);
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    isTextFieldSelected = NO;
    [self refreshView];
    if (executeOnStateChange) {
        executeOnStateChange(isTextFieldSelected, textField.text, errorVisible, NO, YES);
    }
    [textField resignFirstResponder];
    return YES;
}

/*
 * reset the errorLabel size and content
 */
- (void)prepareForReuse {
    [super prepareForReuse];
    _errorLabel.text = nil;
    _errorLabel.attributedText = nil;
    _inputTextField.text = nil;
    _inputTextField.attributedText = nil;
    _inputTextField.attributedPlaceholder = nil;
    _inputTextField.placeholder = nil;
    _accessoryImage.image = nil;

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    _errorLabel.preferredMaxLayoutWidth = _errorLabel.frame.size.width;
    [super layoutSubviews];
}


- (void)drawRect:(CGRect)rect {
    CGSize size = _errorLabel.bounds.size;
    // tell the label to size itself based on the current width
    [_errorLabel sizeToFit];
    if (!CGSizeEqualToSize(size, _errorLabel.bounds.size)) {
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
    [super drawRect:rect];
}

+ (CGFloat)cellHeightForData:(LightFormCellData *)data withStyle:(id <LightFormStyle>)style {
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize constraint = CGSizeMake([[UIScreen mainScreen] bounds].size.width, CGFLOAT_MAX);
    __block CGFloat height = 7.0f + 15.0f + 10.0f + 25.0f + 10.0f;
    NSMutableDictionary *defaultAttributes = [NSMutableDictionary new];
    if (style.errorFont) {
        defaultAttributes[NSFontAttributeName] = style.errorFont;
    }
    if (style.errorColor) {
        defaultAttributes[NSForegroundColorAttributeName] = style.errorColor;
    }

    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] init];
    if (data && data.errors) {
        [data.errors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[NSString class]]) {
                [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                        initWithString:obj
                            attributes:[NSDictionary dictionaryWithDictionary:defaultAttributes]]];
                CGSize boundingBox = [obj
                        boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:[NSDictionary dictionaryWithDictionary:defaultAttributes]
                                     context:context].size;
                height += boundingBox.height;
            } else if ([obj isKindOfClass:[NSAttributedString class]]) {
                NSString *text = ((NSAttributedString *) obj).string;
                NSDictionary *attributes = [((NSAttributedString *) obj) attributesAtIndex:0
                                                                     longestEffectiveRange:nil
                                                                                   inRange:NSMakeRange(0, text.length)];
                [mutableAttributedString appendAttributedString:obj];
                if (idx < data.errors.count - 1) {
                    [mutableAttributedString appendAttributedString:[[NSAttributedString alloc]
                            initWithString:@"\n" attributes:nil]];
                }
                CGSize boundingBox = [text
                        boundingRectWithSize:constraint
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:context].size;
                height += boundingBox.height;
            }
        }];
    }
    return height;
}

- (BOOL)becomeFirstResponder {
    [super becomeFirstResponder];
    [_inputTextField becomeFirstResponder];
    return YES;
}

@end
