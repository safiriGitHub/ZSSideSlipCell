//
//  FavoriteLinkCell.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/29.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "FavoriteLinkCell.h"
#import "FavoriteModel.h"

@interface FavoriteLinkCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation FavoriteLinkCell
{
    CGFloat _authorLabelWidth;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_bgView];
        
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        [_bgView addSubview:_iconImageView];
        
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 2;
        [_bgView addSubview:_titleLabel];
        
        _authorLabel = [UILabel new];
        _authorLabel.textColor = [UIColor lightGrayColor];
        _authorLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_authorLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [_bgView addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgView.frame = CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame)-20, CGRectGetHeight(self.contentView.frame)-10);
    
    _iconImageView.frame = CGRectMake(15, 15, 55, 55);
    CGFloat title_x = CGRectGetMaxX(_iconImageView.frame)+8;
    _titleLabel.frame = CGRectMake(title_x, 16, (_bgView.frame.size.width - title_x - 15), 50);
    
    _authorLabel.frame = CGRectMake(15, CGRectGetMaxY(_iconImageView.frame)+5, _authorLabelWidth, 22);
    _timeLabel.frame = CGRectMake(CGRectGetMaxX(_authorLabel.frame)+8, CGRectGetMinY(_authorLabel.frame), 80, 22);
}

- (void)bindModel:(id)model {
    if ([model isKindOfClass:FavoriteModel.class]) {
        
        FavoriteModel *f = (FavoriteModel *)model;
        
        _iconImageView.image = [UIImage imageNamed:f.iconName];
        
        _titleLabel.text = f.title;
        
        _authorLabel.text = f.author;
        _authorLabelWidth = [f.author boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size.width;
        
        _timeLabel.text = f.time;
    }
}


static NSString *const cellIdentifier = @"FavoriteLinkCell";
+ (void)registerCellWithTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:cellIdentifier];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    FavoriteLinkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell设置
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
