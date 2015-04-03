//
//  ImageCell.h
//  IMDB
//
//  Created by Alejandro Gómez on 2/04/15.
//  Copyright (c) 2015 Alejandro Gómez. All rights reserved.
//

#import <UIKit/UIKit.h>

// <summary>
// Definición de la interfaz de la clase ImageCell
// </summary>
@interface ImageCell : UICollectionViewCell

// <summary>
// Imagen de la serie
// </summary>
@property (weak) IBOutlet UIImageView *imageView;

// <summary>
// Nombre de la serie
// </summary>
@property (weak) IBOutlet UILabel *label;

@end
