//
//  IntroViewController.m
//  Heresay
//
//  Created by Eric Socolofsky on 4/10/14.
//  Copyright (c) 2014 Heresay Industries, Ltd. All rights reserved.
//

#import "IntroViewController.h"
#import "LocationManager.h"
#import "IntroSlide.h"
#import "IntroSlideViewController.h"

@interface IntroViewController ()

@property (weak, nonatomic) IBOutlet UIButton *enableLocationButton;
- (IBAction)onEnableLocationServicesButtonTapped:(id)sender;
@property(nonatomic,assign) NSInteger pagePosition;
@end


@implementation IntroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _modelArray = [NSMutableArray arrayWithObjects:[[IntroSlide alloc] initWithImageName:@"introLocation" text:@"Welcome! Heresay let you find people around you to chat with."],
                   [[IntroSlide alloc] initWithImageName:@"introChatrooms" text:@"Discover chatrooms around and start chating with the people."],
                   [[IntroSlide alloc] initWithImageName:@"introLocation" text:@"Heresay is about place, so enable your location services."],
                   nil];
    
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:50.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
    
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    IntroSlideViewController *slideViewController = [[IntroSlideViewController alloc] init];
    slideViewController.slide = [_modelArray objectAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:slideViewController];
    
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    
    [_pageViewController didMoveToParentViewController:self];
    
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 0.0, 80.0f);
    self.pageViewController.view.frame = pageViewRect;
    
    self.view.gestureRecognizers = _pageViewController.gestureRecognizers;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onEnableLocationServicesButtonTapped:(id)sender {
	[[LocationManager instance] enableLocationServicesWithResult:^(BOOL allowed) {
		if (!allowed) {
			// TODO: Message user: No location services? No Heresay.
			//		 Here's how to enable it when you're ready to use it.
		} else {
			[self.delegate didDismissModalViewController:self];
		}
	}];
}

#pragma mark - UIPageViewControllerDelegate Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    IntroSlideViewController *contentVc = (IntroSlideViewController *)viewController;
    
    NSUInteger currentIndex = [_modelArray indexOfObject:[contentVc slide]];
    _vcIndex = currentIndex;
    if (currentIndex == 0)
    {
        return nil;
    }

    IntroSlideViewController *slideViewController = [[IntroSlideViewController alloc] init];
    slideViewController.slide = [_modelArray objectAtIndex:currentIndex - 1];
    return slideViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    IntroSlideViewController *contentVc = (IntroSlideViewController *)viewController;
    
    NSUInteger currentIndex = [_modelArray indexOfObject:[contentVc slide]];
    _vcIndex = currentIndex;
    
    if (currentIndex == _modelArray.count - 1){
        [self.enableLocationButton setHidden:NO];
        return nil;
    } else {
        [self.enableLocationButton setHidden:YES];
    }
    
    IntroSlideViewController *slideViewController = [[IntroSlideViewController alloc] init];
    slideViewController.slide = [_modelArray objectAtIndex:currentIndex + 1];
    return slideViewController;
}



#pragma mark - UIPageViewControllerDataSource Method

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return _modelArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
