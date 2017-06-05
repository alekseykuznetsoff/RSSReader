//
//  RRItem.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 04.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMLMappedObject.h"

@class RRChannel;

@interface RRItem : NSManagedObject <XMLMappedObject>

@end

#import "RRItem+CoreDataProperties.h"

