//
//  XMLMappedObject.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 04.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLMappedObject <NSObject>

- (void)mapperFoundString:(NSString *)string forElementNamed:(NSString *)elementName;

@end
