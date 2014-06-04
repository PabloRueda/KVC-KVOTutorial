//
//  ViewController.m
//  Copyright (C) 2014 Pablo Rueda
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "ViewController.h"

@interface ViewController ()
- (Employee*)createEmployee;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _employee = [self createEmployee];
    
    [_employee addObserver:self.fullnameLabel forKeyPath:@"fullname" options:0 context:nil];
    
    [_employee addObserver:self forKeyPath:@"accounts" options:NSKeyValueObservingOptionNew  context:nil];
}

- (IBAction)changeValues:(UIButton *)sender {
    
    _employee.name = [NSString stringWithFormat:@"Employee %d", arc4random() % 100];
    
    [_employee addAccount:[NSString stringWithFormat:@"Account %d", arc4random() % 100]];
}


#pragma mark - Observer methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"accounts"]) {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        self.accountsLabel.text = [NSString stringWithFormat:@"Last added value:%@", newValue];
    }
}

#pragma mark - Auxiliar methods

- (Employee*)createEmployee {
    Employee *employee = [[Employee alloc] init];
    employee.name = @"Pablo";
    employee.surname = @"Rueda";
    employee.accounts = @[@"MNS001", @"BBVA001"];
    return employee;
}

@end
