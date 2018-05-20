//
//  DuxiuBookPageType.h
//  DuxiuApp
//
//  Created by 良胜 蔡 on 13-3-5.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

@interface DuxiuBookPageType : NSObject

@property (copy) NSString *typeName;
@property (copy) NSString *originSymbol;
@property (copy) NSString *orderSymbol;
@property (copy) NSNumber *maxNo;

- (DuxiuBookPageType *)initWithTypeName:(NSString *)typeName originSymbol:(NSString *)originSymbol orderSymbol:(NSString *)orderSymbol maxNo:(NSNumber *)maxNo;

@end
