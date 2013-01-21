//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/17/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic, strong) NSString* flipDescription;

// Lets the game know how many cards it should be matching
@property (nonatomic) NSUInteger numCardsToMatch;
@end

@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSString*)flipDescription
{
    if (!_flipDescription) _flipDescription = @"";
    return _flipDescription;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck numberOfCardsToMatch:(NSUInteger)numberToMatch
{
    self = [super init];
    if (self) {
        for (int i=0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    self.numCardsToMatch = numberToMatch;
    return self;
}

- (Card*) cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define FLIP_COST 1
#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4

- (void) flipCardAtIndex:(NSUInteger)index
{
    Card* card = [self cardAtIndex:index];
    bool wasMatchOrMismatch = NO;
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            if (self.numCardsToMatch == 2) {
                wasMatchOrMismatch = [self handleTwoCardMatch:card];
            } else if (self.numCardsToMatch == 3) {
                wasMatchOrMismatch = [self handleThreeCardMatch:card];
            }
            self.score -= FLIP_COST;
            // If there was no match or mismatch, description
            // should just say card was flipped
            if (!wasMatchOrMismatch) {
                self.flipDescription = [NSString stringWithFormat:@"Flipped Up: %@",card.contents];
            }
        }
        card.faceUp = !card.isFaceUp;
    }
}


/* Checks to see if two cards are turned face up.  If two cards are face up,
 * it checks if they are a match or not and updates the score accordingly.  Return YES
 * if there was a match or a mismatch, returns NO if only one card is faceup.
 */
-(BOOL)handleTwoCardMatch:(Card*)card
{
    for (Card* otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            int matchScore = [card match:@[otherCard]];
            if (matchScore) {
                otherCard.unplayable = YES;
                card.unplayable = YES;
                self.score += matchScore * MATCH_BONUS;
                self.flipDescription = [NSString stringWithFormat:@"Matched %@ and %@ for %d points!",card.contents,otherCard.contents,matchScore * MATCH_BONUS];
            } else {
                otherCard.faceUp = NO;
                self.flipDescription = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!",card.contents,otherCard.contents,MISMATCH_PENALTY];
                self.score -= MISMATCH_PENALTY;
            }
            return YES;
        }
    }
    // Only one card is faceup
    return NO;
}

/* Checks to see if three cards are turned face up.  If three cards are face up,
 * it checks if they are a match or not and updates the score accordingly.  Return YES
 * if there was a match or a mismatch, returns NO if only one or two cards are faceup.
 */
-(BOOL)handleThreeCardMatch:(Card*)card
{
    Card* firstCard = nil;
    Card* secondCard = nil;
    for (Card* otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            if (!firstCard) {
                firstCard = otherCard;
            } else {
                secondCard = otherCard;
                break;
            }
        }
    }
    // If only two cards are turned up, return NO
    if (!secondCard) {
        return NO;
    } else {
        int matchScore = [card match:@[firstCard,secondCard]];
        if (matchScore) {
            firstCard.unplayable = YES;
            secondCard.unplayable = YES;
            card.unplayable = YES;
            self.score += matchScore * MATCH_BONUS;
            self.flipDescription = [NSString stringWithFormat:@"Matched %@,%@, and %@ for %d points!", card.contents, firstCard.contents, secondCard.contents, matchScore * MATCH_BONUS];
        } else {
            firstCard.faceUp = NO;
            secondCard.faceUp = NO;
            self.flipDescription = [NSString stringWithFormat:@"%@,%@, and %@ don't match! %d point penalty!",card.contents,firstCard.contents,secondCard.contents,MISMATCH_PENALTY];
            self.score -= MISMATCH_PENALTY;
        }
        return YES;
    }
    return NO;

}


-(void)setNumberOfCardsToMatch:(NSUInteger)numberToMatch
{
    self.numCardsToMatch = numberToMatch;
}

@end
