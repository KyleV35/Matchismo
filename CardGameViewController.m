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

@property (weak, nonatomic,readwrite) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipsCount;
@property (weak, nonatomic,readwrite) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic,readwrite) IBOutlet UILabel *flipDescriptionLabel;
@property (strong, nonatomic,readwrite) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic, readwrite) CardMatchingGame* game;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[self getAppropriateDeck]];
        [_game setNumberOfCardsToMatch:[self numberOfCardsToMatch]];
    }
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3f : 1.0f;
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    
    // Grab the text description of the flip from the model right when it is needed
    [self updateFlipDescription];
}

- (void)updateFlipDescription
{
    NSArray* lastFlipArray = self.game.resultsOfLastFlip;
    NSMutableAttributedString* description;
    
    // If there are some results
    if ([lastFlipArray count]) {
        lastFlipArray = [self convertLastFlipArrayToAttributedStrings:lastFlipArray];
        // Just a flip up
        if ([lastFlipArray count] ==2) {
            description = [self createFlipUpString:lastFlipArray];
        } else { // A Match or Mismatch
            description = [self createMatchOrMismatchString:lastFlipArray];
        }
    }
    self.flipDescriptionLabel.attributedText = description;
}

- (NSArray*)convertLastFlipArrayToAttributedStrings:(NSArray*)lastFlipArray
{
    NSMutableArray* attStringArray = [[NSMutableArray alloc] init];
    for (int i =0; i < ([lastFlipArray count] -1);i++) {
        if ([lastFlipArray[i] isKindOfClass:[Card class]]) {
            Card* curCard = lastFlipArray[i];
            [attStringArray addObject:[[NSMutableAttributedString alloc] initWithString:curCard.contents]];
        } else {
            NSLog(@"Non-card found in lastFlipArray");
        }
    }
    [attStringArray addObject:[lastFlipArray lastObject]];
    return attStringArray;
}

- (NSMutableAttributedString*)createMatchOrMismatchString:(NSArray*)flipResultsArray
{
    if (![[flipResultsArray lastObject] isKindOfClass:[NSNumber class]]) {
        NSLog(@"Last element of flip results is not a number");
        return nil;
    }
    int points = [[flipResultsArray lastObject] intValue];
    int index = 0;
    NSMutableAttributedString *description = [[NSMutableAttributedString alloc] initWithString:@""];
    while (index < [flipResultsArray count]-1) {
        NSMutableAttributedString* contents = flipResultsArray[index];
        // To create a list with &'s seperating the cards
        if (index!= 0) {
            [description appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"&"]];
        }
        [description appendAttributedString:contents];
        index++;
    }
    
    // Combine attributed string to create the flip descriptions
    if (points > 0) { // Matched
        NSMutableAttributedString* start = [[NSMutableAttributedString alloc] initWithString:@"Matched "];
        [start appendAttributedString:description];
        NSMutableAttributedString* end = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" for %d points!",points]];
        [start appendAttributedString:end];
        return start;
    } else { // Didn't Match
        NSMutableAttributedString* end = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" don't match! %d penalty",points]];
        [description appendAttributedString:end];
        return description;
    }
}

- (NSMutableAttributedString*) createFlipUpString:(NSArray*)flipResultsArray {
    NSMutableAttributedString* curContents = flipResultsArray[0];
    NSMutableAttributedString* start = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
    [start appendAttributedString:curContents];
    return start;
}

- (void)setFlipsCount:(NSUInteger)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d",self.flipsCount];
}

- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipsCount++;
    [self updateUI];
}

- (IBAction)dealButtonPressed {
    
    //Reset the game
    self.game = nil;
    
    self.flipsCount = 0;
    
    //Reset UI
    [self updateUI];
}

- (Deck*) getAppropriateDeck
{
    NSLog(@"This method (getAppropriateDeck) should be implemented by a subclass.");
    return nil;
}
         
- (NSUInteger) numberOfCardsToMatch
{
    NSLog(@"This method (numberOfCardsToMatch) should be implemented by a subclass.");
    return 0;
}
@end
