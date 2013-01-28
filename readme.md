CBIntrospector
============
![app icon](https://github.com/cbess/ViewIntrospector/raw/master/CBIntrospector/appicon.png)

[Download View Introspector](http://goo.gl/eWtrr)

Introspector is a small set of tools for iOS and the iOS Simulator that aid in debugging user interfaces built with UIKit. It's especially useful for UI layouts that are dynamically created or can change during runtime, or for tuning performance by finding non-opaque views or views that are re-drawing unnecessarily. It's designed for use in the iOS simulator, but can also be used on a device.

![Introspect Demo Image](http://domesticcat.com.au/projects/introspect/introspectdemo.png)

![View Introspector Screenshot](https://github.com/cbess/ViewIntrospector/raw/master/cbintrospector-screenshot.jpg)

[Download View Introspector](http://goo.gl/eWtrr)

It uses keyboard shortcuts to handle starting, ending and other commands. It can also be invoked via an app-wide `UIGestureRecognizer` if it is to be used on the device.

Features:
--------------
* Simple to setup and use
* Compatible with the iOS Simulator companion desktop app - [View Introspector](https://github.com/cbess/ViewIntrospector)
* Send messages (call any method) to the selected view from the desktop app or from device (tap the status bar) during runtime
* Controlled via app-wide keyboard commands
* Highlighting of view frames
* Displays a views origin & size, including distances to edges of main window
* Move and resize view frames during runtime using shortcut keys
* Logging of properties of a view, including subclass properties, actions and targets (see below for an example)
* Logging of accessibility properties — useful for UI automation scripts
* Manually call setNeedsDisplay, setNeedsLayout and reloadData (for UITableView)
* Highlight all view outlines
* Highlight all views that are non-opaque
* Shows warning for views that are positioned on non-integer origins (will cause blurriness when drawn)
* Print a views hierarchy to console (via private method `recursiveDescription`) to console

Usage
-----

Before you start make sure the `DEBUG` environment variable is set. CBIntrospect will not run without that set to prevent it being left in for production use.

Add the `CBIntrospect` class files to your project, add the QuartzCore framework if needed.  To start:

    [window makeKeyAndDisplay]
    
    // always call after makeKeyAndDisplay.
    #if TARGET_IPHONE_SIMULATOR
        [[CBIntrospect sharedIntrospector] start];
    #endif

The `#if` to target the simulator is not required but is a good idea to further prevent leaving it on in production code.

Once setup, simply push the space bar to invoke the introspect or then start clicking on views to get info.  You can also tap and drag around the interface.

Provide custom name of the view:

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        // provide custom names for use by the View Introspector desktop app and console output
    	[[CBIntrospect sharedIntrospector] setName:@"myActivityIndicator" forObject:self.activityIndicator accessedWithSelf:YES];
        [[CBIntrospect sharedIntrospector] setNameForViewController:self];
    }

Use `Interface Builder` to set the custom name of the view:

![IB Screenshot](https://github.com/cbess/CBIntrospector/raw/master/introspector-name.jpg)

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
        // must be set before any nib is called
        [CBIntrospect setIntrospectorKeyName:@"introspectorName"];
        ...

A small demo app is included to test it out.

Selected keyboard shortcuts
-----------------------------------------

* Start/Stop: `spacebar`
* Help: `?`
* Print properties and actions of selected view to console: `p`
* Print accessibility properties and actions of selected view to console: `a`
* Toggle all view outlines: `o`
* Toggle highlighting non-opaque views: `O`
* Nudge view left, right, up & down: `4 6 8 2` (use the numeric pad) or `← → ↑ ↓`
* Print out the selected views' new frame to console after nudge/resize: `0`
* Print selected views recursive description to console: `v`

Logging selected views properties
-------------------------------------------------

Pushing `p` will log out the available properties about the selected view. CBIntrospect will try to make sense of the values it can and show more useful info.  An example from a `UISegmentedControl`:

    ** UISegmentedControl:0x6d5eca0 : UIControl : UIView : UIResponder : NSObject ** 

      ** UIView properties **
        tag: 0
        frame: {{20, 66}, {207, 30}} | bounds: {{0, 0}, {207, 30}} | center: {123.5, 81}
        transform: [1, 0, 0, 1, 0, 0]
        autoresizingMask: UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin
        autoresizesSubviews: YES
        contentMode: UIViewContentModeScaleToFill | contentStretch: {{0, 0}, {1, 1}}
        backgroundColor: nil
        alpha: 1.00 | opaque: NO | hidden: NO | clipsToBounds: NO | clearsContextBeforeDrawing: YES
        userInteractionEnabled: YES | multipleTouchEnabled: NO
        gestureRecognizers: nil
        superview: <UIView: 0x6d4e820; frame = (0 20; 320 460); autoresize = W+H; layer = <CALayer: 0x6d4e8a0>>
        subviews: 2 views [<UISegment: 0x6d5f680>, <UISegment: 0x6d5ef90>]

      ** UISegmentedControl properties **
        removedSegment: nil
        segmentedControlStyle: 2
        numberOfSegments: 2
        apportionsSegmentWidthsByContent: NO
        selectedSegmentIndex: 0
        tintColor: nil

      ** Targets & Actions **

Customizing Key Bindings
--------------------------------------

Edit the file `DCIntrospectSettings.h` to change key bindings.  You might want to change the key bindings if your using a laptop/wireless keyboard for development.
Keep in mind you can use the `View Introspector` desktop app to interact with the UIView objects as well, and even call methods on the selected view using the `View Messenger` [(see screenshot)](https://github.com/cbess/ViewIntrospector/raw/master/cbintrospector-screenshot.jpg).

License
-----------

Made available under the MIT License.

CBIntrospector and DCIntrospect to CBIntrospect changes by Christopher Bess

DCIntrospect concept and implementation originally created by Patrick Richards domesticcatsoftware.com
