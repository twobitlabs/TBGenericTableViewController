//
//  GenericTableViewController.m
//
//  Created by Christopher Pickslay on 2/8/11.
//

#import "GenericTableViewController.h"

@implementation GenericTableViewController

@synthesize data;

const NSString *kKeyKey = @"key";
const NSString *kHeaderKey = @"header";
const NSString *kHeaderViewKey = @"headerView";
const NSString *kHeaderHeightKey = @"headerHeight";
const NSString *kFooterKey = @"footer";
const NSString *kFooterViewKey = @"footerView";
const NSString *kFooterHeightKey = @"footerHeight";
const NSString *kRowsKey = @"rows";
const NSString *kControllerKey = @"controller";
const NSString *kIndentationLevelKey = @"indendationLevel";
const NSString *kLabelKey = @"label";
const NSString *kRowTypeKey = @"rowType";
const NSString *kRowSubviewsKey = @"rowSubviews";
const NSString *kRowBackgroundColorKey = @"rowBackgroundColor";
const NSString *kRowBackgroundColorSelectedKey = @"rowBackgroundColorSelected";
const NSString *kRowBackgroundColorDeselectedKey = @"rowBackgroundColorDeselected";
const NSString *kRowTextColorKey = @"rowTextColor";
const NSString *kRowTextColorSelectedKey = @"rowTextColorSelected";
const NSString *kRowTextColorDeselectedKey = @"rowTextColorDeselected";
const NSString *kRowBackgroundKey = @"rowBackground";
const NSString *kRowBackgroundSelectedKey = @"rowBackgroundSelected";
const NSString *kRowBackgroundDeselectedKey = @"rowBackgroundDeselected";
const NSString *kRowDisclosureKey = @"rowDisclosure";
const NSString *kRowDisclosureSelectedKey = @"rowDisclosureSelected";
const NSString *kRowDisclosureDeselectedKey = @"rowDisclosureDeselected";
const NSString *kShowHighlightOnSelectionKey = @"showHighlightOnSelection";
const NSString *kSelectorKey = @"selector";
const NSString *kSelectorArgumentKey = @"argument";
const NSString *kTargetKey = @"target";
const NSString *kValueKey = @"value";


-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self setData:[NSMutableArray array]];
    }
    return self;
}


-(NSMutableDictionary *)addSectionWithKey:(NSString *)key header:(NSString *)header footer:(NSString *)footer {
    NSMutableDictionary *section = [NSMutableDictionary dictionaryWithObject:[NSMutableArray array] forKey:kRowsKey];
    if (key) [section setObject:key forKey:kKeyKey];
    if (header) [section setObject:header forKey:kHeaderKey];
    if (footer) [section setObject:footer forKey:kFooterKey];
    
    [[self data] addObject:section];
    return section;
}

-(void)removeSectionWithKey:(NSString *)key {
    for (NSMutableDictionary *section in [self data]) {
        if ([key isEqualToString:[section objectForKey:kKeyKey]]) {
            [[self data] removeObject:section];
            break;
        }
    }    
}

-(void)removeAllSections {
    [self setData:[NSMutableArray array]];
}

-(NSMutableDictionary *)sectionForKey:(NSString *)key {
    for (NSMutableDictionary *section in [self data]) {
        if ([key isEqualToString:[section objectForKey:kKeyKey]]) {
            return section;
        }
    }
    return nil;
}

-(void)addRowToSection:(NSString *)sectionKey row:(NSMutableDictionary *)dictionary {
    for (NSMutableDictionary *section in [self data]) {
        if ([sectionKey isEqualToString:[section objectForKey:kKeyKey]]) {
            NSMutableArray *rows = [section objectForKey:kRowsKey];
            [rows addObject:dictionary];
            break;
        }
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [data count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[data objectAtIndex:section] objectForKey:kRowsKey] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *row = [[[data objectAtIndex:indexPath.section] objectForKey:kRowsKey] objectAtIndex:indexPath.row];
    GenericTableCellStyle rowType = [[row objectForKey:kRowTypeKey] intValue];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@%d", [[data objectAtIndex:indexPath.section] objectForKey:kKeyKey], rowType];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    [[cell textLabel] setText:[row objectForKey:kLabelKey]];

    if ([row objectForKey:kIndentationLevelKey]) {
        [cell setIndentationLevel:[[row objectForKey:kIndentationLevelKey] intValue]];
    }
    
    // show highlight on selection
    if ([row objectForKey:kShowHighlightOnSelectionKey]) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // text color
    if ([row objectForKey:kRowTextColorKey]) {
        [[cell textLabel] setTextColor:[row objectForKey:kRowTextColorKey]];
    } 
    
    // background color
    if ([row objectForKey:kRowBackgroundColorKey]) {
        [cell setBackgroundColor:[row objectForKey:kRowBackgroundColorKey]];
    } 
    
    UISwitch *toggle;
    switch (rowType) {
        case GenericTableCellStyleLink:
        case GenericTableCellStyleButton:
            if ([row objectForKey:kRowBackgroundSelectedKey]) {
                UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowBackgroundSelectedKey]]];
                [cell setSelectedBackgroundView:backgroundView];
                [backgroundView release];
            }
            if ([row objectForKey:kRowTextColorSelectedKey]) {
                [[cell textLabel] setHighlightedTextColor:[row objectForKey:kRowTextColorSelectedKey]];
            } 
            break;
        case GenericTableCellStyleExclusiveSelect:
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];            
            break;
        case GenericTableCellStyleSwitch:
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            toggle = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
            [toggle setOn:[[row objectForKey:kValueKey] boolValue] animated:NO];
            [toggle addTarget:[row objectForKey:kTargetKey] action:NSSelectorFromString([row objectForKey:kSelectorKey]) forControlEvents:UIControlEventValueChanged];
            [cell setAccessoryView:toggle];
            [toggle release];
            break;
    }

    // background
    if ([row objectForKey:kRowBackgroundKey]) {
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowBackgroundKey]]];
        [cell setBackgroundView:backgroundView];
        [backgroundView release];
    }
    
    // disclosure button
    if ([row objectForKey:kRowDisclosureKey]) {
        [cell setAccessoryView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowDisclosureKey]]] autorelease]];
    }
    
    if ([row objectForKey:kRowSubviewsKey]) {
        for (UIView *subview in [row objectForKey:kRowSubviewsKey]) {
            [cell addSubview:subview];
        }
    }
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:kHeaderKey];    
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:kFooterKey];    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:kHeaderViewKey];    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[data objectAtIndex:section] objectForKey:kFooterViewKey];    
}

#pragma mark -
#pragma mark UITableViewDelegate

// necesssary for 3.2
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *rowsInSection = [[data objectAtIndex:indexPath.section] objectForKey:kRowsKey];
    NSDictionary *row = [rowsInSection objectAtIndex:indexPath.row];
    GenericTableCellStyle rowType = [[row objectForKey:kRowTypeKey] intValue];

    id controller;
    SEL selector;
    id target;
    switch (rowType) {
        case GenericTableCellStyleLink:
            controller = [row objectForKey:kControllerKey];
            [[self navigationController] pushViewController:controller animated:YES];
            break;
        case GenericTableCellStyleButton:
            selector = NSSelectorFromString([row objectForKey:kSelectorKey]);
            target = [row objectForKey:kTargetKey];
            if ([row objectForKey:kSelectorArgumentKey]) {
                [target performSelector:selector withObject:[row objectForKey:kSelectorArgumentKey]]; 
            } else {
                [target performSelector:selector];
            }
            break;
        case GenericTableCellStyleExclusiveSelect:
            // deselect others
            for (int i = 0; i < [rowsInSection count]; i++) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]];
                if (i != indexPath.row) {
                    // background image
                    if ([row objectForKey:kRowBackgroundDeselectedKey]) {
                        [cell setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowBackgroundDeselectedKey]]] autorelease]];
                    }
                    // disclosure button
                    if ([row objectForKey:kRowDisclosureDeselectedKey]) {
                        [cell setAccessoryView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowDisclosureDeselectedKey]]] autorelease]];
                    }
                    // text color
                    if ([row objectForKey:kRowTextColorDeselectedKey]) {
                        [[cell textLabel] setTextColor:[row objectForKey:kRowTextColorDeselectedKey]];
                    }                     
                    // background color
                    if ([row objectForKey:kRowBackgroundColorKey]) {
                        [cell setBackgroundColor:[row objectForKey:kRowBackgroundColorDeselectedKey]];
                    } 
                } else {
                    // background image
                    if ([row objectForKey:kRowBackgroundSelectedKey]) {
                        [cell setBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowBackgroundSelectedKey]]] autorelease]];
                    }
                    // disclosure button
                    if ([row objectForKey:kRowDisclosureSelectedKey]) {
                        [cell setAccessoryView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:[row objectForKey:kRowDisclosureSelectedKey]]] autorelease]];
                    }
                    // text color
                    if ([row objectForKey:kRowTextColorSelectedKey]) {
                        [[cell textLabel] setTextColor:[row objectForKey:kRowTextColorSelectedKey]];
                    }                                         
                    // background color
                    if ([row objectForKey:kRowBackgroundColorKey]) {
                        [cell setBackgroundColor:[row objectForKey:kRowBackgroundColorSelectedKey]];
                    } 
                }
            }
            
            selector = NSSelectorFromString([row objectForKey:kSelectorKey]);
            target = [row objectForKey:kTargetKey];
            if (target && [target respondsToSelector:selector]) {
                if ([row objectForKey:kSelectorArgumentKey]) {
                    [target performSelector:selector withObject:[row objectForKey:kSelectorArgumentKey]]; 
                } else {
                    [target performSelector:selector];
                }
            }
            break;
        case GenericTableCellStyleSwitch:
            break;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    UIView *header = [[data objectAtIndex:section] objectForKey:kHeaderViewKey];    
    if (header) {
        return HEIGHT(header);
    }
    return [[[data objectAtIndex:section] objectForKey:kHeaderHeightKey] floatValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    UIView *footer = [[data objectAtIndex:section] objectForKey:kFooterViewKey];    
    if (footer) {
        return HEIGHT(footer);
    }
    return [[[data objectAtIndex:section] objectForKey:kFooterHeightKey] floatValue];
}

@end
