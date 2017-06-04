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

@interface RRXMLParser () <NSXMLParserDelegate>

@property (nonatomic) NSXMLParser *parser;
@property (nonatomic) RRChannel *channel;
@property (atomic, copy) void (^callbackBlock)(NSArray *items, NSError *error);

@property (nonatomic) NSMutableArray *elements;
@property (nonatomic) NSMutableArray *objects;
@property (nonatomic) NSMutableString *characters;

- (id <XMLMappedObject>)objectForElementNamed:(NSString *)elementName
                               withAttributes:(NSDictionary *)attributes
                                currentObject:(id <XMLMappedObject>)current;

@end

@implementation RRXMLParser

+ (instancetype)parserWithChannel:(RRChannel *)channel withBlock:(void (^)(NSArray *items, NSError *error))block
{
    RRXMLParser *object = [RRXMLParser new];
    object.channel = channel;
    object.callbackBlock = block;
    return object;
}

- (void)parse
{
    NSURL *url = [NSURL URLWithString:self.channel.link];
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    self.parser.delegate = self;
    
    self.elements = [NSMutableArray new];
    self.objects = [NSMutableArray new];
    
    if (![self.parser parse]) {
        self.callbackBlock == nil ?: self.callbackBlock(nil, nil);
    }
}

- (void)cancel
{
    self.callbackBlock = nil;
    [self.parser abortParsing];
}

- (id <XMLMappedObject>)objectForElementNamed:(NSString *)elementName withAttributes:(NSDictionary *)attributes currentObject:(id<XMLMappedObject>)current
{
    if ([elementName isEqualToString:@"channel"]) {
        return self.channel;
    }
    
    return current;
}

#pragma mark NSXMLParser Delegate Methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"elementName: %@", elementName);
//    NSLog(@"attributeDict: %@", attributeDict);
    
    [self.elements addObject:elementName];
    
    id <XMLMappedObject> object = [self objectForElementNamed:elementName withAttributes:attributeDict currentObject:[self.objects lastObject]];
    
    if (object) {
        [self.objects addObject:object];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
//    NSLog(@"foundCharacters: %@", string);
    
    if (!self.characters) {
        self.characters = [NSMutableString new];
    }
    [self.characters appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//    NSLog(@"elementName: %@", elementName);
    
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
}

-(void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    NSLog(@"validationError: %@", validationError);
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.callbackBlock == nil ?: self.callbackBlock(nil, nil);
    
}

@end
