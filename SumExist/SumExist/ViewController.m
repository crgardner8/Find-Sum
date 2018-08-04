//
//  ViewController.m
//  SumExist
//
//  Created by Clifton Gardner on 8/3/18.
//  Copyright © 2018 Clifton Gardner. All rights reserved.
//

#import "ViewController.h"

#import "ResultViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearAllButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet UITextField *targetNumberTextField;

@property (weak, nonatomic) IBOutlet UILabel *listNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *listNumberTextField;

@property(strong, nonatomic) NSNumber *target;

@property (strong, nonatomic) NSMutableArray *numberList;

@property (weak, nonatomic) IBOutlet UITableView *listNumberTableView;

@property (strong, nonatomic) NSString * resultString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.numberList = [NSMutableArray new];
    self.resultString = @"(-1,-1)";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 0){
        if (textField.text != nil && ![textField.text  isEqualToString: @""]) {
            self.doneButton.enabled = YES;
        } else {
            self.doneButton.enabled = NO;
        }
        
        self.target = @([textField.text integerValue]);
        [self.listNumberTextField becomeFirstResponder];
        return YES;
    } else if (textField.tag == 1) {
        [self.numberList addObject:@([textField.text integerValue])];
        textField.text = @"";
        [self.listNumberTableView reloadData];
    }
    
    return YES;
}

#pragma mark - Tableview Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.numberList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *listCell = [self.listNumberTableView dequeueReusableCellWithIdentifier:@"ListCellIdentifier"];
    
    if (listCell == nil) {
    
        listCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCellIdentifier"];
        
        listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    listCell.textLabel.text = [NSString stringWithFormat:@"%li", [self.numberList[indexPath.row] integerValue]];
    
    return listCell;
}

#pragma mark - Navigation Bar Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.view endEditing:YES];
    
    ResultViewController *resultVC = [segue destinationViewController];
    resultVC.success = [self hasSumInList:self.numberList ForTarget:self.target];
    resultVC.result = self.resultString;
}

- (IBAction)clearAllButtonPressed:(UIBarButtonItem *)sender {
    
    self.doneButton.enabled = NO;
    
    self.targetNumberTextField.text = @"";
    self.target = [NSNumber new];
    
    self.listNumberTextField.text = @"";
    self.numberList = [NSMutableArray new];
    [self.listNumberTableView reloadData];
    
    self.resultString = @"(-1,-1)";
}


#pragma mark - Private Method

- (BOOL)hasSumInList:(NSArray *) numberList ForTarget:(NSNumber *) target {
    
    for (NSNumber *num in numberList) {
        
        NSMutableArray *numList = [numberList mutableCopy];
        NSInteger index = [numberList indexOfObject:num];
        [numList removeObjectAtIndex:index];
        
        NSInteger difference = [target integerValue] - [num integerValue];
        
        if ([numList containsObject:@(difference)]) {
            self.resultString = [NSString stringWithFormat:@"(%li, %li)", [numberList indexOfObject:num], [numberList indexOfObject:@(difference)]];
            return YES;
        }
    }
    
    return NO;
}


@end
