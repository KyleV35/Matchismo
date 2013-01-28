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

- (void) updateUI
{
    [super updateUI];
    // Only create this image once (outside the loop) to be efficient
    UIImage *cardBackImage = [UIImage imageNamed:@"Matchismo.png"];
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        //If card is face up, display contents
        if (card.isFaceUp) {
            [cardButton setTitle:card.contents forState:UIControlStateNormal];
            //Need to set image to nil in order to display title properly
            [cardButton setImage:nil forState:UIControlStateNormal];
        } else { //If card is face down, display image
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
            [cardButton setTitle:nil forState:UIControlStateNormal];
        }
    }
}



@end
