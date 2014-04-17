//
//  OperationResultViewController.h
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-10.
//
//

#import <UIKit/UIKit.h>

#import "SCSSDK.h"

@interface OperationResultViewController : UIViewController

@property (nonatomic, retain)SCSOperation *operation;
@property (nonatomic, retain)UITextView *textView;

- (id)initWithOperation:(SCSOperation *)operation;

@end
