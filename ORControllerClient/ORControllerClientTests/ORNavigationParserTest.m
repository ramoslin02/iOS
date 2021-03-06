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

#import "ORNavigationParserTest.h"
#import "DefinitionElementParserRegister.h"
#import "XMLEntity.h"
#import "ORNavigationParser.h"
#import "DefinitionParserMock.h"
#import "ORNavigation.h"
#import "ORScreen_Private.h"
#import "ORGroup_Private.h"
#import "Definition.h"
#import "ORScreenNavigation.h"
#import "ORObjectIdentifier.h"

@implementation ORNavigationParserTest

- (DefinitionElementParser *)parseXMLSnippet:(NSString *)snippet
{
    DefinitionElementParserRegister *depRegistry = [[DefinitionElementParserRegister alloc] init];
    
    Definition *definition = [[Definition alloc] init];
    ORScreen *screen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:12] name:@"Screen" orientation:ORScreenOrientationPortrait];
    [definition addScreen:screen];
    ORGroup *group = [[ORGroup alloc] initWithGroupIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3] name:@"Group"];
    [definition addGroup:group];
    depRegistry.definition = definition;
    
    [depRegistry registerParserClass:[ORNavigationParser class] endSelector:@selector(setTopLevelParser:) forTag:NAVIGATE];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:[snippet dataUsingEncoding:NSUTF8StringEncoding]];
    DefinitionParserMock *parser = [[DefinitionParserMock alloc] initWithRegister:depRegistry attributes:nil];
    [parser addKnownTag:NAVIGATE];
    [xmlParser setDelegate:parser];
    [xmlParser parse];
    
    // This is normally done by PanelDefinitionParser, must call it manually when testing
    [depRegistry performDeferredBindings];
    
    return parser.topLevelParser;
}

- (ORNavigation *)parseValidXMLSnippet:(NSString *)snippet
{
    DefinitionElementParser *topLevelParser = [self parseXMLSnippet:snippet];
    STAssertNotNil(topLevelParser, @"Valid XML snippet should be parsed correctly");
    STAssertTrue([topLevelParser isMemberOfClass:[ORNavigationParser class]], @"Parser used should be an ORNavigationParser");
    ORNavigation *navigation = ((ORNavigationParser *)topLevelParser).navigation;
    STAssertNotNil(navigation, @"A navigation should be parsed for given XML snippet");
    
    return navigation;
}

- (void)testParseNavigateToScreen
{
    ORNavigation *navigation = [self parseValidXMLSnippet:@"<navigate toScreen=\"12\"/>"];
    
    STAssertEquals(navigation.navigationType, ORNavigationTypeToGroupOrScreen, @"Parsed navigation should navigate to group or screen");
    
    STAssertTrue([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should be an ORScreenNavigation");
    
    STAssertEqualObjects(((ORScreenNavigation *)navigation).destinationScreen.identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:12],
                         @"Parsed navigation should navigate to screen with id 12");
    STAssertNil(((ORScreenNavigation *)navigation).destinationGroup, @"Parsed navigation should not navigate to any group");
}

- (void)testParseNavigateToGroup
{
    ORNavigation *navigation = [self parseValidXMLSnippet:@"<navigate toGroup=\"3\"/>"];
    
    STAssertEquals(navigation.navigationType, ORNavigationTypeToGroupOrScreen, @"Parsed navigation should navigate to group or screen");
    
    STAssertTrue([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should be an ORScreenNavigation");
    
    STAssertNil(((ORScreenNavigation *)navigation).destinationScreen, @"Parsed navigation should not navigate to any screen");
    STAssertEqualObjects(((ORScreenNavigation *)navigation).destinationGroup.identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:3],
                         @"Parsed navigation should navigate to group with id 3");
}

- (void)testParseNavigateToScreenAndGroup
{
    ORNavigation *navigation = [self parseValidXMLSnippet:@"<navigate toGroup=\"3\" toScreen=\"12\"/>"];
    
    STAssertEquals(navigation.navigationType, ORNavigationTypeToGroupOrScreen, @"Parsed navigation should navigate to group or screen");
    
    STAssertTrue([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should be an ORScreenNavigation");
    
    STAssertEqualObjects(((ORScreenNavigation *)navigation).destinationScreen.identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:12],
                         @"Parsed navigation should navigate to screen with id 12");
    STAssertEqualObjects(((ORScreenNavigation *)navigation).destinationGroup.identifier,
                         [[ORObjectIdentifier alloc] initWithIntegerId:3],
                         @"Parsed navigation should navigate to group with id 3");
}

- (void)testParseNavigateLogicalType
{
    ORNavigation *navigation = [self parseValidXMLSnippet:@"<navigate to=\"setting\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationTypeSettings, @"Parsed navigation should navigate to settings");
    STAssertFalse([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should not be an ORScreenNavigation");
    
    navigation = [self parseValidXMLSnippet:@"<navigate to=\"back\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationTypeBack, @"Parsed navigation should navigate back");
    STAssertFalse([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should not be an ORScreenNavigation");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"login\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationTypeLogin, @"Parsed navigation should perform login");
    STAssertFalse([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should not be an ORScreenNavigation");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"logout\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationTypeLogout, @"Parsed navigation should peform logout");
    STAssertFalse([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should not be an ORScreenNavigation");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"nextScreen\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationTypeNextScreen, @"Parsed navigation should navigate to next screen");
    STAssertFalse([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should not be an ORScreenNavigation");

    navigation = [self parseValidXMLSnippet:@"<navigate to=\"previousScreen\"/>"];
    STAssertEquals(navigation.navigationType, ORNavigationTypePreviousScreen, @"Parsed navigation should navigate to previous screen");
    STAssertFalse([navigation isMemberOfClass:[ORScreenNavigation class]], @"Parser navigation should not be an ORScreenNavigation");
}

@end