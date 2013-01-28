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
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipDescriptionLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
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
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3f : 1.0f;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipDescriptionLabel.adjustsFontSizeToFitWidth = YES;
    // Grab the text description of the flip from the model right when it is needed
    [self updateFlipDescription];
}

- (void)updateFlipDescription {
    NSArray* lastFlipArray = self.game.resultsOfLastFlip;
    NSString* description = @"";
    
    // If there are some results
    if ([lastFlipArray count]) {
        // Just a flip up
        if ([lastFlipArray count] ==2) {
            description = [self createFlipUpString:lastFlipArray];
        } else { // A Match or Mismatch
            description = [self createMatchOrMismatchString:lastFlipArray];
        }
    }
    self.flipDescriptionLabel.text = description;
}

- (NSString*)createMatchOrMismatchString:(NSArray*)flipResultsArray
{
    if (![[flipResultsArray lastObject] isKindOfClass:[NSNumber class]]) {
        NSLog(@"Last element of flip results is not a number");
        return nil;
    }
    int points = [[flipResultsArray lastObject] intValue];
    int index = 0;
    NSString *description = @"";
    while (index < [flipResultsArray count]-1) {
        if ([flipResultsArray[index] isKindOfClass:[Card class]]) {
            Card* curCard = flipResultsArray[index];
            // To create a list with &'s seperating the cards
            if (index!= 0) {
                description = [description stringByAppendingString:@"&"];
            }
            description = [description stringByAppendingString:curCard.contents];
        } else {
            NSLog(@"Non-card found in flip results");
            return nil;
        }
        index++;
    }
    return (points > 0) ? [NSString stringWithFormat:@"Matched %@ for %d points!",description,points]: [NSString stringWithFormat:@"%@ don't match! %d penalty",description,points];
}

- (NSString*) createFlipUpString:(NSArray*)flipResultsArray {
    if ([flipResultsArray[0] isKindOfClass:[Card class]]) {
        Card* curCard = flipResultsArray[0];
        return [NSString stringWithFormat:@"Flipped up %@!", curCard.contents];
    } else {
        NSLog(@"Non-card found in flip results");
        return nil;
    }
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
