
#import "cocos2d.h"

/**
 * The Utility class provides static methods that provide convenient
 * functions used throughout the project.
 */
@interface Utility : NSObject

#pragma mark String Formatting

/**
 * This method returns an NSAttributedString formatted to use our 
 * specific UI font, the given size and appropriate kerning. Should
 * be used prior to assigning any string to a UI object.
 *
 * @param text The text to assign
 * @param size The font-size to assign.
 *
 * @return Returns an NSAttributedString to use in the element
 */
+(NSAttributedString*) uiString:(NSString*)string withSize:(int)size;

/**
 * Takes the time remaining in seconds and returns it formatted in
 * minutes and seconds, minutes visible if > 0 and 's' visible after
 * seconds if minutes is 0.
 *
 * Thus: 1:23 or 23s
 *
 * @param timeRemaining the time remaining in seconds
 * @return Returns a formatted time-string
 */
+(NSString*) formatTime:(int)timeRemaining;

/**
 * Takes in the given score value and returns a formatted score with commas
 * separating numbers.
 *
 * @param value The score value to format
 * @return The formatted string
 */
+(NSString*) formatScore:(int)value;

#pragma mark Display Methods

/**
 * Returns a scale value for sprites based on the device type.
 */
+(float) spriteScale;

/**
 * Calculates that amount font sizes should be scaled to for the current
 * device.
 *
 * @param size The font size that you wish to be scaled.
 *
 * @return Returns the size of the font that should be used w/ scale.
 */
+(float) scaledFont:(float)size;

/**
 * Calculates the most appropriate board size based on the size of the device.
 *
 * @return Returns the size, in tiles of the board.
 */
+(CGSize) computeBoardSize;

@end