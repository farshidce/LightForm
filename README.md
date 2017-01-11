# LightForm
[![CI Status](https://travis-ci.org/farshidce/LightForm.svg?style=flat)](https://travis-ci.org/farshidce/LightForm)
[![Version](https://img.shields.io/cocoapods/v/LightForm.svg?style=flat)](http://cocoapods.org/pods/LightForm)
[![License](https://img.shields.io/cocoapods/l/LightForm.svg?style=flat)](http://cocoapods.org/pods/LightForm)
[![Platform](https://img.shields.io/cocoapods/p/LightForm.svg?style=flat)](http://cocoapods.org/pods/LightForm)

## LightForm
Simple interactive and customizable library to handle form input and validations.


![demo](https://s3.amazonaws.com/farshid.ghods.github/lightform-1.gif)

A simple library which let the user create beautiful and interactive forms for
handling user inputs and validating the data as the user inputs. The library
notifies the caller if and when the user changes the input and let the caller
decide what is validated and what validation messages needs to be displayed.

There are many Objective-C and Swift libraries that let the user create a form
that for instance can be used in the sign up or log in page. Some of the libraries that I had used
required understanding multi-layer structures which is required for customizing
the look and feel of the cell as well as input validation.


I have designed "LightForm" as a simple library which can be adopted and used without having to go through multiple layers.
Since I am a big fan of blocks I have used a simple delegate method here to notify the caller about the changes made
to the control and let the caller respond as needed.
The LightForm library allows the user to customize the cell and handle the state changes as needed as well.

In the demo the caller validates the input username and password and as the user types it can provide feedback.
Since validation label is refreshed upon each user input the user can see immediate feedback.


## Usage


pod install

```bash
    pod install
```

import the library

```objectivec
#import "LightForm.h"
```

Register LightFormCell with an identifier. You can also use "Interface Builder" if you are designing the view
 controller using the storyboards.

```objectivec
[self.tableView registerClass:[LightFormCell class] forCellReuseIdentifier:@"SignUpFormCellId"];
```

Create form data. In this example we will create 
You can create the form data using "Dictionary" or by creating an instance of LightFormCellData.

```objectivec
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    LightFormCell *lightFormCell = (LightFormCell *) cell;
    lightFormCell.data = [LightFormCellData fromDictionary:
    @{@"key": @"username",
       @"placeholder": @"Username",
       @"hasNext": @(YES)}];
}
```

In order to validate the user input as it is being typed you can handle.
 
 
 ```objectivec
[cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        BOOL updatedNeeded = NO;
        if (input) {
            if (![LightFormViewController isPasswordCompliant:input]) {
                form[(NSUInteger) indexPath.row][@"validations"] = [LightFormViewController passwordCompliance:input];
            } else {
                [form[(NSUInteger) indexPath.row] removeObjectForKey:@"validations"];
            }
            // update validation labels
            cell.data = [LightFormCellData fromDictionary:form[(NSUInteger) indexPath.row]];
            [tableView beginUpdates];
            [tableView endUpdates];
        }
}];

```

in  order to transfer the control to the next cell ( e.g when user selects next 
button the caller can decide which control should become the first responder next)

 ```objectivec
[cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        if (goToNext) {
            UIResponder *nextResponder = [self.view viewWithTag:cell.tag + 1];
            [nextResponder becomeFirstResponder];
        }
}];

```

hide the input validation if the cell is not selected anymore

```objectivec
[cell executeBlock:^(LightFormCellData *data, BOOL focused, NSString *input, BOOL returned, BOOL goToNext) {
        if (returned) {
            form[(NSUInteger) indexPath.row][@"value"] = input;
            [form[(NSUInteger) indexPath.row] removeObjectForKey:@"validations"];
        }
}];
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

LightForm is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LightForm"
```

## Author

Farshid Ghods, farshid.ghods@gmail.com

## License

LightForm is available under the MIT license. See the LICENSE file for more info.
