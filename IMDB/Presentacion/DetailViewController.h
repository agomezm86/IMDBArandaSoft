//
//  DetailViewController.h
//  IMDB
//
//  Created by Alejandro Gómez on 1/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailBL.h"

// <summary>
// Definición de la interfaz de la clase DetailViewController
// </summary>
@interface DetailViewController : UIViewController <DetailBLDelegate>

// <summary>
// ID de la serie
// </summary>
@property (nonatomic, strong) NSString *serieId;

@end
