//
//  OperationResultViewController.m
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-10.
//
//

#import "AppDelegate.h"
#import "OperationResultViewController.h"

@implementation OperationResultViewController

@synthesize operation = _operation;
@synthesize textView = _textView;

- (void)dealloc {
    
    [_operation release];
    [_textView release];
    
    [[SCSOperationQueue sharedQueue] removeQueueListener:self];
    
    [super dealloc];
}

- (id)initWithOperation:(SCSOperation *)operation
{
    self = [super init];
    if (self) {
        self.operation = operation;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title  =@"Operation Result";
    
    self.textView = [[[UITextView alloc] init] autorelease];
    _textView.frame = self.view.bounds;
    self.textView.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:_textView];
    self.textView.editable = NO;
    
    [[SCSOperationQueue sharedQueue] addQueueListener:self];
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:_operation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SCSOperationQueueNotifications

- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];
    
    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketList]) {
            
            for (SCSBucket *b in [(SCSListBucketOperation *)operation bucketList]) {
                
                _textView.text = [NSString stringWithFormat:@"%@\n%@", _textView.text, b];
            }
        }else if ([[operation kind] isEqualToString:SCSOperationKindObjectList]) {
            
            for (SCSObject *o in [(SCSListObjectOperation *)operation objects]) {
                
                _textView.text = [NSString stringWithFormat:@"%@\n%@", _textView.text, o];
            }
            
        }else if ([[operation kind] isEqualToString:SCSOperationKindObjectGetInfo]) {
            
            _textView.text = [NSString stringWithFormat:@"%@", [(SCSGetInfoObjectOperation *)operation objectInfo]];
            
        }else if ([[operation kind] isEqualToString:SCSOperationKindGetACL]) {
            
            _textView.text = [NSString stringWithFormat:@"%@", [(SCSGetACLOperation *)operation aclInfo]];
            
        }else {
            
            NSDictionary* json = nil;
            if ([operation responseData] != nil) {
                NSError *_error = nil;
                json = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:&_error];
                
                if (_error != nil) {
                    NSLog(@"Json error: %@", _error);
                }else {
                    
                }
            }
            
            _textView.text = [NSString stringWithFormat:@"%@ success\n\nRequestURL: %@\n\nRequestMethod: %@\n\nHttpResponseStatusCode: %@\n\nRequestHeader: %@\n\nResponseHeader: %@\n\nResponseData: %@", [operation kind], [operation url], [operation requestHTTPVerb], [operation responseStatusCode], [operation requestHeaders], [operation responseHeaders], json];
        }

        [[SCSOperationQueue sharedQueue] removeQueueListener:self];
        
    } else if ([operation state] == SCSOperationError) {
        
        NSString *JSONString = [[[NSString alloc] initWithBytes:[[operation requestBodyContentData] bytes] length:[[operation requestBodyContentData] length] encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"%@", JSONString);
        
        _textView.text = [NSString stringWithFormat:@"%@ error\n\nRequestURL: %@\n\nRequestMethod: %@\n\nHttpResponseStatusCode: %@\n\nRequestHeader: %@\n\nResponseHeader: %@", [operation kind], [operation url], [operation requestHTTPVerb], [operation responseStatusCode], [operation requestHeaders], [operation responseHeaders]];
        
        [[SCSOperationQueue sharedQueue] removeQueueListener:self];
    }
}

@end
