//
//  PlayingCard.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

+(NSArray*)validSuits
{
    static NSArray* validSuits = nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}

+(NSUInteger)maxRank
{
    return [self rankStrings].count-1;
}

+(NSArray*)rankStrings
{
    static NSArray* rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
    return rankStrings;
}

- (NSString*)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString*)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    if (otherCards.count==1) {
        PlayingCard* otherCard = [otherCards lastObject];
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    }
    if (otherCards.count == 2) {
        PlayingCard* firstCard = [otherCards objectAtIndex:0];
        PlayingCard* secondCard = [otherCards lastObject];
        if ([firstCard.suit isEqualToString:self.suit] && [secondCard.suit isEqualToString:self.suit]) {
            score = 2;
        } else if (firstCard.rank == self.rank && secondCard.rank == self.rank) {
            score = 8;
        }
    }
    
    return score;
}



@end
