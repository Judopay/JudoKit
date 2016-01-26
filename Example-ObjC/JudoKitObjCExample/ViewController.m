//
//  ViewController.m
//  JudoKitObjCExample
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "ViewController.h"
#import "DetailViewController.h"

@import JudoKit;
@import Judo;

typedef NS_ENUM(NSUInteger, TableViewContent) {
    TableViewContentPayment,
    TableViewContentPreAuth,
    TableViewContentCreateCardToken,
    TableViewContentRepeatPayment,
    TableViewContentTokenPreAuth
};

static NSString * const judoID              = @"<#YOUR JUDO-ID#>";
static NSString * const tokenPayReference   = @"<#YOUR REFERENCE#>";

static NSString * const kCellIdentifier     = @"com.judo.judopaysample.tableviewcellidentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate> {
    UIAlertController *_alertController;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *settingsViewBottomConstraint;

@property (nonatomic, strong) Currency *currentCurrency;

@property (nonatomic, strong) CardDetails *cardDetails;
@property (nonatomic, strong) PaymentToken *payToken;

@property (nonatomic, strong) UIView *tableFooterView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = self.tableFooterView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_alertController) {
        [self presentViewController:_alertController animated:YES completion:nil];
        _alertController = nil;
    }
}

#pragma mark - Actions

- (IBAction)settingsButtonHandler:(id)sender {
    if (self.settingsViewBottomConstraint.constant != 0) {
        [self.view layoutIfNeeded];
        self.settingsViewBottomConstraint.constant = 0.0f;
        [UIView animateWithDuration:.5f animations:^{
            self.tableView.alpha = 0.2f;
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)settingsButtonDismissHandler:(id)sender {
    if (self.settingsViewBottomConstraint.constant == 0) {
        [self.view layoutIfNeeded];
        self.settingsViewBottomConstraint.constant = -350.0f;
        [UIView animateWithDuration:.5f animations:^{
            self.tableView.alpha = 1.0f;
            [self.view layoutIfNeeded];
        }];
    }
}

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)segmentedControl {
    self.currentCurrency = [[Currency alloc] init:[segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex]];
}

- (IBAction)AVSValueChanged:(UISwitch *)theSwitch {
    JudoKit.avsEnabled = theSwitch.on;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    NSString *tvText;
    NSString *tvDetailText;
    
    switch (indexPath.row) {
        case TableViewContentPayment:
            tvText = @"Payment";
            tvDetailText = @"with default settings";
            break;
        case TableViewContentPreAuth:
            tvText = @"PreAuth";
            tvDetailText = @"to reserve funds on a card";
            break;
        case TableViewContentCreateCardToken:
            tvText = @"Add card";
            tvDetailText = @"to be stored for future transactions";
            break;
        case TableViewContentRepeatPayment:
            tvText = @"Token payment";
            tvDetailText = @"with a stored card token";
            break;
        case TableViewContentTokenPreAuth:
            tvText = @"Token preAuth";
            tvDetailText = @"with a stored card token";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = tvText;
    cell.detailTextLabel.text = tvDetailText;
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TableViewContent type = indexPath.row;
    
    switch (type) {
        case TableViewContentPayment:
            [self paymentOperation];
            break;
        case TableViewContentPreAuth:
            [self preAuthOperation];
            break;
        case TableViewContentCreateCardToken:
            [self createCardTokenOperation];
            break;
        case TableViewContentRepeatPayment:
            [self tokenPaymentOperation];
            break;
        case TableViewContentTokenPreAuth:
            [self tokenPreAuthOperation];
            break;
        default:
            break;
    }
}

#pragma mark - Operations

- (void)paymentOperation {
    Amount *amount = [[Amount alloc] initWithAmountString:@"25.0" currency:[Currency GBP]];
    
    Reference *ref = [[Reference alloc] initWithConsumerRef:@"consRef" metaData:nil];
    
    [JudoKit payment:judoID amount:amount reference:ref completion:^(Response * response, JudoError * error) {
        if (error || response.items.count == 0) {
            if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.message preferredStyle:UIAlertControllerStyleAlert];
            [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self dismissViewControllerAnimated:YES completion:nil];
            return; // BAIL
        }
        TransactionData *tData = response.items[0];
        if (tData.cardDetails) {
            self.cardDetails = tData.cardDetails;
            self.payToken = tData.paymentToken;
        }
        DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        viewController.transactionData = tData;
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }];
}

- (void)preAuthOperation {
    Amount *amount = [[Amount alloc] initWithDecimalNumber:[NSDecimalNumber decimalNumberWithString:@"25.0"] currency:[Currency GBP]];
    
    [JudoKit preAuth:judoID amount:amount reference:[[Reference alloc] initWithConsumerRef:@"consRef" metaData:nil] completion:^(Response * response, JudoError * error) {
        if (error || response.items.count == 0) {
            // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
            if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.message preferredStyle:UIAlertControllerStyleAlert];
            [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [self dismissViewControllerAnimated:YES completion:nil];
            return; // BAIL
        }
        TransactionData *tData = response.items[0];
        if (tData.cardDetails) {
            self.cardDetails = tData.cardDetails;
            self.payToken = tData.paymentToken;
        }
        DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        viewController.transactionData = tData;
        [self dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:viewController animated:YES];
        }];
    }];
}

- (void)createCardTokenOperation {
    
    [JudoKit registerCard:judoID amount:[[Amount alloc] initWithAmountString:@"1.01" currency:[Currency GBP]] reference:[[Reference alloc] initWithConsumerRef:@"consRef" metaData:nil] completion:^(Response * response, JudoError * error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (error && response.items.count == 0) {
            // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
            if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.message preferredStyle:UIAlertControllerStyleAlert];
            [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            return; // BAIL
        }
        TransactionData *tData = response.items[0];
        if (tData.cardDetails) {
            self.cardDetails = tData.cardDetails;
            self.payToken = tData.paymentToken;
        }
    }];
}

- (void)tokenPaymentOperation {
    if (self.cardDetails) {
        Amount *amount = [[Amount alloc] initWithAmountString:@"25" currency:[Currency GBP]];

        [JudoKit tokenPayment:judoID amount:amount reference:[[Reference alloc] initWithConsumerRef:@"consRef" metaData:nil] cardDetails:self.cardDetails paymentToken:self.payToken completion:^(Response * response, JudoError * error) {
            if (error || response.items.count == 0) {
                // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
                if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.message preferredStyle:UIAlertControllerStyleAlert];
                [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self dismissViewControllerAnimated:YES completion:nil];
                return; // BAIL
            }
            TransactionData *tData = response.items[0];
            if (tData.cardDetails) {
                self.cardDetails = tData.cardDetails;
                self.payToken = tData.paymentToken;
            }
            DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            viewController.transactionData = tData;
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController pushViewController:viewController animated:YES];
            }];
        }];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"you need to create a card token before you can do a pre auth" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)tokenPreAuthOperation {
    if (self.cardDetails) {
        Amount *amount = [[Amount alloc] initWithAmountString:@"25" currency:[Currency GBP]];
        
        [JudoKit tokenPreAuth:judoID amount:amount reference:[[Reference alloc] initWithConsumerRef:@"consRef" metaData:nil] cardDetails:self.cardDetails paymentToken:self.payToken completion:^(Response * response, JudoError * error) {
            if (error || response.items.count == 0) {
                // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
                if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.message preferredStyle:UIAlertControllerStyleAlert];
                [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                [self dismissViewControllerAnimated:YES completion:nil];
                return; // BAIL
            }
            TransactionData *tData = response.items[0];
            if (tData.cardDetails) {
                self.cardDetails = tData.cardDetails;
                self.payToken = tData.paymentToken;
            }
            DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            viewController.transactionData = tData;
            [self dismissViewControllerAnimated:YES completion:^{
                [self.navigationController pushViewController:viewController animated:YES];
            }];
        }];
        
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"you need to create a card token before you can do a pre auth" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - Lazy Loading

- (UIView *)tableFooterView {
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.view.bounds.size.width - 30, 50)];
        label.numberOfLines = 2;
        label.text = @"To view test card details:\nSign in to judo and go to Developer/Tools.";
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor grayColor];
        [_tableFooterView addSubview:label];
    }
    return _tableFooterView;
}


@end
