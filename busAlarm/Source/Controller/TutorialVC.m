//
//  TutorialVC.m
//  busAlarm
//
//  Created by phuongthuy on 11/14/15.
//  Copyright © 2015 PhuongThuy. All rights reserved.
//

#import "TutorialVC.h"
#import "Constants.h"

@interface TutorialVC ()

@end

@implementation TutorialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSkipButtonClicked:(id)sender
{
    [self performSegueWithIdentifier:SEGUE_TUTORIAL_TO_MAIN sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
