//
//  DuxiuBookPageDownloader.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-6.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageDownloader.h"

#import "DuxiuBookPageData.h"
#import "DuxiuBookPageDefine.h"

#import "SigmaURLLoader.h"

//.......................................................
@interface DownloadParams : NSObject

@property (copy) NSString *pageName;
@property (nonatomic) int zoomEnum;
@property (nonatomic) int retryCount;

- (DownloadParams *)initWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum retryCount:(int)retryCount;

@end

@implementation DownloadParams

@synthesize pageName = _pageName;
@synthesize zoomEnum = _zoomEnum;
@synthesize retryCount = _retryCount;

- (DownloadParams *)initWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum retryCount:(int)retryCount
{
    if (self = [super init])
    {
        _pageName = pageName;
        _zoomEnum = zoomEnum;
        _retryCount = retryCount;
    }
    return self;
}

@end

@interface DownloadItem : DownloadParams

@property (strong) SigmaURLLoader *loader;

@end

@implementation DownloadItem

@synthesize loader;

@end

//.......................................................
@protocol IDownUrl <NSObject>

- (id<IDownUrl>)initWithSTR:(NSString *)str;
- (NSString *)getPageUrlWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum;

@end

@interface BaseUrl :NSObject <IDownUrl>

@property (copy) NSString *baseURL;

@end

@implementation BaseUrl

@synthesize baseURL;

- (NSString *)getPageUrlWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum
{
    return [NSString stringWithFormat:@"%@%@?.&uf=ssr&zoom=%d", self.baseURL, pageName, zoomEnum];
}

- (id<IDownUrl>)initWithSTR:(NSString *)str
{
    return [super init];
}

@end

//.......................................................
@interface RealUrl : BaseUrl

@end

@implementation RealUrl

static NSString *HOST1 = @"http://readsvr.zhizhen.com";

- (id<IDownUrl>)initWithSTR:(NSString *)str
{
    if (self = [super init])
    {
        NSString *suffix = [str substringFromIndex:[str rangeOfString:@"/img"].location];
        self.baseURL = [NSString stringWithFormat:@"%@%@", HOST1, suffix];
    }
    return self;
}

@end

//.......................................................
@interface SaveUrl : BaseUrl

@end

@implementation SaveUrl

static NSString *HOST2 = @"http://www.junshilei.cn";

- (id<IDownUrl>)initWithSTR:(NSString *)str
{
    if (self = [super init])
    {
        self.baseURL = [NSString stringWithFormat:@"%@/SaveAs?Url=http://img.duxiu.com/n/%@", HOST2, str];
    }
    return self;
}

@end

//.......................................................
@interface DownUrl : NSObject <IDownUrl>

@property (strong) RealUrl *realUrl;
@property (strong) SaveUrl *saveUrl;

@end

@implementation DownUrl

@synthesize realUrl =  _realUrl;
@synthesize saveUrl = _saveUrl;

- (id<IDownUrl>)initWithSTR:(NSString *)str
{
    if (self = [super init])
    {
        _realUrl = [[RealUrl alloc] initWithSTR:str];
        _saveUrl = [[SaveUrl alloc] initWithSTR:str];
    }
    return self;
}

- (NSString *)getPageUrlWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum
{
    if ([DuxiuBookPageDefine isOriginPageZoom:zoomEnum])
        return [_saveUrl getPageUrlWithPageName:pageName zoomEnum:zoomEnum];
    else
        return [_realUrl getPageUrlWithPageName:pageName zoomEnum:zoomEnum];
}

@end

//-------------------------------------------------------
@interface DuxiuBookPageDownloader ()

@property (strong) NSMutableArray *downloads;
@property (strong) id<IDownUrl> downUrl;

@end

@implementation DuxiuBookPageDownloader

@synthesize downloads = _downloads;
@synthesize downUrl = _downUrl;

static int DOWNLOAD_DELAY = 1;
static int DOWNLOAD_TIMEOUT = 5000;
static int DOWNLOAD_RETRY = 3;

- (DuxiuBookPageDownloader *)init
{
    if (self = [super init])
    {
        _downloads = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)setSTR:(NSString *)str
{
    if (str)
    {
        [self cancel];
        
        _downUrl = [[DownUrl alloc] initWithSTR:str];
        return true;
    }
    return false;
}

- (BOOL)downloadWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum
{
    return [self downloadWithPageName:pageName zoomEnum:zoomEnum retryCount:0];
}

- (BOOL)downloadWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum retryCount:(int)retryCount
{
    if (pageName && _downUrl)
    {
        [self performSelector:@selector(doDownload:) 
                   withObject:[[DownloadParams alloc] initWithPageName:pageName zoomEnum:zoomEnum retryCount:retryCount] 
                   afterDelay:DOWNLOAD_DELAY];
        return true;
    }
    return false;
}

- (void)doDownload:(DownloadParams *)params
{
    [self doDownloadWithPageName:params.pageName zoomEnum:params.zoomEnum retryCount:params.retryCount];
}

- (void)doDownloadWithPageName:(NSString *)pageName zoomEnum:(int)zoomEnum retryCount:(int)retryCount
{
    NSString *url = [_downUrl getPageUrlWithPageName:pageName zoomEnum:zoomEnum];
    SigmaURLLoader *loader = [[SigmaURLLoader alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoaded:) name:EVENT_URLLOADER_COMPLETE object:loader];
    [loader load:url];
    
    DownloadItem *item = [[DownloadItem alloc] initWithPageName:pageName zoomEnum:zoomEnum retryCount:retryCount];
    item.loader = loader;
    
    [self performSelector:@selector(checkTimeout:) withObject:item afterDelay:DOWNLOAD_TIMEOUT];
    [_downloads addObject:item];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DOWNLOADER_START 
                                                        object:self 
                                                      userInfo:[NSDictionary dictionaryWithObject:pageName forKey:@"data"]];
    NSLog(@"Downloading: %@", pageName);
}

- (void)checkTimeout:(DownloadItem *)item
{
    SigmaURLLoader *loader = item.loader;
    if (loader.data.length == 0)
    {
        [self retryDownload:item];
        
        [loader close];
        [self disposeLoader:loader];
    }
}

- (BOOL)wakeUp
{
    if (_downloads.count > 0)
    {
        for (DownloadItem *item in _downloads)
        {
            item.retryCount--;
            [item.loader.data setLength:0];
            [self checkTimeout:item];
        }
        return true;
    }
    return false;
}

- (void)retryDownload:(DownloadItem *)item
{
    if (item)
    {
        if (item.retryCount < DOWNLOAD_RETRY)
        {
            [self downloadWithPageName:item.pageName zoomEnum:item.zoomEnum retryCount:item.retryCount + 1];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DOWNLOADER_ERROR 
                                                                object:self 
                                                              userInfo:[NSDictionary dictionaryWithObject:item.pageName forKey:@"data"]];
            NSLog(@"Retry failed: %@", item.pageName);
        }
    }
}

- (void)cancel
{
    NSArray *downloads = [_downloads copy];
    for (DownloadItem *item in downloads) {
        [item.loader close];
        [self disposeLoader:item.loader];
    }
    [_downloads removeAllObjects];
}

- (DownloadItem *)getDownloadItem:(SigmaURLLoader *)loader
{
    for (DownloadItem *item in _downloads) {
        if (item.loader == loader)
            return item;
    }
    return nil;
}

- (void)disposeLoader:(SigmaURLLoader *)loader
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_URLLOADER_COMPLETE object:loader];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_URLLOADER_ERROR object:loader];
    
    DownloadItem *item = [self getDownloadItem:loader];
    if (item)
    {
        [_downloads removeObject:item];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(checkTimeout:) object:item];
    }
}

- (void)onLoaded:(NSNotification *)notification
{
    SigmaURLLoader *loader = notification.object;
    DownloadItem *item = [self getDownloadItem:loader];
    if (item)
    {
        NSString *pageName = item.pageName;
        NSMutableData *pageBytes = loader.data;
        if (pageBytes.length > 142)
        {
            DuxiuBookPageData *data = [[DuxiuBookPageData alloc] initWithPageName:pageName pageByte:pageBytes];
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DOWNLOADER_COMPLETE 
                                                                object:self 
                                                              userInfo:[NSDictionary dictionaryWithObject:data forKey:@"data"]];
            NSLog(@"Download: %@", pageName);
        }
        else
        {
            [self retryDownload:item];
        }
    }
    [self disposeLoader:loader];
}

- (void)onError:(NSNotification *)notification
{
    SigmaURLLoader *loader = notification.object;
    DownloadItem *item = [self getDownloadItem:loader];
    if (item)
    {
        [self retryDownload:item];
    }
    [self disposeLoader:loader];
}

@end
