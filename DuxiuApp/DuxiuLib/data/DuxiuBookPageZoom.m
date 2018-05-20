//
//  DuxiuBookPageZoom.m
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "DuxiuBookPageZoom.h"

@implementation DuxiuBookPageZoom

@synthesize zoomName = _zoomName;
@synthesize zoomEnum = _zoomEnum;

- (DuxiuBookPageZoom *)initWithZoomName:(NSString *)zoomName zoomEnum:(int)zoomEnum
{
    self = [super init];
    if (self)
    {
        _zoomName = zoomName;
        _zoomEnum = zoomEnum;
    }
    return self;
}

@end
