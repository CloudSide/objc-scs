//
//  RootViewController.m
//  SCSDemoIOS
//
//  Created by Littlebox222 on 14-3-31.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//
#import "AppDelegate.h"
#import "RootViewController.h"
#import "OperationResultViewController.h"
#import "SCSSDK.h"

@interface RootViewController () {
    
}

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title  =@"SCSSDK Demo";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 11;
    }else {
        
        return 6;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        return 20;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"0: List buckets";
            cell.detailTextLabel.text = @"列取bukect，方法：scsListBucketOperation";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"1: Bucket addition";
            cell.detailTextLabel.text = @"创建bukect，方法：scsAddBucketOperation";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"2: Bucket deletion";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"删除bukect，方法：scsDeleteBucketOperation，若无bucket，先执行 1";
        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"3: Bucket content";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"列bucket中的object，方法：scsListObjectOperation，若无object，可先执行 4";
        }else if (indexPath.row == 4) {
            cell.textLabel.text = @"4: Object upload";
            cell.detailTextLabel.text = @"上传object，方法：scsAddObjectOperation";
        }else if (indexPath.row == 5) {
            cell.textLabel.text = @"5: Object copy";
            cell.detailTextLabel.text = @"拷贝object，方法：scsCopyObjectOperation";
        }else if (indexPath.row == 6) {
            cell.textLabel.text = @"6: Object deletion";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"删除object，方法：scsDeleteObjectOperation，若无object，先执行 4";
        }else if (indexPath.row == 7) {
            cell.textLabel.text = @"7: Object download";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"下载object，方法：scsDownloadObjectOperation，若无object，先执行 4";
        }else if (indexPath.row == 8) {
            cell.textLabel.text = @"8: Object update";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"更新object，方法：scsUpdateObjectOperation，若无object，先执行 4";
        }else if (indexPath.row == 9) {
            cell.textLabel.text = @"9: Object get info";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"获取object信息，方法：scsGetInfoObjectOperation，若无object，先执行 4";
        }else if (indexPath.row == 10) {
            cell.textLabel.text = @"10: Object upload relax";
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.text = @"秒传方式上传文件，方法：scsAddObjectRelaxOperation";
        }
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"11: Bucket get acl";
            cell.detailTextLabel.text = @"获取bukect的ACL信息，方法：scsGetACLBucketOperation";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"12: Bucket set acl";
            cell.detailTextLabel.text = @"设置bukect的ACL信息，方法：scsSetACLBucketOperation";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = @"13: Object get acl";
            cell.detailTextLabel.text = @"获取object的ACL信息，方法：scsGetACLObjectOperation";
        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"14: Object set acl";
            cell.detailTextLabel.text = @"设置object的ACL信息，方法：scsSetACLObjectOperation";
        }else if (indexPath.row == 4) {
            cell.textLabel.text = @"15: Bucket url";
            cell.detailTextLabel.text = @"通过url授权，获取bucket的url，方法：scsGetBucketURL";
        }else if (indexPath.row == 5) {
            cell.textLabel.text = @"16: Object url";
            cell.detailTextLabel.text = @"通过url授权，获取object的url，方法：scsGetObjectURL";
        }
    }
    
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        NSInteger row = indexPath.row;
        
        //List buckets
        if (row == 0) {
            [self scsListBucketOperation];
        }
        
        //Bucket addition
        if (row == 1) {
            [self scsAddBucketOperation];
        }
        
        //Bucket deletion
        if (row == 2) {
            [self scsDeleteBucketOperation];
        }
        
        //Bucket content
        if (row == 3) {
            [self scsListObjectOperation];
        }
        
        //Object upload
        if (row == 4) {
            [self scsAddObjectOperation];
        }
        
        //Object copy
        if (row == 5) {
            [self scsCopyObjectOperation];
        }
        
        //Object deletion
        if (row == 6) {
            [self scsDeleteObjectOperation];
        }
        
        //Object download
        if (row == 7) {
            [self scsDownloadObjectOperation];
        }
        
        //Object update
        if (row == 8) {
            [self scsUpdateObjectOperation];
        }
        
        //Object get info
        if (row == 9) {
            [self scsGetInfoObjectOperation];
        }
        
        //Object upload relax
        if (row == 10) {
            [self scsAddObjectRelaxOperation];
        }
        
    }else if (indexPath.section == 1) {
        
        NSInteger row = indexPath.row;
        
        //Bucket get acl
        if (row == 0) {
            
            [self scsGetACLBucketOperation];
        }
        
        //Bucket set acl
        if (row == 1) {
            [self scsSetACLBucketOperation];
        }
        
        //Object get acl
        if (row == 2) {
            [self scsGetACLObjectOperation];
        }
        
        //Object set acl
        if (row == 3) {
            [self scsSetACLObjectOperation];
        }
        
        //Bucket url
        if (row == 4) {
            [self scsGetBucketURL];
        }
        
        //Object url
        if (row == 5) {
            [self scsGetObjectURL];
        }
    }
    
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Operations

- (void)scsListBucketOperation {
    
    SCSListBucketOperation *op = [[[SCSListBucketOperation alloc] init] autorelease];
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsAddBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001" creationDate:nil consumedBytes:0 cannedAcl:SCSFastACLPublicReadWrite] autorelease];
    SCSAddBucketOperation *op = [[[SCSAddBucketOperation alloc] initWithBucket:bucket] autorelease];
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsDeleteBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSDeleteBucketOperation *op = [[[SCSDeleteBucketOperation alloc] initWithBucket:bucket] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsListObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSListObjectOperation *op = [[[SCSListObjectOperation alloc] initWithBucket:bucket] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsCopyObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *objSrc = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    SCSObject *objDest = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_prefix/demo_pic_0.png"]] autorelease];
    
    SCSCopyObjectOperation *op = [[[SCSCopyObjectOperation alloc] initWithObjectfrom:objSrc to:objDest] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsAddObjectOperation {
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *fullFilePath = [mainBundle pathForResource: @"demo_pic_0" ofType: @"png"];
    NSDictionary *fileInfo = [NSDictionary dictionaryWithObjectsAndKeys:fullFilePath,SCSObjectFilePathDataSourceKey, nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:fullFilePath error:nil];
    NSString *fileSize = nil;
    if(fileAttributes != nil) {
        fileSize = [fileAttributes objectForKey:NSFileSize];
    }
    
    NSDictionary *metadata = [NSDictionary dictionaryWithObjectsAndKeys:fileSize,@"Content-Length",[NSString stringWithFormat:@"demo_pic_0.png"], @"Name", nil];
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"] userDefinedMetadata:nil metadata:metadata dataSourceInfo:fileInfo] autorelease];
    SCSAddObjectOperation *op = [[[SCSAddObjectOperation alloc] initWithObject:object] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
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
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsDeleteObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSDeleteObjectOperation *op = [[[SCSDeleteObjectOperation alloc] initWithObject:object] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsDownloadObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *savePath = [searchPaths objectAtIndex:0];
    NSString *savedFilePath = [NSString stringWithFormat:@"%@/demo_pic_0.png", savePath];
    
    SCSDownloadObjectOperation *op = [[[SCSDownloadObjectOperation alloc] initWithObject:object saveTo:savedFilePath] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsUpdateObjectOperation {
    
    NSDictionary *udmd = [NSDictionary dictionaryWithObjectsAndKeys:@"test_meta", @"nikname", nil];
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"] userDefinedMetadata:udmd] autorelease];
    
    SCSUpdateObjectOperation *op = [[[SCSUpdateObjectOperation alloc] initWithObject:object] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsGetInfoObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSGetInfoObjectOperation *op = [[[SCSGetInfoObjectOperation alloc] initWithObject:object] autorelease];

    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsGetACLBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    SCSGetACLOperation *op = [[[SCSGetACLOperation alloc] initWithBucket:bucket object:nil] autorelease];
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsSetACLBucketOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:SCSACLCanonicalUserGroupGranteeID] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[SCSACLGrantRead, SCSACLGrantReadACP, SCSACLGrantWrite, SCSACLGrantWriteACP]] autorelease];
    SCSACL *acl = [[[SCSACL alloc] initWithGranteesAndGrants:[NSDictionary dictionaryWithObject:grant forKey:[grantee uid]]] autorelease];
    
    SCSSetACLOperation *op = [[[SCSSetACLOperation alloc] initWithBucket:bucket object:nil acl:acl] autorelease];
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsGetACLObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    SCSGetACLOperation *op = [[[SCSGetACLOperation alloc] initWithBucket:bucket object:object] autorelease];
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsSetACLObjectOperation {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:SCSACLCanonicalUserGroupGranteeID] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[SCSACLGrantRead, SCSACLGrantReadACP, SCSACLGrantWrite, SCSACLGrantWriteACP]] autorelease];
    SCSACL *acl = [[[SCSACL alloc] initWithGranteesAndGrants:[NSDictionary dictionaryWithObject:grant forKey:[grantee uid]]] autorelease];
    
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    SCSSetACLOperation *op = [[[SCSSetACLOperation alloc] initWithBucket:bucket object:object acl:acl] autorelease];
    
    OperationResultViewController *operationResultViewController = [[[OperationResultViewController alloc] initWithOperation:op] autorelease];
    [self.navigationController pushViewController:operationResultViewController animated:YES];
}

- (void)scsGetBucketURL {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    
    NSDate *expiresDate = [NSDate dateWithTimeIntervalSince1970:4133933441];
    NSString *urlString = [[bucket urlWithSign:YES expires:expiresDate ip:nil security:NO] absoluteString];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bucket URL" message:urlString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)scsGetObjectURL {
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"demo-001"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:[NSString stringWithFormat:@"demo_pic_0.png"]] autorelease];
    
    NSDate *expiresDate = [NSDate dateWithTimeIntervalSince1970:4133933441];
    NSString *urlString = [[object urlWithSign:YES expires:expiresDate ip:nil security:NO] absoluteString];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Object URL" message:urlString delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

@end
