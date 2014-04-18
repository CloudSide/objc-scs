objc-scs
========

Objective-C SDK (iOS and OSX) for 新浪云存储 

新浪云存储Objective-C SDK为第三方应用提供了简单易用的API调用服务，使第三方客户端无需了解复杂的验证机制即可进行授权、上传、下载等文件操作。

> * 文档的详细内容请查阅：

#SDK环境要求
------
##系统版本：
> * iOS: 6.0及以上。
> * OSX: 10.8及以上。

##Frameworks：
> * iOS:Foundation.framework 
        CoreData.framework 
        AppKit.framework
> * OSX:
        Cocoa.framework
        CoreData.framework
        AppKit.framework
> * iOS Demo:
        Foundation.framework 
        CoreData.framework        
        CoreFoundation.framework
        Security.framework
        CoreGraphics.framework
        UIKit.framework
> * OSX Demo:
        Cocoa.framework
        CoreData.framework
        CoreFoundation.framework
        Security.framework
        AppKit.framework

##相关配置：
> * ARC: SDK不支持ARC模式，设置Objective-C Automatic Reference Counting 为 NO。
> * Link: 设置Other Linker Flags 为 -ObjC -all_load。
> * Demo_IOS: 在Build Phases下Link Binary Libraries中添加libSCSSDK_IOS.a。
> * Demo_OSX: 在Build Phases下Link Binary Libraries中添加libSCSSDK_OSX.a。

#快速上手
------
##设置accessKey、secretKey

```objective-c
SCSConnectionInfo *connectionInfo = [[SCSConnectionInfo alloc] initWithAccessKey:@"YOU ACCESS KEY" secretKey:@"YOU SECRET KEY" userInfo:nil secureConnection:NO];
[SCSConnectionInfo setSharedConnectionInfo:[connectionInfo autorelease]];
```

##创建操作队列

```objective-c
self.queue = [[[SCSOperationQueue alloc] initWithDelegate:self] autorelease];

//若全局只使用唯一的queue，方法如下：
//SCSOperationQueue *queue = [[SCSOperationQueue alloc] initWithDelegate:self];
//[SCSOperationQueue setSharedOperationQueue:queue];

//获取唯一的queue
//[SCSOperationQueue sharedOperationQueue];
```

##Bucket操作
###列取全部Bucket
```objective-c
- (void)scsListBucketOperation {

    SCSListBucketOperation *op = [[[SCSListBucketOperation alloc] init] autorelease];
    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketList]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketList]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###创建Bucket
```objective-c
- (void)scsAddBucketOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"要创建的Bucket名称"] autorelease];
    
    //创建时可设置bucket的acl属性
    //SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"要创建的Bucket名称" creationDate:nil consumedBytes:0 fastAcl:SCSFastACLPublicReadWrite] autorelease];

    SCSAddBucketOperation *op = [[[SCSAddBucketOperation alloc] initWithBucket:bucket] autorelease];
    
    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketAdd]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketAdd]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###删除Bucket
```objective-c
- (void)scsDeleteBucketOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"待删除的Bucket名称"] autorelease];
    SCSDeleteBucketOperation *op = [[[SCSDeleteBucketOperation alloc] initWithBucket:bucket] autorelease];
    
    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketDelete]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindBucketDelete]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

##Object操作
###列取指定Bucket下的全部Object
```objective-c
- (void)scsListObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"指定的Bucket名称"] autorelease];
    SCSListObjectOperation *op = [[[SCSListObjectOperation alloc] initWithBucket:bucket] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectList]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectList]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###上传Object
```objective-c
- (void)scsAddObjectOperation {

    NSDictionary *fileInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"要上传的文件全路径",SCSObjectFilePathDataSourceKey, nil];
    
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"目标Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）" userDefinedMetadata:nil metadata:nil dataSourceInfo:fileInfo] autorelease];

    //上传时可设置文件的acl属性
    //SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）" userDefinedMetadata:nil metadata:nil dataSourceInfo:fileInfo fastACL:SCSFastACLPublicReadWrite] autorelease];

    SCSAddObjectOperation *op = [[[SCSAddObjectOperation alloc] initWithObject:object] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectAdd]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectAdd]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###秒传Object
```objective-c
- (void)scsAddObjectRelaxOperation {

    NSString *sha1 = @"被秒传文件的sha1";
    NSDictionary *fileInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"文件全路径",SCSObjectFilePathDataSourceKey, nil];

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"指定的Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）" userDefinedMetadata:nil metadata:nil dataSourceInfo:fileInfo] autorelease];

    SCSAddObjectRelaxOperation *op = [[[SCSAddObjectRelaxOperation alloc] initWithObject:object fileSha1:[sha1 retain] fileSize:@"被秒传的文件大小"] autorelease];

    //秒传时可设置文件的acl属性，参考上传Object

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectAddRelax]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectAddRelax]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###拷贝Object
```objective-c
- (void)scsCopyObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"被拷贝Object所在的Bucke名称"] autorelease];
    SCSObject *objSrc = [[[SCSObject alloc] initWithBucket:bucket key:@"被拷贝文件的key（前缀+文件名）"] autorelease];

    SCSBucket *bucketDest = [[[SCSBucket alloc] initWithName:@"目标Object所在的Bucke名称"] autorelease];
    SCSObject *objDest = [[[SCSObject alloc] initWithBucket:bucketDest key:@"目标文件的key（前缀+文件名）"] autorelease];

    //拷贝时可设置文件的acl属性，参考上传Object

    SCSCopyObjectOperation *op = [[[SCSCopyObjectOperation alloc] initWithObjectfrom:objSrc to:objDest] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectCopy]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectCopy]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###删除Object
```objective-c
- (void)scsDeleteObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"文件所在的Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）"] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectDelete]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectDelete]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###下载Object
```objective-c
- (void)scsDownloadObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"文件所在的Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）"] autorelease]; 
    
    SCSDownloadObjectOperation *op = [[[SCSDownloadObjectOperation alloc] initWithObject:object saveTo:@"文件保存全路径"] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectDownload]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectDownload]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###更新Object
```objective-c
- (void)scsUpdateObjectOperation {

    NSDictionary *udmd = [NSDictionary dictionaryWithObjectsAndKeys:@"要修改的信息", @"要修改信息的key", nil];//可用作添加
    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"文件所在的Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）" userDefinedMetadata:udmd] autorelease];

    //更新时可设置文件的acl属性，参考上传Object    

    SCSUpdateObjectOperation *op = [[[SCSUpdateObjectOperation alloc] initWithObject:object] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectUpdate]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectUpdate]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###获取Object信息
```objective-c
- (void)scsGetInfoObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"文件所在的Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）"] autorelease];
    
    SCSGetInfoObjectOperation *op = [[[SCSGetInfoObjectOperation alloc] initWithObject:object] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectUpdate]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindObjectUpdate]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

##ACL操作
> * ACL详细内容请查阅：
###获取Bucket的ACL信息
```objective-c
- (void)scsGetACLBucketOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"目标Bucket名称"] autorelease];    
    SCSGetACLOperation *op = [[[SCSGetACLOperation alloc] initWithBucket:bucket object:nil] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindGetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindGetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###设置Bucket的ACL信息
```objective-c
- (void)scsSetACLBucketOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"目标Bucket名称"] autorelease];
    
    SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:@"被授权的Grantee ID"] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[被授权的Grant数组]] autorelease];
    SCSACL *acl = [[[SCSACL alloc] initWithGranteesAndGrants:[NSDictionary dictionaryWithObject:grant forKey:[grantee uid]]] autorelease];
    
    SCSSetACLOperation *op = [[[SCSSetACLOperation alloc] initWithBucket:bucket object:nil acl:acl] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindSetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindSetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

> * Grantee可以是一个云存储中的注册用户，用AccessKeyId标示, 例如：SINA0000001001HBK388
Grantee还可以是一个新浪云存储预定义的用户组，有如下两种：
GRPS0000000CANONICAL、GRPS000000ANONYMOUSE
> * Grant：READ、WRITE、READ_ACP、WRITE_ACP、FULL_CONTROL	
> * ACL：如
{
	'SINA0000000123456789' :  [ "read", "read_acp" , "write", "write_acp" ],
	'GRPS000000ANONYMOUSE' :  [ "read" ],
	'GRPS0000000CANONICAL' :  [ "read", "write" ]
}
> * 代码示例：
SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:SCSACLCanonicalUserGroupGranteeID] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[SCSACLGrantRead, SCSACLGrantReadACP, SCSACLGrantWrite, SCSACLGrantWriteACP]] autorelease];

###获取Object的ACL信息
```objective-c
- (void)scsGetACLObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"文件所在Bucket名称"] autorelease];
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）"] autorelease];
    SCSGetACLOperation *op = [[[SCSGetACLOperation alloc] initWithBucket:bucket object:object] autorelease];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindGetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindGetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```

###设置Object的ACL信息
```objective-c
- (void)scsSetACLObjectOperation {

    SCSBucket *bucket = [[[SCSBucket alloc] initWithName:@"文件所在Bucket名称"] autorelease];
    
    SCSGrantee *grantee = [[[SCSGrantee alloc] initWithUid:@"被授权的Grantee ID"] autorelease];
    SCSGrant *grant = [[[SCSGrant alloc] initWithGrantArray:@[被授权的Grant数组]] autorelease];
    SCSACL *acl = [[[SCSACL alloc] initWithGranteesAndGrants:[NSDictionary dictionaryWithObject:grant forKey:[grantee uid]]] autorelease];
    
    SCSObject *object = [[[SCSObject alloc] initWithBucket:bucket key:@"目标文件的key（前缀+文件名）"] autorelease];
    
    SCSSetACLOperation *op = [[[SCSSetACLOperation alloc] initWithBucket:bucket object:object acl:acl] autorelease];
    
    [[SCSOperationQueue sharedOperationQueue] addQueueListener:self];
    [[SCSOperationQueue sharedOperationQueue] addToCurrentOperations:op];

    [queue addQueueListener:self];
    [queue addToCurrentOperations:op];
}

//操作结果回调
- (void)operationQueueOperationStateDidChange:(NSNotification *)notification
{
    SCSOperation *operation = [[notification userInfo] objectForKey:SCSOperationObjectKey];

    if ([operation state] == SCSOperationDone) {

        if ([[operation kind] isEqualToString:SCSOperationKindSetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];

    }else if ([operation state] == SCSOperationError) {

        if ([[operation kind] isEqualToString:SCSOperationKindSetACL]) {
            //Your action
        }
        [queue removeQueueListener:self];
    }
}
```
> * Grantee、Grant、ACL同设置Bucket的ACL信息
