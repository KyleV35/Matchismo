//
//  PlayingCardMatchingGameViewController.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/27/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "PlayingCardMatchingGameViewController.h"

@interface PlayingCardMatchingGameViewController ()

@end

@implementation PlayingCardMatchingGameViewController

#define NUMBER_OF_CARDS_TO_MATCH 2


- (Deck*) getAppropriateDeck
{
    Deck* deck = [[PlayingCardDeck alloc] init];
    return deck;
}

- (NSUInteger) numberOfCardsToMatch
{
    return NUMBER_OF_CARDS_TO_MATCH;
}



@end
