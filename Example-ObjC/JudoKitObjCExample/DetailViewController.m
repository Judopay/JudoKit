//
//  DetailViewController.m
//  JudoPayDemoObjC
//
//  Created by Hamon Riazy on 14/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

#import "DetailViewController.h"

@import Judo;

@interface DetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *dateStampLabel;
@property (nonatomic, strong) IBOutlet UILabel *amountLabel;

@property (nonatomic, strong) NSDateFormatter *inputDateFormatter;
@property (nonatomic, strong) NSDateFormatter *outputDateFormatter;

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Payment receipt";
    self.navigationItem.hidesBackButton = YES;
    
    if (self.transactionData) {
        NSDate *createdAtDate = self.transactionData.createdAt;
        self.dateStampLabel.text = [self.outputDateFormatter stringFromDate:createdAtDate];
        
        self.numberFormatter.currencyCode = self.transactionData.amount.currency;
        self.amountLabel.text = [self.numberFormatter stringFromNumber:self.transactionData.amount.amount];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.transactionData) {
        self.numberFormatter.currencyCode = self.transactionData.amount.currency;
        self.amountLabel.text = [self.numberFormatter stringFromNumber:self.transactionData.amount.amount];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeButtonHandler:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy Loading

- (NSDateFormatter *)inputDateFormatter {
    if (_inputDateFormatter == nil) {
        _inputDateFormatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
        [_inputDateFormatter setLocale:enUSPOSIXLocale];
        [_inputDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"];
    }
    return _inputDateFormatter;
}

- (NSDateFormatter *)outputDateFormatter {
    if (_outputDateFormatter == nil) {
        _outputDateFormatter = [[NSDateFormatter alloc] init];
        [_outputDateFormatter setDateFormat:@"yyyy-MM-dd, HH:mm"];
    }
    return _outputDateFormatter;
}

- (NSNumberFormatter *)numberFormatter {
    if (_numberFormatter == nil) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return _numberFormatter;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
