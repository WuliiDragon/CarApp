//
//  myTableViewCell.m
//  CarApp
//
//  Created by 管理员 on 2016/11/23.
//  Copyright © 2016年 dragon. All rights reserved.
//

#import "HBCarStoreCell.h"
#import "UIImageView+WebCache.h"
#import "HBAuxiliary.h"
#import <MapKit/MapKit.h>
@interface HBCarStoreCell()
@property (strong, nonatomic) IBOutlet UIImageView *mapImg;

@property (strong, nonatomic) IBOutlet UIImageView *phoneImage;

@end


@implementation HBCarStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"HBLog:%@",self);
    [_mapImg setUserInteractionEnabled:YES];
    [_mapImg addTargets:self actions:@selector(mapClick)];
    [_phoneImage setUserInteractionEnabled:YES];
    [_phoneImage addTargets:self actions:@selector(phoneClick)];
    
}

-(void)mapClick{
    [HBAuxiliary turnToMapWithLatitude:_models.latitude ToLongitude:_models.longitude addressName:_models.baddress];
}

-(void)phoneClick{
    if([_models.bphone isEqualToString:@""]){
        return;
    }
    [self.superview.superview addSubview:  [HBAuxiliary turnTOPhoneWithNumBer:_models.bphone]];
}

- (void)setModels:(HBStoreCarModel *)modeldata{
    _models = modeldata;
    self.bname.text = modeldata.bname;
   
    self.baddress.text = modeldata.baddress;
    self.majorbusiness.text = [NSString stringWithFormat:@"主营车型：%@", modeldata.majorbusiness ];
    self.distance.text = [HBAuxiliary distance:modeldata.distance];

    
   // [self.bphone setTitle:modeldata.bphone forState:UIControlStateNormal];
    
    
    
    if(modeldata.isActivity!=nil){
        if([modeldata.isActivity isEqualToString:@"1"]){
            self.title2.text = modeldata.title2;
        }
        if([modeldata.isActivity isEqualToString:@"0"]){
            [_title2 setHidden:YES];
            [_hang setHidden:YES];
            
        }
    }
    self.title1.text = modeldata.title1;
    self.title2.text = modeldata.title2;
    

    NSString *str = mainUrl;
    NSString *urlStr = [str stringByAppendingFormat:@"%@",modeldata.bshowImage];
    [self.bimage sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"xx"] options:SDWebImageRefreshCached];
}

@end
