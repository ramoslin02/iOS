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

#import "ORSensorStatesMappingTest.h"
#import "ORSensorStatesMapping.h"
#import "ORSensorState.h"

@implementation ORSensorStatesMappingTest

- (void)testSingleStateLookup
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    STAssertNotNil(mapping, @"It should be possible to create an ORSensorStatesMapping");
    ORSensorState *state = [[ORSensorState alloc] initWithName:@"Name" value:@"Value"];
    STAssertNotNil(state, @"It should be possible to create an ORSensorState");
    
    STAssertNil([mapping stateValueForName:@"Name"], @"Looking up a name of a state that has not been added to the mapping should return nil");
    
    [mapping addSensorState:state];
    STAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value", @"Value for state 'Name' should be 'Value'");
}

- (void)testRegisteringTwoTimesAStateForTheSameNameOverridesFirst
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name" value:@"Value1"];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name" value:@"Value2"];
    
    STAssertNil([mapping stateValueForName:@"Name"], @"Looking up a name of a state that has not been added to the mapping should return nil");
    
    [mapping addSensorState:state1];
    STAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value1", @"Value for state 'Name' should be 'Value1'");
    
    [mapping addSensorState:state2];
    STAssertEqualObjects([mapping stateValueForName:@"Name"], @"Value2", @"Value for state 'Name' should be 'Value2' after adding the second state");
}

- (void)testEqualityAndHash
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"];
    [mapping addSensorState:state1];
    
    STAssertTrue([mapping isEqual:mapping], @"Mapping should be equal to itself");
    STAssertFalse([mapping isEqual:nil], @"Mapping should not be equal to nil");
    
    ORSensorStatesMapping *equalMapping = [[ORSensorStatesMapping alloc] init];
    [equalMapping addSensorState:state1];
    STAssertTrue([equalMapping isEqual:mapping], @"Mappings created with same information should be equal");
    STAssertEquals([equalMapping hash], [mapping hash], @"Hashses of mappings created with same information should be equal");
    
    ORSensorStatesMapping *mappingWithDifferentState = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"];
    [mappingWithDifferentState addSensorState:state2];
    STAssertFalse([mappingWithDifferentState isEqual:mapping], @"Mappings with different state should not be equal");
    
    ORSensorStatesMapping *mappingWithNoState = [[ORSensorStatesMapping alloc] init];
    STAssertFalse([mappingWithNoState isEqual:mapping], @"Mappings with different number of states should not be equal");
    
    ORSensorStatesMapping *mappingWithMoreStates = [[ORSensorStatesMapping alloc] init];
    [mappingWithMoreStates addSensorState:state1];
    [mappingWithMoreStates addSensorState:state2];
    STAssertFalse([mappingWithMoreStates isEqual:mapping], @"Mappings with different number of states should not be equal");
}

- (void)testEqualityAndHashWithTwoStates
{
    ORSensorStatesMapping *mappingWithTwoStates = [[ORSensorStatesMapping alloc] init];
    ORSensorState *state1 = [[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"];
    ORSensorState *state2 = [[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"];
    [mappingWithTwoStates addSensorState:state1];
    [mappingWithTwoStates addSensorState:state2];

    STAssertTrue([mappingWithTwoStates isEqual:mappingWithTwoStates], @"Mapping should be equal to itself");
    STAssertFalse([mappingWithTwoStates isEqual:nil], @"Mapping should not be equal to nil");
    
    ORSensorStatesMapping *mappingWithTwoStatesInDifferentOrder = [[ORSensorStatesMapping alloc] init];
    [mappingWithTwoStatesInDifferentOrder addSensorState:state2];
    [mappingWithTwoStatesInDifferentOrder addSensorState:state1];
    
    STAssertTrue([mappingWithTwoStatesInDifferentOrder isEqual:mappingWithTwoStates], @"Mappings created with same states in different order should be equal");
    STAssertEquals([mappingWithTwoStatesInDifferentOrder hash], [mappingWithTwoStates hash], @"Hashses of mappings created with same states in different order should be equal");
}

- (void)testStateValues
{
    ORSensorStatesMapping *mappingWithTwoStates = [[ORSensorStatesMapping alloc] init];
    [mappingWithTwoStates addSensorState:[[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"]];
    [mappingWithTwoStates addSensorState:[[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"]];
    
    STAssertEqualObjects([mappingWithTwoStates stateValues], ([NSSet setWithObjects:@"Value1", @"Value2", nil]),
                         @"Mapping should return all values for states it contains");
    
    [mappingWithTwoStates addSensorState:[[ORSensorState alloc] initWithName:@"Name1" value:@"New value 1"]];
    STAssertEqualObjects([mappingWithTwoStates stateValues], ([NSSet setWithObjects:@"New value 1", @"Value2", nil]),
                         @"Mapping should return all values for states it contains");
}

- (void)testStateValuesDuplicateValues
{
    ORSensorStatesMapping *mapping = [[ORSensorStatesMapping alloc] init];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"Name1" value:@"Value1"]];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"Name2" value:@"Value2"]];
    [mapping addSensorState:[[ORSensorState alloc] initWithName:@"Name3" value:@"Value1"]];
    
    STAssertEqualObjects([mapping stateValues], ([NSSet setWithObjects:@"Value1", @"Value2", nil]),
                         @"Mapping should return all values for states it contains");
}

@end