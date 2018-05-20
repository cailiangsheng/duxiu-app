//
//  DuxiuTaskModel.m
//  DuxiuDown
//
//  Created by 良胜 蔡 on 12-11-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuTaskModel.h"

#import "DuxiuBookPageDefine.h"

#import "SigmaHtmlVarSearcher.h"

#import "SigmaFileUtil.h"
#import "SigmaCookieUtil.h"

@interface DuxiuTaskModel ()

@property (strong) SigmaHtmlVarSearcher *searcher;

@property (strong) DuxiuDownloadModel *downloadModel;
@property (strong) DuxiuCountModel *countModel;
@property (strong) DuxiuExportModel *exportModel;

@property (strong) NSMutableDictionary *cookie;

@end


@implementation DuxiuTaskModel

@synthesize bookTitle = _bookTitle;
@synthesize bookSSNo = _bookSSNo;
@synthesize bookSTR = _bookSTR;
@synthesize startPage = _startPage;
@synthesize endPage = _endPage;

@synthesize pageType = _pageType;
@synthesize pageZoom = _pageZoom;
@synthesize saveHome = _saveHome;

@synthesize log = _log;

@synthesize searcher = _searcher;

@synthesize downloadModel = _downloadModel;
@synthesize countModel = _countModel;
@synthesize exportModel = _exportModel;

@synthesize cookie = _cookie;

- (DuxiuDownloadModel *)downloadModel
{
    return _downloadModel;
}

- (DuxiuCountModel *)countModel
{
    return _countModel;
}

- (DuxiuExportModel *)exportModel
{
    return _exportModel;
}

+ (NSString *)defaultPath
{
    return [SigmaFileUtil documentsDirectory];
}

- (DuxiuTaskModel *)init
{
    self = [super init];
    if (self)
    {
        _cookie = [SigmaCookieUtil openCookieWithName:@"taskModel"];
        _bookTitle = [_cookie valueForKey:@"bookTitle"];
        _bookSSNo = [_cookie valueForKey:@"bookSSNo"];
        _bookSTR = [_cookie valueForKey:@"bookSTR"];
        
        NSString *cookiePageType = [_cookie valueForKey:@"pageType"];
        NSString *cookiePageZoom = [_cookie valueForKey:@"pageZoom"];
        
        _startPage = [_cookie valueForKey:@"startPage"];
        _endPage = [_cookie valueForKey:@"endPage"];
        _pageType = cookiePageType ? cookiePageType :[DuxiuBookPageDefine pageTypeAll];
        _pageZoom = cookiePageZoom ? cookiePageZoom : [DuxiuBookPageDefine pageZoomLarge];
        _saveHome = [DuxiuTaskModel defaultPath];
        _log = [_cookie valueForKey:@"log"];
        
        _searcher = [[SigmaHtmlVarSearcher alloc] init];
        
        _downloadModel = [[DuxiuDownloadModel alloc] initWithTaskModel:self];
        _countModel = [[DuxiuCountModel alloc] initWithTaskModel:self];
        _exportModel = [[DuxiuExportModel alloc] initWithTaskModel:self];
    }
    return self;
}

- (void)dealloc
{
    [self save];
}

- (void)save
{
    [_cookie setValue:_bookTitle forKey:@"bookTitle"];
    [_cookie setValue:_bookSSNo forKey:@"bookSSNo"];
    [_cookie setValue:_bookSTR forKey:@"bookSTR"];
    [_cookie setValue:_startPage forKey:@"startPage"];
    [_cookie setValue:_endPage forKey:@"endPage"];
    [_cookie setValue:_pageType forKey:@"pageType"];
    [_cookie setValue:_pageZoom forKey:@"pageZoom"];
    [_cookie setValue:_log forKey:@"log"];
    
    [SigmaCookieUtil closeCookie:_cookie];
}

- (void)setBookTitle:(NSString *)bookTitle
{
    bookTitle = [bookTitle stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    bookTitle = [bookTitle stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    bookTitle = [bookTitle stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];
    
    if (![_bookTitle isEqualToString:bookTitle])
    {
        _bookTitle = bookTitle;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKTITLE_CHANGE object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKNAME_CHANGE object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKHOME_CHANGE object:self];
    }
}

- (void)setBookSSNo:(NSString *)bookSSNo
{
    if (![_bookSSNo isEqualToString:bookSSNo])
    {
        _bookSSNo = bookSSNo;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKSSNO_CHANGE object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKNAME_CHANGE object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKHOME_CHANGE object:self];
    }
}

- (NSString *)bookName
{
    NSString *n1 = [_bookTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *n2 = [_bookSSNo stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (n1 == nil || n1.length == 0)
        return n2;
    else if (n2 == nil || n2.length == 0)
        return n1;
    else
        return [NSString stringWithFormat:@"%@_%@", n1, n2];
}

- (NSString *)bookHome
{
    NSString *bookName = self.bookName;
    return bookName == nil ? self.saveHome : [self.saveHome stringByAppendingPathComponent:bookName];
}

- (void)setBookSTR:(NSString *)bookSTR
{
    if (![_bookSTR isEqualToString:bookSTR])
    {
        _bookSTR = bookSTR;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKSTR_CHANGE object:self];
    }
}

- (void)setStartPage:(NSString *)startPage
{
    if (![_startPage isEqualToString:startPage])
    {
        NSNumber *preFromPage = self.fromPage;
        NSNumber *preToPage = self.toPage;
        
        _startPage = startPage;
        
        [self checkPageRangeChangeWithPreFromPage:preFromPage preToPage:preToPage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKSPAGE_CHANGE object:self];
    }
}

- (void)setEndPage:(NSString *)endPage
{
    if (![_endPage isEqualToString:endPage])
    {
        NSNumber *preFromPage = self.fromPage;
        NSNumber *preToPage = self.toPage;
        
        _endPage = endPage;
        
        [self checkPageRangeChangeWithPreFromPage:preFromPage preToPage:preToPage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKEPAGE_CHANGE object:self];
    }
}

- (void)setPageType:(NSString *)pageType
{
    if (![_pageType isEqualToString:pageType])
    {
        NSNumber *preFromPage = self.fromPage;
        NSNumber *preToPage = self.toPage;
        
        _pageType = pageType;
        
        [self checkPageRangeChangeWithPreFromPage:preFromPage preToPage:preToPage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_PAGETYPE_CHANGE object:self];
    }
}

- (void)setPageZoom:(NSString *)pageZoom
{
    if (![_pageZoom isEqualToString:pageZoom])
    {
        _pageZoom = pageZoom;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_PAGEZOOM_CHANGE object:self];
    }
}

- (NSNumber *)fromPage
{
    return [self getFromPage:_pageType];
}

- (NSNumber *)toPage
{
    return [self getToPage:_pageType];
}

- (NSNumber *)getFromPage:(NSString *)pageType
{
    return [DuxiuBookPageDefine isFuzzyPageType:pageType] ? nil : [self getMinPageNo:pageType];
}

- (NSNumber *)getToPage:(NSString *)pageType
{
    return [DuxiuBookPageDefine isFuzzyPageType:pageType] ? nil : [self getMaxPageNo:pageType];
}

- (NSNumber *)getMinPageNo:(NSString *)pageType
{
    int no = [DuxiuBookPageDefine isContentPageType:pageType] ? MAX(1, _startPage.intValue) : 1;
    return [NSNumber numberWithInt:no];
}

- (NSNumber *)getMaxPageNo:(NSString *)pageType
{
    int maxPageNo = [DuxiuBookPageDefine maxPageNo:pageType];
    int no = [DuxiuBookPageDefine isContentPageType:pageType] ? MIN(maxPageNo, [_endPage intValue]) : maxPageNo;
    return [NSNumber numberWithInt:no];
}

bool compareNumber(NSNumber *num1, NSNumber *num2)
{
    if (num1 && num2)
    {
        return [num1 isEqualToNumber:num2];
    }
    return false;
}

- (void)checkPageRangeChangeWithPreFromPage:(NSNumber *)preFromPage preToPage:(NSNumber *)preToPage
{
    if (!compareNumber(preFromPage, self.fromPage))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_FROMPAGE_CHANGE object:self];
    }
    
    if (!compareNumber(preToPage, self.toPage))
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_TOPAGE_CHANGE object:self];
    }
}

- (void)setSaveHome:(NSString *)saveHome
{
    if (![_saveHome isEqualToString:saveHome])
    {
        _saveHome = saveHome;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_SAVEHOME_CHANGE object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_BOOKHOME_CHANGE object:self];
    }
}

- (void)setLog:(NSString *)log
{
    if (![_log isEqualToString:log])
    {
        _log = log;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_LOG_CHANGE object:self];
    }
}

//--------------------------------------------------------------
- (BOOL)canFetchParams
{
    return !_downloadModel.isDownloading;
}

- (BOOL)canStartDownload
{
    return !_downloadModel.isDownloading && _downloadModel.isDownloadable && 
            !_exportModel.isExporting;
}

- (BOOL)canStopDownload
{
    return _downloadModel.isDownloading;
}

- (BOOL)canStartExport
{
    return !_downloadModel.isDownloading && _exportModel.isExportable && 
            !_downloadModel.isDownloading;
}

- (BOOL)canStopExport
{
    return _exportModel.isExporting;
}

- (BOOL)canOpenPDF
{
    return _exportModel.defaultPdfExist;
}

- (BOOL)canRename
{
    return _countModel.counter.numPages > 0 && _countModel.counter.numMissings == 0;
}

- (BOOL)canOriginRename
{
    return self.canRename && _countModel.counter.numOrderRenamed > 0;
}

- (BOOL)canOrderRename
{
    return self.canRename && _countModel.counter.numOriginRenamed > 0;
}

- (BOOL)startDownload
{
    return [_downloadModel execute];
}

- (BOOL)stopDownload
{
    return [_downloadModel cancel];
}

- (BOOL)startExport
{
    return [_exportModel export];
}

- (BOOL)stopExport
{
    return [_exportModel cancel];
}

//--------------------------------------------------------------
- (BOOL)fetchParams:(NSString *)url
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSearchComplete) name:EVENT_HTMLVARSEARCHER_COMPLETE object:_searcher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSearchError) name:EVENT_HTMLVARSEARCHER_ERROR object:_searcher];
    return [self.searcher searchVarWithURL:url andName:@"str"];
}

- (BOOL)isParamsValid
{
    return self.bookSTR && self.bookTitle && self.bookSSNo && self.startPage && self.endPage;
}

- (void)onSearchComplete
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_HTMLVARSEARCHER_COMPLETE object:_searcher];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_HTMLVARSEARCHER_ERROR object:_searcher];
    
    self.bookSTR = [_searcher getVarPropWithName:@"str"];
    self.startPage = [_searcher getVarPropWithName:@"spage"];
    self.endPage = [_searcher getVarPropWithName:@"epage"];
    self.bookTitle = [_searcher getVarPropWithName:@"title" isReplaceFromHome:true isDocumentProp:true];
    self.bookSSNo = [_searcher getVarPropWithName:@"ssNo"];
}

- (void)onSearchError
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_HTMLVARSEARCHER_COMPLETE object:_searcher];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_HTMLVARSEARCHER_ERROR object:_searcher];
}

//--------------------------------------------------------------

@end
