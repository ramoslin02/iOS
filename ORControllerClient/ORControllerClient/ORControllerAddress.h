/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2013, OpenRemote Inc.
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

#import <Foundation/Foundation.h>

/**
 * Logical address of an OpenRemote controller, providing enough information to establish a connection to it.
 * This hides the exact implementation of the connection mechanism, that is of no importance to clients.
 */
@interface ORControllerAddress : NSObject

/**
 * Initializes an address referencing the controller at provided URL.
 * 
 * In this first implementation, we use the full URL to the controller root context as the identifier.
 * This means the address will become invalid if e.g. controller changes IP or port.
 *
 * @param aURL full URL to controller root context
 *
 * @return An ORControllerAddress object initialized with given URL. If no URL was given, returns nil.
 */
- (instancetype)initWithPrimaryURL:(NSURL *)aURL;

/**
 * Full URL to controller root context
 */
@property (strong, nonatomic, readonly) NSURL *primaryURL;

@end
