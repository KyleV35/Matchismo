//
//  SetCard.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "SetCard.h"

#define NUM_VALUES 3
#define MAX_NUMBER 2
#define MAX_SHADING 2
#define MAX_COLOR 2
#define MAX_SHAPE 2

@implementation SetCard

+ (NSUInteger) maxShape
{
    return MAX_SHAPE;
}

+ (NSUInteger) maxNumber
{
    return MAX_NUMBER;
}

+ (NSUInteger) maxColor
{
    return MAX_COLOR;
}

+ (NSUInteger) maxShading
{
    return MAX_SHADING;
}

- (void)setShape:(NSUInteger)shape
{
    if (shape <= [SetCard maxShape]) {
        _shape = shape;
    } else {
        NSLog(@"Attempted to set an invalid shape: %u",shape);
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    } else {
        NSLog(@"Attempted to set an invalid number: %u",number);
    }
}

- (void)setShading:(NSUInteger)shading
{
    if (shading <= [SetCard maxShading]) {
        _shading = shading;
    } else {
        NSLog(@"Attempted to set an invalid shading: %u",shading);
    }
}

- (void)setColor:(NSUInteger)color
{
    if (color <= [SetCard maxColor]) {
        _color = color;
    } else {
        NSLog(@"Attempted to set an invalid color: %u",color);
    }
}

/* Shape,number,color,shading */
- (NSString*)contents
{
    return [NSString stringWithFormat:@"%u%u%u%u",self.shape,self.number,self.color,self.shading];
}

- (int) match:(NSArray *)otherCards
{
    int shapeMatch = [self shapeMatch:otherCards];
    int numberMatch = [self numberMatch:otherCards];
    int shadingMatch = [self shadingMatch:otherCards];
    int colorMatch = [self colorMatch:otherCards];
    return shapeMatch + numberMatch + shadingMatch + colorMatch;
}

- (int) shapeMatch:(NSArray*)otherCards
{
    NSMutableArray* shapeArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [shapeArray addObject:@(card.shape)];
    }
    [shapeArray addObject:@(self.shape)];
    return [SetCard setMatch:[NSArray arrayWithArray:shapeArray]];
}

- (int)numberMatch:(NSArray*)otherCards
{
    NSMutableArray* numberArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [numberArray addObject:@(card.number)];
    }
    [numberArray addObject:@(self.number)];
    return [SetCard setMatch:[NSArray arrayWithArray:numberArray]];
}

- (int)shadingMatch:(NSArray*)otherCards
{
    NSMutableArray* shadingArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [shadingArray addObject:@(card.shading)];
    }
    [shadingArray addObject:@(self.shading)];
    return [SetCard setMatch:[NSArray arrayWithArray:shadingArray]];
}

- (int)colorMatch:(NSArray*)otherCards
{
    NSMutableArray* colorArray = [[NSMutableArray alloc] init];
    for (SetCard* card in otherCards) {
        [colorArray addObject:@(card.color)];
    }
    [colorArray addObject:@(self.color)];
    return [SetCard setMatch:[NSArray arrayWithArray:colorArray]];
}


/* Values argument must have all values, including current cards values */
+ (int)setMatch:(NSArray*)values
{
    NSMutableArray* frequencyArray = [[NSMutableArray alloc] init];
    for (NSUInteger i=0; i < NUM_VALUES; i++) {
        [frequencyArray addObject:@(0)];
    }
    for (NSNumber* value in values) {
        frequencyArray[[value unsignedIntValue]] = @([frequencyArray[[value unsignedIntValue]] unsignedIntValue] +1);
    }
    NSUInteger numCards =[values count];
    bool isMatch = YES;
    for (NSUInteger i=0; i < NUM_VALUES; i++) {
        if ([frequencyArray[i] unsignedIntValue] == numCards) {
            isMatch = YES;
            break;
        } else if ([frequencyArray[i] unsignedIntValue] != 1) {
            isMatch = NO; // Don't break, if one key has all the values, it is a match
        }
    }
    return isMatch ? 1 : 0;

}

@end
