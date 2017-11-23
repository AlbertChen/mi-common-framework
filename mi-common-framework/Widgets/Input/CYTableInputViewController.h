//
//  CYTableInputViewController.h
//  mi-common-framework
//
//  Created by Chen Yiliang on 9/1/16.
//  Copyright © 2016 CYYUN. All rights reserved.
//

#import "CYViewController.h"
#import "CYInputTableViewCell.h"
#import "CYMultiLineInputTableViewCell.h"

@interface CYTableInputViewController : CYViewController <UITableViewDataSource, UITableViewDelegate, CYInputTableViewCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) id firstResponderObject;

- (IBAction)saveButtonPressed:(id)sender;

- (void)scrollToCursorForView: (UIView *)view;

@end
