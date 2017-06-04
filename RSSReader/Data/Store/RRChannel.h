//
//  RRChannel.h
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 04.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "XMLMappedObject.h"

@interface RRChannel : NSManagedObject <XMLMappedObject>

@end

#import "RRChannel+CoreDataProperties.h"
