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

@property (weak, nonatomic) IBOutlet UIButton *clearListButton;

@property(strong, nonatomic) NSNumber *target;

@property (strong, nonatomic) NSMutableArray *numberList;

@property (weak, nonatomic) IBOutlet UITableView *listNumberTableView;

@property (strong, nonatomic) NSString * resultString;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.numberList = [NSMutableArray new];
    self.resultString = @"(-1,-1)";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
        self.clearListButton.enabled = YES;
        textField.text = @"";
        [self.listNumberTableView reloadData];
    }
    
    return YES;
}

#pragma mark - Keyboard Movements

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = -keyboardSize.height;
        self.view.frame = viewFrame;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame = self.view.frame;
        viewFrame.origin.y = 0.0f;
        self.view.frame = viewFrame;
    }];
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

#pragma mark - Button Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self.view endEditing:YES];
    
    ResultViewController *resultVC = [segue destinationViewController];
    resultVC.success = [self hasSumInList:self.numberList ForTarget:self.target];
    resultVC.result = self.resultString;
}

- (IBAction)clearListButtonPressed:(UIButton *)sender {
    
    self.listNumberTextField.text = @"";
    self.numberList = [NSMutableArray new];
    [self.listNumberTableView reloadData];
    
}

- (IBAction)clearAllButtonPressed:(UIBarButtonItem *)sender {
    
    self.doneButton.enabled = NO;
    
    self.targetNumberTextField.text = @"";
    self.target = [NSNumber new];
    
    self.clearListButton.enabled = NO;
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
