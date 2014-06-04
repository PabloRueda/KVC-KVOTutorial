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
#import "Employee.h"
#import <objc/runtime.h>

@interface ViewController ()

//Imports
- (Employee*)importDataWithoutKVC:(NSDictionary*)data;
- (Employee*)importDataWithKVC:(NSDictionary*)data;

//Exports
- (NSDictionary*)exportDataWithoutKVC:(Employee*)employee;
- (NSDictionary*)exportDataWithKVC:(Employee*)employee;

//Extra methods
- (NSDictionary*)loadPList;
- (void)showData:(Employee*)employee;
- (NSArray*)propertiesForClass:(Class)clazz;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *data = [self loadPList];
    
    //Without KVC
    Employee *employee = [self importDataWithoutKVC:data];
    [self showData:employee];
    NSDictionary *exportedEmployee = [self exportDataWithoutKVC:employee];
    NSLog(@"My data exported: %@", exportedEmployee);
    
    //With KVC
    employee = [self importDataWithKVC:data];
    [self showData:employee];
    exportedEmployee = [self exportDataWithKVC:employee];
    NSLog(@"My data exported: %@", exportedEmployee);
    
    //With KVC we can use Collection Operators (avg, max, sum...):
    NSNumber *numberOfAccounts = [employee valueForKeyPath:@"accounts.@count"];
    NSLog(@"Number of accounts: %@", numberOfAccounts);
    
}

#pragma mark - NO KVC

- (Employee*)importDataWithoutKVC:(NSDictionary*)data {
    Employee *employee = [[Employee alloc] init];
    
    for (NSString *attributeName in data.allKeys) {
        if ([attributeName isEqualToString:@"name"]) {
            employee.name = [data objectForKey:attributeName];
        }else if ([attributeName isEqualToString:@"surname"]) {
            employee.surname = [data objectForKey:attributeName];
        }else if ([attributeName isEqualToString:@"accounts"]) {
            employee.accounts = [data objectForKey:attributeName];
        }
    }
    return employee;
}

- (NSDictionary*)exportDataWithoutKVC:(Employee*)employee {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    [data setObject:employee.name forKey:@"name"];
    [data setObject:employee.surname forKey:@"surname"];
    [data setObject:employee.accounts forKey:@"accounts"];
    return data;
}

#pragma mark - WITH KVC

- (Employee*)importDataWithKVC:(NSDictionary*)data {
    Employee *employee = [[Employee alloc] init];
    
    for (NSString *attributeName in data.allKeys) {
        [employee setValue:[data objectForKey:attributeName] forKey:attributeName];
    }
    return employee;
}

- (NSDictionary*)exportDataWithKVC:(Employee*)employee {
    NSArray *properties = [self propertiesForClass:[employee class]];
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    for (NSString *propertyName in properties) {
        [data setValue:[employee valueForKey:propertyName] forKey:propertyName];
    }
    return data;
}

#pragma mark - Auxiliar methods

- (NSArray*)propertiesForClass:(Class)clazz {
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(clazz , &count);
    NSMutableArray *propertiesArray = [[NSMutableArray alloc] initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [propertiesArray addObject:key];
    }
    free(properties);
    return [NSArray arrayWithArray:propertiesArray];
}

- (void)showData:(Employee*)employee {
    NSLog(@"My employee name is: %@ with surname: %@ and accounts: %@", employee.name, employee.surname, employee.accounts);
}

- (NSDictionary*)loadPList {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"attributes" ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
}

@end
