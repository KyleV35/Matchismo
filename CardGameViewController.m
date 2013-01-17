//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Kyle Vermeer on 1/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipsCount;
@property (strong, nonatomic) Deck* deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;

@end

@implementation CardGameViewController

- (Deck*)deck
{
    // Lazy instatiation of deck
    if (!_deck)_deck = [[PlayingCardDeck alloc] init];
    return _deck;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    for (UIButton* cardButton in cardButtons) {
        Card* card = [self.deck drawRandomCard];
        NSString* contents = card.contents;
        // Checking for empty deck
        if (!contents) {
            cardButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            contents = @"Empty";
        }
        [cardButton setTitle:contents forState:UIControlStateSelected];
    }
}

- (void)setFlipsCount:(NSUInteger)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipsCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.flipsCount++;
}


@end
