//
//  ViewController.m
//  TestPaypal
//
//  Created by paulson.v on 28/05/14.
//  Copyright (c) 2014 thinkpalm. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite) IBOutlet UIView *successView;
@end

@implementation ViewController
@synthesize ProductNameText,quantityText,priceText,stockNumberText;

- (void)viewDidLoad
{
    transactionArray=[[NSMutableArray alloc]init];
    [super viewDidLoad];
    
    //add client id for sandbox===10/6/14
    [PayPalMobile initializeWithClientIdsForEnvironments:@{                                                       PayPalEnvironmentSandbox : @"Ac2QYxASDF36XQSmab8Y2YVHu6DHsGVkf3VcKgI6U8FkqMUS1TgcobpM0GQw"}];
    
    
    [PayPalMobile preconnectWithEnvironment:@"sandbox"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pay {
    // Remove our last completed payment, just for demo purposes.
    
    
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    if ([transactionArray count]==0) {
        PayPalItem *item1 = [PayPalItem itemWithName:ProductNameText.text
                                        withQuantity:[quantityText.text integerValue]
                                           withPrice:[NSDecimalNumber decimalNumberWithString:priceText.text]
                                        withCurrency:@"USD"
                                             withSku:stockNumberText.text];
        [transactionArray addObject:item1];
        
    }
  
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:transactionArray];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Hipster clothing";
    payment.items = transactionArray;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards =YES;
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
}


- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
   
    [self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
  
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}
- (void)showSuccess {
self.successView.hidden = NO;
    self.successView.alpha = 1.0f;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:2.0];
    self.successView.alpha = 0.0f;
    [UIView commitAnimations];
}
-(IBAction)addTransaction
{    PayPalItem *item1 = [PayPalItem itemWithName:ProductNameText.text
                                    withQuantity:[quantityText.text integerValue]
                                       withPrice:[NSDecimalNumber decimalNumberWithString:priceText.text]
                                    withCurrency:@"USD"
                                         withSku:stockNumberText.text];
    
    [transactionArray addObject:item1];
}
- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
    NSLog(@"PayPal Future Payment Authorization Canceled");
    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
