//
//  DuxiuBookPagesExporter.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPagesExporter.h"

#import "DuxiuBookPageDefine.h"

#import "SigmaFileUtil.h"

@protocol IPagesExporter <NSObject>

- (void)dispose;
- (void)beginDocument;
- (void)addPageImage:(NSData *)imageBytes;
- (NSData *)endDocument;

@end

@interface PdfExporter : NSObject <IPagesExporter>

@property (strong) NSMutableData *exportBytes;
@property (nonatomic) CGContextRef exportPDF;

@end

@implementation PdfExporter

@synthesize exportBytes = _exportBytes;
@synthesize exportPDF = _exportPDF;

- (void)dispose
{
    _exportBytes = nil;
    _exportPDF = NULL;
}

- (void)beginDocument
{
    NSMutableData *outputData = [[NSMutableData alloc] init];
    CGDataConsumerRef dataConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)outputData);
    
    CFMutableDictionaryRef attrDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(attrDictionary, kCGPDFContextTitle, @"DuxiuApp PDF File");
    CFDictionarySetValue(attrDictionary, kCGPDFContextCreator, @"蔡良胜");
    
    CGRect *pageRect = NULL;    // small page size by default
    CGContextRef pdfContext = CGPDFContextCreate(dataConsumer, pageRect, attrDictionary);
    
    CFRelease(dataConsumer);
    CFRelease(attrDictionary);
    
    _exportBytes = outputData;
    _exportPDF = pdfContext;
}

- (void)addPageImage:(NSData *)imageBytes
{
    UIImage *image = [UIImage imageWithData:imageBytes];
    CGRect pageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // init pageInfo for page size
    CFMutableDictionaryRef pageDictionary = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDataRef boxData = CFDataCreate(NULL, (const UInt8 *)&pageRect, sizeof(CGRect));
    CFDictionarySetValue(pageDictionary, kCGPDFContextMediaBox, boxData);
    
    // create page to draw image in its true size
    CGImageRef pageImage = [image CGImage];
    CGPDFContextBeginPage(_exportPDF, pageDictionary);
    CGContextDrawImage(_exportPDF, pageRect, pageImage);
    CGContextEndPage(_exportPDF);
    
    // release pageInfo
    CFRelease(pageDictionary);
    CFRelease(boxData);
}

- (NSData *)endDocument
{
    if (_exportPDF)
    {
        CGPDFContextClose(_exportPDF);
        CGContextRelease(_exportPDF);
        _exportPDF = NULL;
    }
    return _exportBytes;
}

@end

//......................................................
@interface ExportItem : NSObject

@property (copy) NSString *pageFile;
@property (copy) NSString *orderName;

@end

@implementation ExportItem

@synthesize pageFile = _pageFile;
@synthesize orderName = _orderName;

@end

//------------------------------------------------------
@interface DuxiuBookPagesExporter ()

@property (strong) NSString *homeFile;
@property (strong) NSMutableArray *exportList;

@property (copy) NSString *exportPath;
@property (strong) id<IPagesExporter> exporterImpl;
@property (strong) id timeoutId;

@end

static int EXPORT_DELAY = 1;

@implementation DuxiuBookPagesExporter

@synthesize homeFile = _homeFile;
@synthesize exportList = _exportList;

@synthesize exportPath = _exportPath;
@synthesize exporterImpl = _exporterImpl;
@synthesize timeoutId = _timeoutId;

- (id)init
{
    if (self = [super init])
    {
        _exportList = [[NSMutableArray alloc] init];
        _exportPath = nil;
        _exporterImpl = [[PdfExporter alloc] init];
        _timeoutId = nil;
    }
    return self;
}

- (BOOL)isExporting
{
    return _exportPath != nil;
}

- (BOOL)cancel
{
    if (self.isExporting)
    {
        if (_timeoutId)
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:_timeoutId];
            _timeoutId = nil;
        }
        
        [_exportList removeAllObjects];
        _exportPath = nil;
        [_exporterImpl dispose];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_EXPORT_STOP object:self];
        return true;
    }
    return false;
}

- (BOOL)exportPdfFromPagesHome:(NSString *)pagesHome toPdfPath:(NSString *)pdfPath
{
    if (!self.isExporting)
    {
        return [self initPages:pagesHome] && [self beginExportPDF:pdfPath];
    }
    return false;
}

- (BOOL)exportPdfFromPagesHome:(NSString *)pagesHome
{
    return [self exportPdfFromPagesHome:pagesHome toPdfPath:nil];
}

- (BOOL)initPages:(NSString *)pagesHome
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:pagesHome isDirectory:&isDir] && isDir)
    {
        _homeFile = nil;
        [_exportList removeAllObjects];
        
        NSArray *fileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pagesHome error:nil];
        for (NSString *fileName in fileNames) {
            NSString *filePath = [pagesHome stringByAppendingPathComponent:fileName];
            NSString *pageName = [fileName stringByDeletingPathExtension];
            DuxiuBookPageType *pageType = [DuxiuBookPageDefine getPageTypeEx:pageName];
            if (pageType)
            {
                NSString *pageTypeName = pageType.typeName;
                NSNumber *pageNo = [DuxiuBookPageDefine getPageNo:pageName];
                
                ExportItem *item = [[ExportItem alloc] init];
                item.orderName = [DuxiuBookPageDefine getPageOrderNameByType:pageTypeName pageNo:pageNo];
                item.pageFile = filePath;
                [_exportList addObject:item];
            }
        }
        
        if (_exportList.count > 0)
        {
            _homeFile = pagesHome;
            [_exportList sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                ExportItem *item1 = (ExportItem *)obj1;
                ExportItem *item2 = (ExportItem *)obj2;
                return [item1.orderName compare:item2.orderName];
            }];
            return true;
        }
    }
    return false;
}

+ (NSString *)getPdfPath:(NSString *)pagesHome
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:pagesHome isDirectory:&isDir] && isDir)
    {
        NSString *pdfPath = [pagesHome stringByAppendingPathExtension:@"pdf"];
        return pdfPath;
    }
    return nil;
}

- (BOOL)wakeUp
{
    if (self.isExporting)
    {
        [self doExportPDF:nil];
        return true;
    }
    return false;
}

- (BOOL)beginExportPDF:(NSString *)pdfPath
{
    if (_homeFile)
    {
        if (pdfPath == nil)
        {
            pdfPath = [DuxiuBookPagesExporter getPdfPath:_homeFile];
        }
        
        if ([SigmaFileUtil isOverwritable:pdfPath])
        {
            _exportPath = pdfPath;
            [_exporterImpl beginDocument];
            
            NSLog(@"Begin Exporting...");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_EXPORT_START object:self];
            
            [self doExportPDF:nil];
            return true;
        }
    }
    return false;
}

- (void)endExportPDF
{
    if (_exportPath)
    {
        NSData *pdfBytes = [_exporterImpl endDocument];
        BOOL isExported = [pdfBytes writeToFile:_exportPath atomically:YES];
        NSString *eventType = (isExported ? EVENT_EXPORT_COMPLETE : EVENT_EXPORT_FAILED);
        NSDictionary *eventData = [NSDictionary dictionaryWithObject:_exportPath forKey:@"data"];
        
        _timeoutId = nil;
        [_exportList removeAllObjects];
        _exportPath = nil;
        [_exporterImpl dispose];
        
        NSLog(@"End Exporting.");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:eventType
                                                            object:self 
                                                          userInfo:eventData];
    }
}

- (void)doExportPDF:(id)timeoutId
{
    if (_exportList.count > 0)
    {
        ExportItem *item = [_exportList objectAtIndex:0];
        [_exportList removeObjectAtIndex:0];
        NSString *pageName = [[item.pageFile lastPathComponent] stringByDeletingPathExtension];
        
        @try
        {
            NSData *bytes = [NSData dataWithContentsOfFile:item.pageFile];
            [_exporterImpl addPageImage:bytes];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_EXPORT_STEP 
                                                                object:self 
                                                              userInfo:[NSDictionary dictionaryWithObject:pageName forKey:@"data"]];
            NSLog(@"Export Step: %@", pageName);
        }
        @catch (NSException *exception)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_EXPORT_ERROR 
                                                                object:self 
                                                              userInfo:[NSDictionary dictionaryWithObject:pageName forKey:@"data"]];
            NSLog(@"Export Error: %@", pageName);
        }
        @finally
        {
            _timeoutId = [[NSObject alloc] init];
            [self performSelector:@selector(doExportPDF:) withObject:_timeoutId afterDelay:EXPORT_DELAY];
        }
    }
    else
    {
        [self endExportPDF];
    }
}

@end
