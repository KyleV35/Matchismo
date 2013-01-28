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


- (Deck*) getAppropriateDeck
{
    Deck* deck = [[PlayingCardDeck alloc] init];
    return deck;
}

- (void) viewDidLoad
{
    [self.game setNumberOfCardsToMatch:2];
}



@end
