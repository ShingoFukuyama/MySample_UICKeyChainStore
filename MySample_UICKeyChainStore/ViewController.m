//
//  ViewController.m
//  MyKeyChain
//
//  Created by Shingo Fukuyama on 5/14/15.
//  Copyright (c) 2015 Shingo Fukuyama. All rights reserved.
//

#import "ViewController.h"
#import <UICKeyChainStore/UICKeyChainStore.h>

@interface ViewController () <UITextFieldDelegate>
// Keychain
@property (nonatomic, strong) UICKeyChainStore *keychainStore;
@property (nonatomic, strong) NSString *keyUserName;
@property (nonatomic, strong) NSString *keyUserPassword;
// View
@property (nonatomic, strong) UILabel *labelUserName;
@property (nonatomic, strong) UILabel *labelUserPassword;
@property (nonatomic, strong) UITextField *textFieldUserName;
@property (nonatomic, strong) UITextField *textFieldUserPassword;
@property (nonatomic, strong) UIButton *buttonSubmit;
@property (nonatomic, strong) UIButton *buttonKeychain;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // self.keychainStore = [UICKeyChainStore keyChainStoreWithService:@"co.fukuyama.abc1"];
    self.keychainStore = [UICKeyChainStore keyChainStore];
    self.keychainStore.synchronizable = YES; // iCloud Keychain Sync
    _keyUserName = @"MyUserName";
    _keyUserPassword = @"MyUserPassword";

    [self setupViews];
}

- (void)submit:(id)sender
{
    // Get text from the fields
    NSString *userName = _textFieldUserName.text;
    NSString *password = _textFieldUserPassword.text;
    // Trim both sides of spaces
    userName = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // Check whether empty or not
    BOOL hasUserName = userName.length > 0;
    BOOL hasPassword = password.length > 0;

    NSString *alertMessage;
    if (!hasUserName && !hasPassword) {
        alertMessage = @"Fill in the 'User Name' and 'Password' fields";
    } else if (!hasUserName) {
        alertMessage = @"Fill in the 'User Name' field";
    } else if (!hasPassword) {
        alertMessage = @"Fill in the 'Password' field";
    }

    if (alertMessage) {
        NSString *title = alertMessage;
        NSString *message = nil;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
        [self presentViewController:alertController animated:YES completion:^{}];
        return;
    } else {
        NSString *title = @"Do you want to store those text to KeyChain";
        NSString *message = nil;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.keychainStore[_keyUserName] = userName;
            self.keychainStore[_keyUserPassword] = password;
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

        }]];
        [self presentViewController:alertController animated:YES completion:^{}];
    }
}

- (void)fillInWithKeychain:(id)sender
{
    NSString *userName = self.keychainStore[_keyUserName];
    NSString *password = self.keychainStore[_keyUserPassword];
    NSLog(@"userName:%@", userName);
    NSLog(@"password:%@", password);
    BOOL hasUserName = userName.length > 0;
    BOOL hasPassword = password.length > 0;

    NSString *alertMessage;
    if (!hasUserName && !hasPassword) {
        alertMessage = @"Keychain for 'User Name' and 'Password' are not found...";
    } else if (!hasUserName) {
        alertMessage = @"Keychain for 'User Name' not found...";
    } else if (!hasPassword) {
        alertMessage = @"Keychain for 'Password' for KeyChain not found...";
    }

    if (alertMessage) {
        // Keychain values not found
        NSString *title = alertMessage;
        NSString *message = nil;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}]];
        [self presentViewController:alertController animated:YES completion:^{}];
    } else {
        // Fill in the fields
        _textFieldUserName.text = userName;
        _textFieldUserPassword.text = password;

        // Animation
        _textFieldUserName.transform = CGAffineTransformMakeScale(0.9, 0.9);
        _textFieldUserPassword.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [UIView animateWithDuration:0.1 animations:^{
            _textFieldUserName.transform = CGAffineTransformMakeScale(1.1, 1.1);
            _textFieldUserPassword.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                _textFieldUserName.transform = CGAffineTransformMakeScale(1.0, 1.0);
                _textFieldUserPassword.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {

            }];
        }];
    }
}

- (void)setupViews
{
    CGPoint center = self.view.center;

    UILabel * (^makeLabel)(NSString *) = ^(NSString *text){
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300.0, 30.0)];
        label.layer.backgroundColor = [UIColor colorWithRed:0.639 green:0.855 blue:1.000 alpha:1.000].CGColor;
        label.layer.cornerRadius = 5.0;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:18.0];
        label.text = text;
        [self.view addSubview:label];
        return label;
    };

    _labelUserName = makeLabel(@"User Name");
    _labelUserName.center = CGPointMake(center.x, 40.0);

    _labelUserPassword = makeLabel(@"Password");
    _labelUserPassword.center = CGPointMake(center.x, 130.0);

    UITextField * (^makeTextField)(void) = ^{
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300.0, 40.0)];
        textField.delegate = self;
        textField.backgroundColor = [UIColor colorWithWhite:0.991 alpha:1.000];
        textField.layer.borderColor = [UIColor colorWithWhite:0.753 alpha:1.000].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 5.0;
        textField.clearButtonMode = YES;
        [self.view addSubview:textField];
        return textField;
    };

    _textFieldUserName = makeTextField();
    _textFieldUserName.center = CGPointMake(center.x, 80.0);

    _textFieldUserPassword = makeTextField();
    _textFieldUserPassword.center = CGPointMake(center.x, 170.0);

    UIButton * (^makeButton)(NSString *) = ^(NSString *title){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160.0, 40.0)];
        button.backgroundColor = [UIColor colorWithWhite:0.824 alpha:1.000];
        button.layer.cornerRadius = 5.0;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        return button;
    };

    _buttonSubmit = makeButton(@"Save");
    [_buttonSubmit addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    _buttonSubmit.center = CGPointMake(center.x, 225.0);

    _buttonKeychain = makeButton(@"KeyChain Input");
    [_buttonKeychain addTarget:self action:@selector(fillInWithKeychain:) forControlEvents:UIControlEventTouchUpInside];
    _buttonKeychain.center = CGPointMake(center.x, 275.0);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // UITextFieldDelegate
    // RET to close the keyboard
    [textField resignFirstResponder];
    return YES;
}

@end
