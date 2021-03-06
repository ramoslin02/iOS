/*
 * OpenRemote, the Home of the Digital Home.
 * Copyright 2008-2012, OpenRemote Inc.
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
#import "ControllerException.h"
#import "ORConsoleSettingsManager.h"
#import "ORConsoleSettings.h"
#import "ORControllerConfig.h"

@implementation ControllerException

+ (NSString *)controller:(ORControllerConfig *)controller exceptionMessageOfCode:(NSInteger)code {
	NSString *errorMessage = nil;
	if (code != 200) {
		switch (code) {
            case FORBIDDEN:
                errorMessage = @"Access to controller forbidden";
                break;
			case REQUEST_ERROR://404
				errorMessage = @"The command was sent to an invalid URL.";
				break;
			case CMD_BUILDER_ERROR://418
				errorMessage = @"Controller failed to construct an event for this command.";
				break;
			case NO_SUCH_COMPONENT://419
				errorMessage = @"Controller did not recognize the sent command id.";
				break;
			case NO_SUCH_CMD_BUILDER://420
				errorMessage = @"Command builder not found.";
				break;
			case INVALID_COMMAND_TYPE://421
				errorMessage = @"Invalid command type.";
				break;
			case CONTROLLER_XML_NOT_FOUND://422
				errorMessage = @"Error in controller - controller.xml is not correctly deployed.";
				break;
			case NO_SUCH_CMD://423
				errorMessage = @"Command not found.";
				break;
			case INVALID_CONTROLLER_XML://424
				errorMessage = @"Invalid controller.xml.";
				break;
			case INVALID_POLLING_URL://425
				errorMessage = @"Invalid polling url.";
				break;
			case PANEL_XML_NOT_FOUND://426
				errorMessage = @"panel.xml not found.";
				break;
			case INVALID_PANEL_XML://427
				errorMessage = @"Invalid panel.xml.";
				break;
			case NO_SUCH_PANEL://428
				if (!controller.selectedPanelIdentity) {
					errorMessage = @"Welcome, please choose your own panel identity in Settings";
				} else {
					errorMessage = [NSString stringWithFormat:@"Current panel identity ‘%@’ isn't available. Please choose again in Settings.", 
                                        controller.selectedPanelIdentity];
				}				
				break;
			case INVALID_ELEMENT://429
				errorMessage = @"Invalid XML element.";
				break;
			case SERVER_ERROR://500
				errorMessage = @"Error in controller. Please check controller log.";
				break;
			case CONTROLLER_CONFIG_CHANGED://506
				errorMessage = @"Configuration of controller changed.";
				break;
			case UNAUTHORIZED://401
				errorMessage = @"You can't execute a protected command without authentication.";
				break;
		}
		if (!errorMessage) {
			errorMessage = [NSString stringWithFormat:@"Occured unknown error, satus code is %ld", (long)code];
		}
	}
	return errorMessage;
}

@end
