/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2014, OpenRemote Inc.
 *
 * See the contributors.txt file in the distribution for a
 * full listing of individual contributors.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#import "ORButonParser_2_0_0.h"
#import "ORButton_Private.h"
#import "ORObjectIdentifier.h"
#import "ORLabel.h"
#import "ORImageParser.h"
#import "NavigateParser.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"

#define kDefaultRepeatDelay 300
#define kDefaultLongPressDelay  250

typedef NS_ENUM(NSInteger, ButtonImageType) {
    ImageNone,
	ImageUnpressed,
	ImagePressed
};

@interface ORButonParser_2_0_0 ()

@property (nonatomic, assign) ButtonImageType currentImageType;
@property (nonatomic, strong, readwrite) ORButton *button;

@end

@implementation ORButonParser_2_0_0

- (id)initWithRegister:(DefinitionElementParserRegister *)aRegister attributes:(NSDictionary *)attributeDict
{
    self = [super initWithRegister:aRegister attributes:attributeDict];
    if (self) {
        [self addKnownTag:NAVIGATE];
        [self addKnownTag:IMAGE];
        self.button = [[ORButton alloc] initWithIdentifier:[[ORObjectIdentifier alloc] initWithStringId:[attributeDict objectForKey:@"id"]]
                                                     label:[[ORLabel alloc] initWithIdentifier:nil text:[attributeDict objectForKey:@"name"]]
                                          repeat:[@"TRUE" isEqualToString:[[attributeDict objectForKey:@"repeat"] uppercaseString]]
                                     repeatDelay:kDefaultRepeatDelay
                                 hasPressCommand:[@"TRUE" isEqualToString:[[attributeDict objectForKey:@"hasControlCommand"] uppercaseString]]
                          hasShortReleaseCommand:FALSE hasLongPressCommand:FALSE hasLongReleaseCommand:FALSE
                                  longPressDelay:kDefaultLongPressDelay];
        self.button.definition = aRegister.definition;
    }
    return self;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([DEFAULT isEqualToString:elementName]) {
        self.currentImageType = ImageUnpressed;
    } else if ([PRESSED isEqualToString:elementName]) {
        self.currentImageType = ImagePressed;
    } else {
        [super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([DEFAULT isEqualToString:elementName] || [PRESSED isEqualToString:elementName]) {
        self.currentImageType = ImageNone;
    } else {
        [super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    }
}

- (void)endNavigateElement:(NavigateParser *)parser
{
    self.button.navigate = parser.navigate;
}

- (void)endImageElement:(ORImageParser *)parser
{
    switch (self.currentImageType) {
        case ImageUnpressed:
            self.button.unpressedImage = parser.image;
            break;
        case ImagePressed:
            self.button.pressedImage = parser.image;
            break;
        default:
            break;
    }
}

@synthesize button;
@synthesize currentImageType;

@end