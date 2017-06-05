//
//  RRXMLParser.m
//  RSSReader
//
//  Created by Kuznetsov Aleksey on 03.06.17.
//  Copyright © 2017 Kuznetsov Aleksey. All rights reserved.
//

#import "RRXMLParser.h"
#import "RRChannel.h"
#import "XMLMappedObject.h"
#import "RRItem.h"
#import <MagicalRecord/MagicalRecord.h>

@interface RRXMLParser () <NSXMLParserDelegate>

@property (nonatomic) NSManagedObjectContext *moc;
@property (nonatomic) NSXMLParser *parser;
@property (nonatomic) RRChannel *channel;
@property (atomic, copy) void (^callbackBlock)(NSError *error);

@property (nonatomic) NSMutableArray *elements;
@property (nonatomic) NSMutableArray *objects;
@property (nonatomic) NSMutableString *characters;
@property (nonatomic) NSError *error;

@property (nonatomic) NSSet *oldItems;
@property (nonatomic) NSMutableSet *parsedItems;

- (id <XMLMappedObject>)objectForElementNamed:(NSString *)elementName
                               withAttributes:(NSDictionary *)attributes
                                currentObject:(id <XMLMappedObject>)current;
- (void)asyncParse;
- (void)parserDidEndSuccess:(BOOL)success;
- (void)cleanAll;

@end

@implementation RRXMLParser

- (void)parseData:(NSData *)data
      channelLink:(NSString *)link
            block:(void (^)(NSError *error))block
{
    self.moc = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    self.channel = [RRChannel MR_findFirstByAttribute:@"link" withValue:link inContext:self.moc];
    self.callbackBlock = block;
    self.parser = [[NSXMLParser alloc] initWithData:data];
    self.parser.delegate = self;
    [self asyncParse];
}

- (void)asyncParse
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self parse];
    });
}

- (void)parse
{
    self.elements = [NSMutableArray new];
    self.objects = [NSMutableArray new];
    self.oldItems = [self.channel.items copy];
    self.parsedItems = [NSMutableSet new];
    
    if (self.callbackBlock && ![self.parser parse]) {
        [self parserDidEndSuccess:NO];
    }
}

- (void)abortParsing
{
    [self.parser abortParsing];
    [self cleanAll];
}

- (void)cleanAll
{
    self.callbackBlock = nil;
    self.parser.delegate = nil;
    self.parser = nil;
    self.moc = nil;
    self.channel = nil;
    self.elements = nil;
    self.objects = nil;
    self.oldItems = nil;
    self.parsedItems = nil;
    self.error = nil;
}

- (void)parserDidEndSuccess:(BOOL)success
{
    if (self.callbackBlock) {
        if (success) {
            if (self.parsedItems.count) {
                for (RRItem *item in self.oldItems) {
                    [item MR_deleteEntityInContext:self.moc];
                }
            }
            [self.moc MR_saveOnlySelfAndWait];
            [self.moc.parentContext MR_saveToPersistentStoreWithCompletion:nil];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.callbackBlock == nil ?: self.callbackBlock(self.error);
        });
        [self cleanAll];
    }
}

- (id <XMLMappedObject>)objectForElementNamed:(NSString *)elementName withAttributes:(NSDictionary *)attributes currentObject:(id<XMLMappedObject>)current
{
    if ([elementName isEqualToString:@"channel"]) {
        return self.channel;
    }
    if ([elementName isEqualToString:@"item"]) {
        RRItem *item = [RRItem MR_createEntityInContext:self.moc];
        item.channel = self.channel;
        [self.parsedItems addObject:item];
        return item;
    }
    
    return current;
}

#pragma mark NSXMLParser Delegate Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    [self.elements addObject:elementName];
    
    id <XMLMappedObject> object = [self objectForElementNamed:elementName withAttributes:attributeDict currentObject:[self.objects lastObject]];
    
    if (object) {
        [self.objects addObject:object];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.characters) {
        self.characters = [NSMutableString new];
    }
    [self.characters appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSAssert([[self.elements lastObject] isEqualToString:elementName], @"Attempt to end tag other than the current head.");
    
    [self.elements removeLastObject];
    
    id <XMLMappedObject> currentObject = [self.objects lastObject];
    
    NSString *string = [self.characters stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (string.length) {
        [currentObject mapperFoundString:string forElementNamed:elementName];
    }
    
    self.characters = nil;
    [self.objects removeLastObject];
    
//    [self.delegate mapper:self endElementNamed:elementName currentObject:currentObject];
    
}

-(void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"parseError: %@", parseError);
    self.error = parseError;
    [self parserDidEndSuccess:NO];
}

-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"validationError: %@", validationError);
    self.error = validationError;
    [self parserDidEndSuccess:NO];

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self parserDidEndSuccess:YES];
}

@end
