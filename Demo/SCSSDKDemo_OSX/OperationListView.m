//
//  OperationListView.m
//  SCSSDKDemo
//
//  Created by Littlebox222 on 14-4-14.
//
//

#import "AppDelegate.h"
#import "OperationListView.h"
#import "CustomCellView.h"
#import "SCSSDK.h"

@implementation OperationListView {
    
    AppDelegate *_appDelegate;
}

- (void)dealloc {
    
    [[SCSOperationQueue sharedQueue] removeQueueListener:self];
    
    [super dealloc];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _tableView = [[[NSTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        
		NSTableColumn *_channTableColumn = [[[NSTableColumn alloc] initWithIdentifier:@"channels"] autorelease];
		[_tableView addTableColumn:_channTableColumn];
		_channTableColumn.width = frame.size.width;
		[_tableView setHeaderView:nil];
        
		_tableView.delegate = self;
		_tableView.dataSource = self;

        [_tableView setFocusRingType:NSFocusRingTypeNone];
        
        [self addSubview:_tableView];
        
        _appDelegate = (AppDelegate *)[[NSApplication sharedApplication]delegate];
        
        [[SCSOperationQueue sharedQueue] addQueueListener:self];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

#pragma mark - table view data source
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return 17;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	return @"1";
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
	return 29;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	
    if ([tableColumn.identifier isEqualToString:@"channels"]) {
        
		CustomCellView *cell = [[[CustomCellView alloc] initWithFrame:NSMakeRect(0, 0, 180, 30)] autorelease];
        
		if (row == 0) {
            cell.textLabel.stringValue = @"0: List buckets";
		}
        if (row == 1) {
            cell.textLabel.stringValue = @"1: Bucket addition";
        }
        if (row == 2) {
            cell.textLabel.stringValue = @"2: Bucket deletion";
        }
        if (row == 3) {
            cell.textLabel.stringValue = @"3: Bucket content";
        }
        if (row == 4) {
            cell.textLabel.stringValue = @"4: Object upload";
        }
        if (row == 5) {
            cell.textLabel.stringValue = @"5: Object copy";
        }
        if (row == 6) {
            cell.textLabel.stringValue = @"6: Object deletion";
        }
        if (row == 7) {
            cell.textLabel.stringValue = @"7: Object download";
        }
        if (row == 8) {
            cell.textLabel.stringValue = @"8: Object update";
        }
        if (row == 9) {
            cell.textLabel.stringValue = @"9: Object get info";
        }
        if (row == 10) {
            cell.textLabel.stringValue = @"10: Bucket get acl";
        }
        if (row == 11) {
            cell.textLabel.stringValue = @"11: Bucket set acl";
        }
        if (row == 12) {
            cell.textLabel.stringValue = @"12: Object get acl";
        }
        if (row == 13) {
            cell.textLabel.stringValue = @"13: Object set acl";
        }
        if (row == 14) {
            cell.textLabel.stringValue = @"14: Object upload relax";
        }
        if (row == 15) {
            cell.textLabel.stringValue = @"15: Bucket url";
        }
        if (row == 16) {
            cell.textLabel.stringValue = @"16: Object rul";
        }
        
		return cell;
	}
	return nil;
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    NSInteger row = [[notification object] selectedRow];
    
    //List buckets
    if (row == 0) {
        [self scsListBucketOperation];
        _appDelegate.detailView.string = @"\n\n列取bukect，方法：scsListBucketOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Bucket addition
    if (row == 1) {
        [self scsAddBucketOperation];
        _appDelegate.detailView.string = @"\n\n创建bukect，方法：scsAddBucketOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Bucket deletion
    if (row == 2) {
        [self scsDeleteBucketOperation];
        _appDelegate.detailView.string = @"\n\n删除bukect，方法：scsDeleteBucketOperation，若无bucket，先执行 1";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Bucket content
    if (row == 3) {
        [self scsListObjectOperation];
        _appDelegate.detailView.string = @"\n\n列bucket中的object，方法：scsListObjectOperation，若无object，可先执行 4";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object upload
    if (row == 4) {
        [self scsAddObjectOperation];
        _appDelegate.detailView.string = @"\n\n上传object，方法：scsAddObjectOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object copy
    if (row == 5) {
        [self scsCopyObjectOperation];
        _appDelegate.detailView.string = @"\n\n拷贝object，方法：scsCopyObjectOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object deletion
    if (row == 6) {
        [self scsDeleteObjectOperation];
        _appDelegate.detailView.string = @"\n\n删除object，方法：scsDeleteObjectOperation，若无object，先执行 4";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object download
    if (row == 7) {
        [self scsDownloadObjectOperation];
        _appDelegate.detailView.string = @"\n\n下载object，方法：scsDownloadObjectOperation，若无object，先执行 4";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object update
    if (row == 8) {
        [self scsUpdateObjectOperation];
        _appDelegate.detailView.string = @"\n\n更新object，方法：scsUpdateObjectOperation，若无object，先执行 4";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object get info
    if (row == 9) {
        [self scsGetInfoObjectOperation];
        _appDelegate.detailView.string = @"\n\n获取object信息，方法：scsGetInfoObjectOperation，若无object，先执行 4";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Bucket get acl
    if (row == 10) {
        
        [self scsGetACLBucketOperation];
        _appDelegate.detailView.string = @"\n\n获取bukect的ACL信息，方法：scsGetACLBucketOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Bucket set acl
    if (row == 11) {
        [self scsSetACLBucketOperation];
        _appDelegate.detailView.string = @"\n\n设置bukect的ACL信息，方法：scsSetACLBucketOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object get acl
    if (row == 12) {
        [self scsGetACLObjectOperation];
        _appDelegate.detailView.string = @"\n\n获取object的ACL信息，方法：scsGetACLObjectOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object set acl
    if (row == 13) {
        [self scsSetACLObjectOperation];
        _appDelegate.detailView.string = @"\n\n设置object的ACL信息，方法：scsSetACLObjectOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Object upload relax
    if (row == 14) {
        [self scsAddObjectRelaxOperation];
        _appDelegate.detailView.string = @"\n\n秒传方式上传文件，方法：scsAddObjectRelaxOperation";
        _appDelegate.resultView.theTextView.string = @"";
    }
    
    //Bucket url
    if (row == 15) {
        _appDelegate.detailView.string = @"\n\n通过url授权，获取bucket的url，方法：scsGetBucketURL";
        _appDelegate.resultView.theTextView.string = @"";
        [self scsGetBucketURL];
    }
    
    //Object url
    if (row == 16) {
        _appDelegate.resultView.theTextView.string = @"";
        [self scsGetObjectURL];
        _appDelegate.detailView.string = @"\n\n通过url授权，获取object的url，方法：scsGetObjectURL";
    }
}

#pragma mark - Operations

- (void)scsListBucketOperation {
    
    SCSListBucketOperation *op = [[[SCSListBucketOperation alloc] init] autorelease];
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsAddBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-002" creationDate:nil consumedBytes:0 cannedAcl:SCSFastACLPublicReadWrite] autorelease];
    SCSAddBucketOperation *op = [[[SCSAddBucketOperation alloc] initWithBucket:bucket] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsDeleteBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSDeleteBucketOperation *op = [[[SCSDeleteBucketOperation alloc] initWithBucket:bucket] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsListObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSListObjectOperation *op = [[[SCSListObjectOperation alloc] initWithBucket:bucket] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsCopyObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *objSrc = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    SCSObject *objDest = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_prefix/demo_pic_0.png"]] autorelease];
    
    SCSCopyObjectOperation *op = [[[SCSCopyObjectOperation alloc] initWithObjectfrom:objSrc to:objDest] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsAddObjectOperation {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *fullFilePath = [mainBundle pathForResource: @"demo_pic_0" ofType: @"png"];
    NSDictionary *fileInfo = [NSDictionary dictionaryWithObjectsAndKeys:fullFilePath,SCSObjectFilePathDataSourceKey, nil];
    
    /*
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:nil];
    NSString *fileSize = nil;
    if(fileAttributes != nil) {
        fileSize = [fileAttributes objectForKey:NSFileSize];
    }
    
    NSDictionary *metadata = [NSDictionary dictionaryWithObjectsAndKeys:fileSize,@"Content-Length",[NSString stringWithFormat:@"demo_pic_0.png"], @"Name", nil];
     */
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"] userDefinedMetadata:nil metadata:nil dataSourceInfo:fileInfo cannedAcl:SCSFastACLPublicReadWrite] autorelease];
    SCSAddObjectOperation *op = [[[SCSAddObjectOperation alloc] initWithObject:object] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsAddObjectRelaxOperation {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *fullFilePath = [mainBundle pathForResource: @"demo_pic_0" ofType: @"png"];
    NSDictionary *fileInfo = [NSDictionary dictionaryWithObjectsAndKeys:fullFilePath,SCSObjectFilePathDataSourceKey, nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:nil];
    NSString *fileSize = nil;
    if(fileAttributes != nil) {
        fileSize = [fileAttributes objectForKey:NSFileSize];
    }
    
    NSString *sha1 = @"cee648f4bd7a0f6de2c276f4b1d52a62d04a96d9";

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"] userDefinedMetadata:nil metadata:nil dataSourceInfo:fileInfo cannedAcl:SCSFastACLPublicReadWrite] autorelease];
    SCSAddObjectRelaxOperation *op = [[[SCSAddObjectRelaxOperation alloc] initWithObject:object fileSha1:[sha1 retain] fileSize:fileSize] autorelease];

    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsDeleteObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSDeleteObjectOperation *op = [[[SCSDeleteObjectOperation alloc] initWithObject:object] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsDownloadObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *savePath = [searchPaths objectAtIndex:0];
    NSString *savedFilePath = [NSString stringWithFormat:@"%@/demo_pic_0.png", savePath];
    
    SCSDownloadObjectOperation *op = [[[SCSDownloadObjectOperation alloc] initWithObject:object saveTo:savedFilePath] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsUpdateObjectOperation {
    
    NSDictionary *udmd = [NSDictionary dictionaryWithObjectsAndKeys:@"test_meta", @"nikname", nil];
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"] userDefinedMetadata:udmd] autorelease];
    
    SCSUpdateObjectOperation *op = [[[SCSUpdateObjectOperation alloc] initWithObject:object] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsGetInfoObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSGetInfoObjectOperation *op = [[[SCSGetInfoObjectOperation alloc] initWithObject:object] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsGetACLBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    SCSGetACLOperation *op = [[[SCSGetACLOperation alloc] initWithBucket:bucket object:nil] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsSetACLBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:SCSACLCanonicalUserGroupGranteeID] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[SCSACLGrantRead, SCSACLGrantReadACP, SCSACLGrantWrite, SCSACLGrantWriteACP]] autorelease];
    SCSACL *acl = [[[SCSACL alloc] initWithGranteesAndGrants:[NSDictionary dictionaryWithObject:grant forKey:[grantee uid]]] autorelease];
    
    SCSSetACLOperation *op = [[[SCSSetACLOperation alloc] initWithBucket:bucket object:nil acl:acl] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsGetACLObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSGetACLOperation *op = [[[SCSGetACLOperation alloc] initWithBucket:bucket object:object] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsSetACLObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:SCSACLCanonicalUserGroupGranteeID] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[SCSACLGrantRead, SCSACLGrantReadACP, SCSACLGrantWrite, SCSACLGrantWriteACP]] autorelease];
    SCSACL *acl = [[[SCSACL alloc] initWithGranteesAndGrants:[NSDictionary dictionaryWithObject:grant forKey:[grantee uid]]] autorelease];
    
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSSetACLOperation *op = [[[SCSSetACLOperation alloc] initWithBucket:bucket object:object acl:acl] autorelease];
    
    [[SCSOperationQueue sharedQueue] addToCurrentOperations:op];
}

- (void)scsGetBucketURL {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];

    NSDate *expiresDate = [NSDate dateWithTimeIntervalSince1970:4133933441];
    _appDelegate.resultView.theTextView.string = [[bucket urlWithSign:YES expires:expiresDate ip:nil security:NO] absoluteString];
}

- (void)scsGetObjectURL {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    NSDate *expiresDate = [NSDate dateWithTimeIntervalSince1970:4133933441];
    _appDelegate.resultView.theTextView.string = [[object urlWithSign:YES expires:expiresDate ip:nil security:NO] absoluteString];
}


#pragma mark - SCSOperationQueueNotifications

- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];
    
    if ([operation state] == SCSOperationDone) {
        
        if ([[operation kind] isEqualToString:SCSOperationKindBucketList]) {
            
            for (SCSBucket *b in [(SCSListBucketOperation *)operation bucketList]) {
                
                _appDelegate.resultView.theTextView.string = [NSString stringWithFormat:@"%@\n%@", _appDelegate.resultView.theTextView.string, b];
            }
        }else if ([[operation kind] isEqualToString:SCSOperationKindObjectList]) {
            
            for (SCSObject *o in [(SCSListObjectOperation *)operation objects]) {
                
                _appDelegate.resultView.theTextView.string = [NSString stringWithFormat:@"%@\n%@", _appDelegate.resultView.theTextView.string, o];
            }
            
        }else if ([[operation kind] isEqualToString:SCSOperationKindObjectGetInfo]) {
            
            _appDelegate.resultView.theTextView.string = [NSString stringWithFormat:@"%@", [(SCSGetInfoObjectOperation *)operation objectInfo]];
            
        }else if ([[operation kind] isEqualToString:SCSOperationKindGetACL]) {
            
            _appDelegate.resultView.theTextView.string = [NSString stringWithFormat:@"%@", [(SCSGetACLOperation *)operation aclInfo]];
            
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
            
            _appDelegate.resultView.theTextView.string = [NSString stringWithFormat:@"%@ success\n\nRequestURL: %@\n\nRequestMethod: %@\n\nHttpResponseStatusCode: %@\n\nRequestHeader: %@\n\nResponseHeader: %@\n\nResponseData: %@", [operation kind], [operation url], [operation requestHTTPVerb], [operation responseStatusCode], [operation requestHeaders], [operation responseHeaders], json];

        }
        
    } else if ([operation state] == SCSOperationError) {
        
        NSString *JSONString = [[[NSString alloc] initWithBytes:[[operation requestBodyContentData] bytes] length:[[operation requestBodyContentData] length] encoding:NSUTF8StringEncoding] autorelease];
        NSLog(@"%@", JSONString);
        
        _appDelegate.resultView.theTextView.string = [NSString stringWithFormat:@"%@ error\n\nRequestURL: %@\n\nRequestMethod: %@\n\nHttpResponseStatusCode: %@\n\nRequestHeader: %@\n\nResponseHeader: %@", [operation kind], [operation url], [operation requestHTTPVerb], [operation responseStatusCode], [operation requestHeaders], [operation responseHeaders]];
    }
}

@end
