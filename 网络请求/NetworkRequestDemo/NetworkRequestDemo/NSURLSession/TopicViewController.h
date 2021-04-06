//
//  TopicViewController.h
//  NetworkRequestDemo
//
//  Created by 谢佳培 on 2020/10/21.
//  Copyright © 2020 xiejiapei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopicCell : UITableViewCell

@property (nonatomic, strong) UIImageView *memberAvatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nodeNameLabel;
@property (nonatomic, strong) UILabel *memberNameLabel;
@property (nonatomic, strong) UILabel *replyCountLabel;

@end

@interface NodeModel : NSObject

@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *avatar_normal;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger topics;
@property (nonatomic, copy) NSString *footer;
@property (nonatomic, copy) NSString *header;
@property (nonatomic, copy) NSString *title_alternative;
@property (nonatomic, copy) NSString *avatar_mini;
@property (nonatomic, assign) NSInteger stars;
@property (nonatomic, assign) BOOL root;
@property (nonatomic, assign) NSInteger nodeID;
@property (nonatomic, copy) NSString *parent_node_name;

@end

@interface MemberModel : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *github;
@property (nonatomic, copy) NSString *psn;
@property (nonatomic, copy) NSString *avatar_normal;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *tagline;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, assign) NSTimeInterval created;
@property (nonatomic, copy) NSString *avatar_large;
@property (nonatomic, copy) NSString *avatar_mini;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *btc;
@property (nonatomic, assign) NSInteger memberID;

@end

@interface TopicModel : NSObject

@property (nonatomic, strong) NodeModel *node;
@property (nonatomic, strong) MemberModel *member;

@property (nonatomic, copy) NSString *last_reply_by;
@property (nonatomic, assign) NSTimeInterval last_touched;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSTimeInterval created;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *content_rendered;
@property (nonatomic, assign) NSTimeInterval last_modified;
@property (nonatomic, assign) NSInteger replies;
@property (nonatomic, assign) NSInteger topicID;

@end

@interface TopicViewController : UIViewController

@property (nonatomic, strong) NSString *topicURLString;// URL

@end

NS_ASSUME_NONNULL_END
