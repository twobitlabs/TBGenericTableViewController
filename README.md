GenericTableViewController is a UITableViewController subclass for declaratively defining table views. To use it, simply subclass GenericTableViewController and add table sections using:

    [self addSectionWithKey:@"settings" header:settingHeaderView footer:settingsFooterView];

...and add rows using:

    NSDictionary *versionCell = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"Select version", kLabelKey,
                                 [NSNumber numberWithInt:GenericTableCellStyleButton], kRowTypeKey,
                                 NSStringFromSelector(@selector(selectVersion:)), kSelectorKey,
                                 nil];
    [self addRowToSection:@"settings" row:versionCell];

It's fairly flexible as is, and easy to extend with additional configuration and behavior. More documentation on available cell types and options to come.

This idea was [originated by Matt Gallagher](http://cocoawithlove.com/2008/12/heterogeneous-cells-in.html") and <a href="http://furbo.org/2009/04/30/matt-gallagher-deserves-a-medal/">improved by Craig Hockenberry</a>. 
The original approach defined different row types, each with a class that defined its API. Matt later <a href="http://cocoawithlove.com/2010/12/uitableview-construction-drawing-and.html">later came up with a more generic approach</a> with a more flexible API.
I liked Matt's latter approach, but I find his API a bit confusing, so I took my own whack at it. I welcome your forks and feedback, and I'd love to know if you're using it in your project.
