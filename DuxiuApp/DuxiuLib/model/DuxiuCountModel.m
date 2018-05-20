//
//  DuxiuCountModel.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuCountModel.h"

#import "DuxiuTaskModel.h"

@interface DuxiuCountModel ()

@property (weak) DuxiuTaskModel *taskModel;
@property (strong) DuxiuBookPageCounter *counter;

@end

@implementation DuxiuCountModel

@synthesize taskModel = _taskModel;
@synthesize counter = _counter;

- (DuxiuCountModel *)initWithTaskModel:(DuxiuTaskModel *)taskModel
{
    if (self = [super init])
    {
        _counter = [[DuxiuBookPageCounter alloc] init];
        
        _taskModel = taskModel;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookPageChange) name:EVENT_MODEL_BOOKHOME_CHANGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookPageChange) name:EVENT_MODEL_DOWNLOAD_PAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBookPageChange) name:EVENT_MODEL_DOWNLOAD_COMPLETE object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_BOOKHOME_CHANGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_DOWNLOAD_PAGE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EVENT_MODEL_DOWNLOAD_COMPLETE object:nil];
}

- (DuxiuBookPageCounter *)counter
{
    return _counter;
}

- (void)onBookPageChange
{
    [self update];
}

- (void)update
{
    int preNumPages = _counter.numPages;
    
    [_counter countAtDirPath:_taskModel.bookHome];
    if (preNumPages != _counter.numPages)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_MODEL_PAGECOUNT_CHAGNE object:self];
    }
}

@end
