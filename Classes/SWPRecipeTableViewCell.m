/*
     File: SWPRecipeTableViewCell.m 
 Abstract: A table view cell that displays information about a Recipe.  It uses individual subviews of its content view to show the name, picture, description, and preparation time for each recipe.  If the table view switches to editing mode, the cell reformats itself to move the preparation time off-screen, and resizes the name and description fields accordingly.
  
  Version: 2.0
  
 */

#import "SWPRecipeTableViewCell.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface SWPRecipeTableViewCell (SubviewFrames)
- (CGRect)_imageViewFrame;
- (CGRect)_nameLabelFrame;
- (CGRect)_descriptionLabelFrame;
- (CGRect)_prepTimeLabelFrame;
@end


#pragma mark -
#pragma mark RecipeTableViewCell implementation

@implementation SWPRecipeTableViewCell

@synthesize recipe = _recipe, nameLabel = _nameLabel, overviewLabel = _overviewLabel, prepTimeLabel = _prepTimeLabel;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        _overviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_overviewLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_overviewLabel setTextColor:[UIColor darkGrayColor]];
        [_overviewLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_overviewLabel];

        _prepTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _prepTimeLabel.textAlignment = UITextAlignmentRight;
        [_prepTimeLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_prepTimeLabel setTextColor:[UIColor blackColor]];
        [_prepTimeLabel setHighlightedTextColor:[UIColor whiteColor]];
		_prepTimeLabel.minimumFontSize = 7.0;
		_prepTimeLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self.contentView addSubview:_prepTimeLabel];

        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_nameLabel];
    }

    return self;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_recipe release], _recipe = nil;
    [_nameLabel release], _nameLabel = nil;
    [_overviewLabel release], _overviewLabel = nil;
    [_prepTimeLabel release], _prepTimeLabel = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [self.imageView setFrame:[self _imageViewFrame]];
    [self.nameLabel setFrame:[self _nameLabelFrame]];
    [self.overviewLabel setFrame:[self _descriptionLabelFrame]];
    [self.prepTimeLabel setFrame:[self _prepTimeLabelFrame]];
    if (self.editing) {
        self.prepTimeLabel.alpha = 0.0;
    } else {
        self.prepTimeLabel.alpha = 1.0;
    }
}

#define IMAGE_SIZE          42.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    8.0
#define TEXT_RIGHT_MARGIN   5.0
#define PREP_TIME_WIDTH     80.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */
- (CGRect)_imageViewFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
	else {
        return CGRectMake(0.0, 0.0, IMAGE_SIZE, IMAGE_SIZE);
    }
}

- (CGRect)_nameLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 4.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_RIGHT_MARGIN * 2 - PREP_TIME_WIDTH, 16.0);
    }
}

- (CGRect)_descriptionLabelFrame {
    if (self.editing) {
        return CGRectMake(IMAGE_SIZE + EDITING_INSET + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - EDITING_INSET - TEXT_LEFT_MARGIN, 16.0);
    }
	else {
        return CGRectMake(IMAGE_SIZE + TEXT_LEFT_MARGIN, 22.0, self.contentView.bounds.size.width - IMAGE_SIZE - TEXT_LEFT_MARGIN, 16.0);
    }
}

- (CGRect)_prepTimeLabelFrame {
    CGRect contentViewBounds = self.contentView.bounds;
    return CGRectMake(contentViewBounds.size.width - PREP_TIME_WIDTH - TEXT_RIGHT_MARGIN, 4.0, PREP_TIME_WIDTH, 16.0);
}

#pragma mark -
#pragma mark Recipe set accessor

- (void)setRecipe:(SWPRecipe *)newRecipe {
    if (newRecipe != _recipe) {
        [_recipe release];
        _recipe = [newRecipe retain];
	}
	self.imageView.image = self.recipe.thumbnailImage;
	self.nameLabel.text = self.recipe.name;
	self.overviewLabel.text = self.recipe.overview;
	self.prepTimeLabel.text = self.recipe.prepTime;
}

@end
