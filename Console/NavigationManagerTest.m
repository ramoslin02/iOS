/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2015, OpenRemote Inc.
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

#import "NavigationManagerTest.h"
#import "NavigationManager.h"
#import "ORScreenOrGroupReference.h"
#import "ORControllerClient/Definition.h"
#import "ORControllerClient/ORGroup.h"
#import "ORControllerClient/ORScreen.h"
#import "ORObjectIdentifier.h"
#import "NavigationHistoryInMemoryStore.h"

@interface ORGroup (_PrivateForTest)

- (instancetype)initWithGroupIdentifier:(ORObjectIdentifier *)anIdentifier name:(NSString *)aName;
- (void)addScreen:(ORScreen *)screen;

@end

@interface ORScreen (_PrivateForTest)

- (instancetype)initWithScreenIdentifier:(ORObjectIdentifier *)anIdentifier
                                    name:(NSString *)aName
                             orientation:(ORScreenOrientation)anOrientation;

@end

@interface NavigationManagerTest ()

@property (nonatomic, strong) ORGroup *group1, *group2, *group3;
@property (nonatomic, strong) ORScreen *screen1, *screen2, *screen3;
@property (nonatomic, strong) Definition *definition;

@end

@implementation NavigationManagerTest

- (void)setUp {
    [super setUp];
    self.definition = [[Definition alloc] init];
    
    ORObjectIdentifier *group1Id = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *group2Id = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    ORObjectIdentifier *group3Id = [[ORObjectIdentifier alloc] initWithIntegerId:3];
    
    ORObjectIdentifier *screen1Id = [[ORObjectIdentifier alloc] initWithIntegerId:11];
    ORObjectIdentifier *screen2Id = [[ORObjectIdentifier alloc] initWithIntegerId:12];
    ORObjectIdentifier *screen3Id = [[ORObjectIdentifier alloc] initWithIntegerId:13];
    
    self.screen1 = [[ORScreen alloc] initWithScreenIdentifier:screen1Id name:@"Screen 1" orientation:ORScreenOrientationPortrait];
    self.screen2 = [[ORScreen alloc] initWithScreenIdentifier:screen2Id name:@"Screen 2" orientation:ORScreenOrientationPortrait];
    self.screen3 = [[ORScreen alloc] initWithScreenIdentifier:screen3Id name:@"Screen 3" orientation:ORScreenOrientationPortrait];
    self.group1 = [[ORGroup alloc] initWithGroupIdentifier:group1Id name:@"Group 1"];
    self.group2 = [[ORGroup alloc] initWithGroupIdentifier:group2Id name:@"Group 2"];
    self.group3 = [[ORGroup alloc] initWithGroupIdentifier:group3Id name:@"Group 3"];
    [self.group1 addScreen:self.screen1];
    [self.group3 addScreen:self.screen2];
    [self.group3 addScreen:self.screen3];
    
    [self.definition addGroup:self.group1];
    [self.definition addGroup:self.group2];
    [self.definition addGroup:self.group3];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidInit
{
    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:self.definition];
    STAssertNotNil(navManager, @"NavigationManager should initialize when given a valid Definition");
}

- (void)testInitWithNoDefinition
{
    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:nil];
    STAssertNil(navManager, @"NavigationManager should not initialize when not given a valid Definition");
}

- (void)testCurrentScreenOnInit
{
    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:self.definition navigationHistoryStore:[[NavigationHistoryInMemoryStore alloc] init]];
    ORScreenOrGroupReference *screenReference = [navManager currentScreenReference];
    STAssertNotNil(screenReference, @"A valid ScreenReference should be available after init");
    STAssertEqualObjects(screenReference.groupIdentifier, self.group1.identifier, @"Current group on init should be first group");
    STAssertEqualObjects(screenReference.screenIdentifier, self.screen1.identifier, @"Current screen on init should be first screen");
}

- (void)testCurrentScreenOnInitWithFirstGroupWithNoScreen
{
    Definition *definition = [[Definition alloc] init];
    
    ORObjectIdentifier *group1Id = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *group2Id = [[ORObjectIdentifier alloc] initWithIntegerId:2];
    ORObjectIdentifier *screenId = [[ORObjectIdentifier alloc] initWithIntegerId:3];
    
    ORScreen *screen1 = [[ORScreen alloc] initWithScreenIdentifier:screenId name:@"Screen 1" orientation:ORScreenOrientationPortrait];
    ORGroup *group2 = [[ORGroup alloc] initWithGroupIdentifier:group2Id name:@"Group 2"];
    [group2 addScreen:screen1];

    [definition addGroup:[[ORGroup alloc] initWithGroupIdentifier:group1Id name:@"Group 1"]];
    [definition addGroup:group2];
    
    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:definition navigationHistoryStore:[[NavigationHistoryInMemoryStore alloc] init]];

    ORScreenOrGroupReference *screenReference = [navManager currentScreenReference];

    STAssertNotNil(screenReference, @"A valid ScreenReference should be available after init");
    STAssertEqualObjects(screenReference.groupIdentifier, group2Id, @"Current group on init should be first group with screen");
    STAssertEqualObjects(screenReference.screenIdentifier, screenId, @"Current screen on init should be first screen");

}

- (void)testCurrentScreenOnInitWithOnlyGroupsWithoutScreen
{
    Definition *definition = [[Definition alloc] init];

    ORObjectIdentifier *group1Id = [[ORObjectIdentifier alloc] initWithIntegerId:1];
    ORObjectIdentifier *group2Id = [[ORObjectIdentifier alloc] initWithIntegerId:2];

    [definition addGroup:[[ORGroup alloc] initWithGroupIdentifier:group1Id name:@"Group 1"]];
    [definition addGroup:[[ORGroup alloc] initWithGroupIdentifier:group2Id name:@"Group 2"]];

    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:definition navigationHistoryStore:[[NavigationHistoryInMemoryStore alloc] init]];
    
    STAssertNil([navManager currentScreenReference], @"There should be no current screen reference with a definition with only empty groups");
}

- (void)testCurrentScreenOnInitWithEmptyDefinition
{
    Definition *definition = [[Definition alloc] init];
    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:definition navigationHistoryStore:[[NavigationHistoryInMemoryStore alloc] init]];
    STAssertNil([navManager currentScreenReference], @"There should be no current screen reference with an empty definition");
}




- (void)testNavigateToExistingGroupAndScreen
{
    NavigationManager *navManager = [[NavigationManager alloc] initWithDefinition:self.definition navigationHistoryStore:[[NavigationHistoryInMemoryStore alloc] init]];
    ORScreenOrGroupReference *screenReference = [navManager navigateToGroup:self.group3 toScreen:self.screen2];
    
    STAssertNotNil(screenReference, @"It should be possible to navigate to an existing group and screen");
    STAssertEqualObjects(screenReference.groupIdentifier, self.group3.identifier, @"Should have navigated to requested group");
    STAssertEqualObjects(screenReference.screenIdentifier, self.screen2.identifier, @"Should have navigated to requested screen");
    
    STAssertEqualObjects([navManager currentScreenReference], screenReference, @"Current screen reference should be destination of last valid navigation");
}

@end