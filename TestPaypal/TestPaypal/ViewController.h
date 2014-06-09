//
//  ViewController.h
//  TestPaypal
//
//  Created by paulson.v on 28/05/14.
//  Copyright (c) 2014 thinkpalm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface ViewController : UIViewController<PayPalFuturePaymentDelegate,PayPalPaymentDelegate>{
    
    
    
    
    NSMutableArray *transactionArray;
}

@property (weak, nonatomic) IBOutlet UITextField *ProductNameText;
@property (weak, nonatomic) IBOutlet UITextField *quantityText;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *stockNumberText;
-(IBAction)addTransaction;
@end
