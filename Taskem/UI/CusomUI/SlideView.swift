//
//  SlideView.swift
//  Taskem
//
//  Created by Wilson on 6/9/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

import Foundation

protocol SliderViewDelegate: class {
    func sliderViewNumberOfSlideds(_ view: SliderView) -> Int
    func sliderView(_ view: SliderView, slideAt: Int) -> UIView
    func sliderView(_ view: SliderView, didChangeSlide: Int)
}

class SliderView: UIScrollView, UIScrollViewDelegate {
    private (set) var currentSlide: Int = 0
    weak var sliderDelegate: SliderViewDelegate?

    func reloadSlides() {
        delegate = self
        removeSlides()
        addSlides()
        resizeSlides()
    }

    private func removeSlides() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    private func addSlides() {
        if let delegate = sliderDelegate {
            let slidesCount = delegate.sliderViewNumberOfSlideds(self)
            for index in 0..<slidesCount {
                let slide = delegate.sliderView(self, slideAt: index)
                slide.translatesAutoresizingMaskIntoConstraints = true
                addSubview(slide)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let slide = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        didSetCurrentSlide(slide)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if !isSetup {
            isPagingEnabled = true
            reloadSlides()
        } else {
            resizeSlides()
        }
    }

    private func resizeSlides() {
        for (index, slide) in subviews.enumerated() {
            resize(slide: slide, index: index)
        }
        resetContentSize()
    }

    private func resize(slide: UIView, index: Int) {
        slide.frame = CGRect(
            x: CGFloat(index) * frame.width,
            y: 0,
            width: frame.width,
            height: frame.height)
    }

    private func resetContentSize() {
        let slidesCount = sliderDelegate?.sliderViewNumberOfSlideds(self) ?? 0

        contentSize = CGSize(
            width: frame.width * CGFloat(slidesCount),
            height: frame.height
        )
    }

    private var isSetup: Bool {
        return delegate === self
    }

    func setCurrentSlide(_ slide: Int, animated: Bool) {
        var rect = frame
        rect.origin.x = rect.size.width * CGFloat(slide )
        rect.origin.y = 0
        scrollRectToVisible(rect, animated: animated)
        didSetCurrentSlide(slide)
    }

    func didSetCurrentSlide(_ slide: Int) {
        currentSlide = slide

        sliderDelegate?.sliderView(self, didChangeSlide: currentSlide)
    }

}
