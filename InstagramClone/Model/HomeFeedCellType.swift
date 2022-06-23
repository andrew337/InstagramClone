//
//  HomeFeedCellType.swift
//  InstagramClone
//
//  Created by Admin on 4/7/22.
//

import Foundation

enum HomeFeedCellType {
    case poster(viewModel : PosterCollectionViewCellViewModel)
    case post(viewModel : PostCollectionViewCellViewModel)
    case actions(viewModel : PostActionsCollectionViewCellViewModel)
    case likeCount(viewModel : PostLikesCollectionViewCellViewModel)
    case caption(viewModel : PostCaptionCollectionViewCellModel)
    case timestamp(viewModel : PostDatatimeCollectionViewCellViewModel)
}
