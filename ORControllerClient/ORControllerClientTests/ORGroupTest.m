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

#import "ORGroupTest.h"
#import "ORGroup_Private.h"
#import "ORScreen_Private.h"
#import "ORObjectIdentifier.h"

@interface ORGroupTest ()

@property (nonatomic, strong) ORGroup *testGroup;

@end

@implementation ORGroupTest

- (void)setUp
{
    self.testGroup = [[ORGroup alloc] initWithGroupIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:1] name:@"Group"];
    [self.testGroup addScreen:[[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]
                                                                    name:@"Portrait screen"
                                                             orientation:ORScreenOrientationPortrait]];
    [self.testGroup addScreen:[[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:3]
                                                                    name:@"Landscape screen"
                                                             orientation:ORScreenOrientationLandscape]];
    [self.testGroup addScreen:[[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:4]
                                                                    name:@"Portrait screen"
                                                             orientation:ORScreenOrientationPortrait]];
    [self.testGroup addScreen:[[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:5]
                                                                    name:@"Landscape screen"
                                                             orientation:ORScreenOrientationLandscape]];
}

- (void)testScreensCollectionOrderCorrect
{
    STAssertEquals([self.testGroup.screens count], (NSUInteger)4, @"There should be 4 screens in test group");
    STAssertEqualObjects([self.testGroup.screens[0] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:2],
                         @"First screen in group should have id 2");
    STAssertEqualObjects([self.testGroup.screens[1] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:3],
                         @"Second screen in group should have id 3");
    STAssertEqualObjects([self.testGroup.screens[2] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:4],
                         @"Thrid screen in group should have id 4");
    STAssertEqualObjects([self.testGroup.screens[3] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:5],
                         @"Fourth screen in group should have id 5");
}

- (void)testPortraitScreensCollectionFiltersCorrectlyAndRespectsOrder
{
    STAssertEquals([[self.testGroup portraitScreens] count], (NSUInteger)2, @"There should be 2 screens in portrait orientation in the group");
    STAssertEqualObjects([[self.testGroup portraitScreens][0] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:2],
                         @"First portrait screen in group has id 2");
    STAssertEqualObjects([[self.testGroup portraitScreens][1] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:4],
                         @"Second portrait screen in group has id 4");
}

- (void)testLandscapeScreensCollectionFiltersCorrectlyAndRespectsOrder
{
    STAssertEquals([[self.testGroup landscapeScreens] count], (NSUInteger)2, @"There should be 2 screens in landscape orientation in the group");
    STAssertEqualObjects([[self.testGroup landscapeScreens][0] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:3],
                         @"First landscape screen in group has id 3");
    STAssertEqualObjects([[self.testGroup landscapeScreens][1] identifier], [[ORObjectIdentifier alloc] initWithIntegerId:5],
                         @"Second landscape screen in group has id 5");
}

- (void)testAddingScreenWithExistingIdDoesNotAddOrUpdateScreen
{
    ORScreen *newScreen = [[ORScreen alloc] initWithScreenIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]
                                                                name:@"New screen"
                                                         orientation:ORScreenOrientationLandscape];
    [self.testGroup addScreen:newScreen];
    STAssertEquals([self.testGroup.screens count], (NSUInteger)4, @"There are still 4 screens in the group");
    
    ORScreen *screen = [self.testGroup findScreenByIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]];
    STAssertEqualObjects(screen.name, @"Portrait screen", @"Screen name has not been updated");
    STAssertEquals(screen.orientation, ORScreenOrientationPortrait, @"Screen orientation has not been updated");
}

- (void)testFindScreenByIdentifierForExistingIdentifier
{
    ORScreen *screen = [self.testGroup findScreenByIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:2]];
    STAssertNotNil(screen, @"There should be one screen with id 2 in the group");
    STAssertEqualObjects(screen.identifier, [[ORObjectIdentifier alloc] initWithIntegerId:2], @"Found screen should have id 2");
}

- (void)testFindScreenByIdentifierForNonExistingIdentifier
{
    STAssertNil([self.testGroup findScreenByIdentifier:[[ORObjectIdentifier alloc] initWithIntegerId:10]],
                @"There should be no screen with id 10 in the group");
}

@end