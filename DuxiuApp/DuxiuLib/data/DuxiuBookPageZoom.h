//
//  DuxiuBookPageZoom.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@interface DuxiuBookPageZoom : NSObject

@property (copy) NSString *zoomName;
@property (nonatomic) int zoomEnum;

- (DuxiuBookPageZoom *)initWithZoomName:(NSString *)zoomName zoomEnum:(int)zoomEnum;

@end
