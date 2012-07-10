//
//  NewsListCustomCell.m
//  TianYiBao
//
//  Created by lin xiaoyu on 12-5-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsListCustomCell.h"


@implementation NewsListCustomCell
@synthesize view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setView:(UIView *)aView {
	
	if (view)
		[view removeFromSuperview];
	view = aView;
	[self.view retain];
	[self.contentView addSubview:aView];
	
	[self layoutSubviews];
}

- (void)layoutSubviews {
	
	//float xOffset = 10.0;
	
	[super layoutSubviews];
   CGRect contentRect = [self.contentView bounds];
	/*
	CGRect viewFrame = CGRectMake(contentRect.size.width - self.view.bounds.size.width - xOffset,
								  round((contentRect.size.height - self.view.bounds.size.height) / 2.0),	
								  self.view.bounds.size.width,
								  self.view.bounds.size.height);
    */
  //  NSLog(@"contentRect.size.width"); NSLog(@"%f",contentRect.size.width );
  //  NSLog(@"contentRect.size.height"); NSLog(@"%f",contentRect.size.height );

   // NSLog(@"self.view.bounds.size.width"); NSLog(@"%f",self.view.bounds.size.width );

   // NSLog(@"self.view.bounds.size.height"); NSLog(@"%f",self.view.bounds.size.height );

    CGRect viewFrame = CGRectMake(0,
								  0,	
								  contentRect.size.width,
								  contentRect.size.height+22);

	view.frame = viewFrame;
}


- (void)dealloc
{
    [super dealloc];
}

@end
