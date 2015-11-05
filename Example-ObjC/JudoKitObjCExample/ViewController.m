//
//  ViewController.m
//  JudoKitObjCExample
//
//  Created by Hamon Riazy on 18/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

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

@property (nonatomic, strong) NSString *currentCurrency;

@property (nonatomic, strong) NSDictionary *cardDetails;

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
    self.currentCurrency = [segmentedControl titleForSegmentAtIndex:segmentedControl.selectedSegmentIndex];
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
            tvText = @"Make a payment";
            tvDetailText = @"with default settings";
            break;
        case TableViewContentPreAuth:
            tvText = @"Make a preAuth";
            tvDetailText = @"to reserve funds on a card";
            break;
        case TableViewContentCreateCardToken:
            tvText = @"Create card token";
            tvDetailText = @"to be stored for future transactions";
            break;
        case TableViewContentRepeatPayment:
            tvText = @"Make a repeat payment";
            tvDetailText = @"with a stored card token";
            break;
        case TableViewContentTokenPreAuth:
            tvText = @"Make a repeat preauth";
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
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"25.0"];
    [JudoKit payment:judoID
              amount:amount
            currency:@"GBP"
              payRef:@"payment reference"
             consRef:@"consumer reference"
            metaData:nil
          completion:^(NSArray * response, NSError * error) {
              if (error || response.count == 0) {
                  _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"there was an error performing the operation" preferredStyle:UIAlertControllerStyleAlert];
                  [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                  [self dismissViewControllerAnimated:YES completion:nil];
                  return; // BAIL
              }
              NSDictionary *JSON = response[0];
              if (JSON[@"cardDetails"]) {
                  self.cardDetails = JSON[@"cardDetails"];
              }
              DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
              viewController.infoDict = JSON;
              [self dismissViewControllerAnimated:YES completion:^{
                  [self.navigationController pushViewController:viewController animated:YES];
              }];
          } errorHandler:^(NSError * error) {
              // unfortunately due to restrictions an enum that conforms to ErrorType can not be exposed to objective C, so we have to use the int directly
              if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
              
              // handle non-fatal error
          }];
}

- (void)preAuthOperation {
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"25.0"];
    [JudoKit preAuth:judoID
              amount:amount
            currency:@"GBP"
              payRef:@"payment reference"
             consRef:@"consumer reference"
            metaData:nil
          completion:^(NSArray * response, NSError * error) {
              if (error || response.count == 0) {
                  _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"there was an error performing the operation" preferredStyle:UIAlertControllerStyleAlert];
                  [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                  [self dismissViewControllerAnimated:YES completion:nil];
                  return; // BAIL
              }
              NSDictionary *JSON = response[0];
              if (JSON[@"cardDetails"]) {
                  self.cardDetails = JSON[@"cardDetails"];
              }
              DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
              viewController.infoDict = JSON;
              [self dismissViewControllerAnimated:YES completion:^{
                  [self.navigationController pushViewController:viewController animated:YES];
              }];
          } errorHandler:^(NSError * error) {
              // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
              if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
              // handle non-fatal error
          }];
}

- (void)createCardTokenOperation {
    [JudoKit registerCard:judoID amount:[NSDecimalNumber decimalNumberWithString:@"1.01"] currency:@"GBP" payRef:@"payRef" consRef:@"consRef" metaData:nil completion:^(NSArray * response, NSError * error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        if (error && response.count == 0) {
            _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"there was an error performing the operation" preferredStyle:UIAlertControllerStyleAlert];
            [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            return; // BAIL
        }
        NSDictionary *JSON = response[0];
        if (JSON[@"cardDetails"]) {
            self.cardDetails = JSON[@"cardDetails"];
        }
    } errorHandler:^(NSError * error) {
        // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
        if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        // handle non-fatal error
    }];
}

- (void)tokenPaymentOperation {
    if (self.cardDetails) {
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"25.0"];
        [JudoKit tokenPayment:judoID
                       amount:amount
                     currency:@"GBP"
                       payRef:@"payment reference"
                      consRef:@"consumer reference"
                     metaData:nil
                  cardDetails:self.cardDetails
                consumerToken:self.cardDetails[@"consumerToken"]
                   completion:^(NSArray * response, NSError * error) {
                       if (error || response.count == 0) {
                           _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"there was an error performing the operation" preferredStyle:UIAlertControllerStyleAlert];
                           [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                           [self dismissViewControllerAnimated:YES completion:nil];
                           return; // BAIL
                       }
                       NSDictionary *JSON = response[0];
                       if (JSON[@"cardDetails"]) {
                           self.cardDetails = JSON[@"cardDetails"];
                       }
                       DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                       viewController.infoDict = JSON;
                       [self dismissViewControllerAnimated:YES completion:^{
                           [self.navigationController pushViewController:viewController animated:YES];
                       }];
                   } errorHandler:^(NSError * error) {
                       // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
                       if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                           [self dismissViewControllerAnimated:YES completion:nil];
                       }
                       // handle non-fatal error
                   }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"you need to create a card token before you can do a pre auth" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)tokenPreAuthOperation {
    if (self.cardDetails) {
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"25.0"];
        [JudoKit tokenPreAuth:judoID
                       amount:amount
                     currency:@"GBP"
                       payRef:@"payment reference"
                      consRef:@"consumer reference"
                     metaData:nil
                  cardDetails:self.cardDetails
                consumerToken:self.cardDetails[@"consumerToken"]
                   completion:^(NSArray * response, NSError * error) {
                       if (error || response.count == 0) {
                           _alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"there was an error performing the operation" preferredStyle:UIAlertControllerStyleAlert];
                           [_alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
                           [self dismissViewControllerAnimated:YES completion:nil];
                           return; // BAIL
                       }
                       NSDictionary *JSON = response[0];
                       if (JSON[@"cardDetails"]) {
                           self.cardDetails = JSON[@"cardDetails"];
                       }
                       DetailViewController *viewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
                       viewController.infoDict = JSON;
                       [self dismissViewControllerAnimated:YES completion:^{
                           [self.navigationController pushViewController:viewController animated:YES];
                       }];
                   } errorHandler:^(NSError * error) {
                       // unfortunately due to restrictions an enum that conforms to ErrorType cant also be exposed to objective C, so we have to use the int directly
                       if ([error.domain isEqualToString:@"com.judopay.error"] && error.code == -999) {
                           [self dismissViewControllerAnimated:YES completion:nil];
                       }
                       // handle non-fatal error
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
