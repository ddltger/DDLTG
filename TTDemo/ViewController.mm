//
//  ViewController.m
//  TTDemo
//
//  Created by zing on 2020/10/30.
//

#import "ViewController.h"
#include "TTDisplayLayer.h"

@interface ViewController ()
@property (nonatomic, strong) TTDisplayLayer *displayLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _displayLayer = [[TTDisplayLayer alloc] initWithFrame:CGRectMake(0, 0, 414, 736)];
    [self.view.layer addSublayer:_displayLayer];
}


@end
