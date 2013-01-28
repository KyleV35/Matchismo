//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Kyle Vermeer on 1/11/13.
//  Copyright (c) 2013 Kyle Vermeer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic, readonly) CardMatchingGame* game;
@property (weak, nonatomic,readonly) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic,readonly) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic,readonly) IBOutlet UILabel *flipDescriptionLabel;
@property (strong, nonatomic,readonly) IBOutletCollection(UIButton) NSArray *cardButtons;

- (void)updateUI;

@end
