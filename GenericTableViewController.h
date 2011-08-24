//
//  GenericTableViewController.h
//
//  Created by Christopher Pickslay on 2/8/11.
//

#import <UIKit/UIKit.h>

extern const NSString *kKeyKey;
extern const NSString *kHeaderKey;
extern const NSString *kHeaderViewKey;
extern const NSString *kHeaderHeightKey;
extern const NSString *kFooterKey;
extern const NSString *kFooterViewKey;
extern const NSString *kFooterHeightKey;
extern const NSString *kRowsKey;
extern const NSString *kControllerKey;
extern const NSString *kLabelKey;
extern const NSString *kIndentationLevelKey;
extern const NSString *kRowTypeKey;
extern const NSString *kRowSubviewsKey;
extern const NSString *kRowBackgroundColorKey;
extern const NSString *kRowBackgroundColorSelectedKey;
extern const NSString *kRowBackgroundColorDeselectedKey;
extern const NSString *kRowTextColorKey;
extern const NSString *kRowTextColorSelectedKey;
extern const NSString *kRowTextColorDeselectedKey;
extern const NSString *kRowBackgroundKey;
extern const NSString *kRowBackgroundSelectedKey;
extern const NSString *kRowBackgroundDeselectedKey;
extern const NSString *kRowDisclosureKey;
extern const NSString *kRowDisclosureSelectedKey;
extern const NSString *kRowDisclosureDeselectedKey;
extern const NSString *kShowHighlightOnSelectionKey;
extern const NSString *kSelectorKey;
extern const NSString *kSelectorArgumentKey;
extern const NSString *kTargetKey;
extern const NSString *kValueKey;

@interface GenericTableViewController : UITableViewController {
    NSMutableArray *data;
}

typedef enum {
    GenericTableCellStyleButton,      
    GenericTableCellStyleExclusiveSelect,      
    GenericTableCellStyleLink,      
    GenericTableCellStyleSwitch      
} GenericTableCellStyle;

@property(nonatomic,retain)NSMutableArray *data;

-(NSMutableDictionary *)addSectionWithKey:(NSString *)key header:(NSString *)header footer:(NSString *)footer;
-(void)removeSectionWithKey:(NSString *)key;
-(void)removeAllSections;
-(NSMutableDictionary *)sectionForKey:(NSString *)key;
-(void)addRowToSection:(NSString *)sectionKey row:(NSMutableDictionary *)dictionary;

@end
