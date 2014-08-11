
#import "cocos2d.h"

/**
 * TColour provides us with a limited class that initialises
 * only 4 TColours with assigned colour, thus allowing easy comparisons
 * within the rest of the program.
 *
 * @date 11/08/14
 * @author Ronan Turner
 */
@interface TColour : NSObject

/* The CColor that this object actually represents */
@property (nonatomic) CCColor *color;

/**
 * Our static methods returning the various singleton-instances of
 * TColour.
 */
+(TColour *) colourOne;
+(TColour *) colourTwo;
+(TColour *) colourThree;
+(TColour *) colourFour;

/** 
 * Accesses a colour using a number.
 *
 * @param  num A value between 1 and 4.
 * @return A pointer to TColour with associated value or TColourOne if unknown.
 */
+(TColour *) colourForNum:(int)num;

@end