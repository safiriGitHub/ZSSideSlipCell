//
//  ChatCell.m
//  ZSSideSlipCell_Master
//
//  Created by safiri on 2019/4/28.
//  Copyright © 2019 safiri. All rights reserved.
//

#import "ChatCell.h"
#import "ChatModel.h"

@interface ChatCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *lastMessageLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.cornerRadius = 6;
        _iconImageView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        _iconImageView.layer.borderWidth = 0.5;
        [self.contentView addSubview:_iconImageView];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) + 10, 10, 200, 25)];
        [self.contentView addSubview:_userNameLabel];
        
        _lastMessageLabel = [UILabel new];
        _lastMessageLabel.textColor = [UIColor grayColor];
        _lastMessageLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_lastMessageLabel];
        
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _lastMessageLabel.frame = CGRectMake(CGRectGetMinX(_userNameLabel.frame), CGRectGetMaxY(_userNameLabel.frame), screenWidth - CGRectGetMinX(_userNameLabel.frame) - 10, 25);
    _timeLabel.frame = CGRectMake(screenWidth - 200 - 10, 10, 200, 25);
}

- (void)bindModel:(id)model {
    if ([model isKindOfClass:ChatModel.class]) {
        
        ChatModel *m = (ChatModel *)model;
        
        _iconImageView.image = [UIImage imageNamed:m.iconName];
        
        _userNameLabel.text = m.userName;
        
        _lastMessageLabel.text = m.lastMessage;
        
        _timeLabel.text = m.timeString;
    }
}

static NSString *const cellIdentifier = @"ChatCell";
+ (void)registerCellWithTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:cellIdentifier];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView forIndexPath:(NSIndexPath *)indexPath{
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell设置
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
