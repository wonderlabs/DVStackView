//
//  DVStackView.swift
//  DVStackView
//
//  Created by Monica Brinkman on 2016-01-10.
//  Copyright © 2016 Wonderlabs. All rights reserved.
//

import Foundation
import UIKit



public class DVStackView: UIView {

	public enum Orientation {
		case Vertical
		case Horizontal
	}

	//outlets
	@IBOutlet private var masterView: UIView!
	@IBOutlet public var heightConstraint: NSLayoutConstraint!
	@IBOutlet public var widthConstraint: NSLayoutConstraint!

	//private variables
	private var masterViewOrientation: Orientation = Orientation.Horizontal
	private var numViews : Int = 0 //number of views in stack
	private var initialized = false
	private let lowPriority: Float = 200
	private let highPriority: Float = 900
	private var masterViewHeight: CGFloat = 0


	//API Functions
	public func initHorizontalStackView(subviews: [UIView]?) {
		if (initialized == true) {return}
		self.masterViewOrientation = Orientation.Horizontal

		//set width constraint to low priority so the other constraints overpower it
		self.widthConstraint.priority = lowPriority
		self.masterViewHeight = self.heightConstraint.constant


		if let subviews = subviews {
			if (!(subviews.count > 0)){
				self.heightConstraint.constant = 0
				self.numViews = 0
			} else {
				//populate the subviews and constrain them
				self.addAndConstrainViewsHorizontally(subviews)
			}
		} else {
			self.heightConstraint.constant = 0
			self.numViews = 0
		}

		initialized = true
	}

	public func initVerticalStackView(subviews: [UIView]?) {
		if (initialized == true) {return}
		self.masterViewOrientation = Orientation.Vertical

		//set height constraint to low priority so the other constraints overpower it
		self.heightConstraint.priority = lowPriority

		if let subviews = subviews {
			if (!(subviews.count > 0)){
				self.widthConstraint.constant = 0
				self.numViews = 0
			} else {
				//populate the subviews and constrain them
				self.addAndConstrainViewsVertically(subviews)
			}
		} else {
			self.heightConstraint.constant = 0
			self.numViews = 0
		}

		initialized = true
	}


	//Inserts the "view" at the specified "index" in the masterView
	public func insertView(view: UIView, index: Int, animated: Bool) {
		if (self.numViews > 0) { //can just use views array count instead of numViews
			if (self.numViews >= index) {
				//insert at index
				let views = self.subviews
				if (views.count > index) {
					//This means right view exists and must be parted from its left view
					let viewOnRight : UIView? = views[index]
					let leftIndex = index - 1
					var viewOnLeft: UIView?
					if (leftIndex >= 0) {
						 viewOnLeft = views[leftIndex]
					}

					if let viewOnRight = viewOnRight {
						//self.removeAllConstraintsOnView(viewOnRight)

						if (self.masterViewOrientation == Orientation.Horizontal) {

							self.insertSubview(view, atIndex: index)

							view.translatesAutoresizingMaskIntoConstraints = false

							self.constrainWidth(view)

							self.addTopConstraint(view, viewTop2: self)
							self.addBottomConstrant(view, viewBottom2: self)


							if let viewOnLeft = viewOnLeft {

								//find horizontal constraint between two views
								for cnst in self.constraints {
									if let viewLeft = cnst.firstItem as? UIView {
										if (viewLeft == viewOnLeft) {
											if let viewRight = cnst.secondItem as? UIView {
												if (viewRight == viewOnRight){
													//Both views match, delete Horizontal Constraint
													self.removeConstraint(cnst)
													break
												}
											}
										}
									}
								}

								self.addHorizontalConstraint(viewOnLeft, viewRight: view, viewParent: self)

							} else {

								//remove left constraint on viewOnRight
								//find horizontal constraint between right and super view
								for cnst in self.constraints {
									if let viewRight = cnst.firstItem as? UIView {
										if (viewRight == viewOnRight) {
											if let viewLeft = cnst.secondItem as? UIView {
												if (viewLeft == self){
													if (cnst.firstAttribute == NSLayoutAttribute.Leading) {
														//Both views match, delete Left Constraint
														self.removeConstraint(cnst)
														break
													}
												}
											}
										}
									}
								}

								self.addLeftConstrant(view, viewLeft2: self)
							}
							self.addHorizontalConstraint(view, viewRight: viewOnRight, viewParent: self)
						} else if (self.masterViewOrientation == Orientation.Vertical) {

						}

					}


				} else {
					//just append view to last index
					let leftIndex = index - 1
					var viewOnLeft: UIView?
					if (leftIndex >= 0) {
						viewOnLeft = views[leftIndex]
					}

						//self.removeAllConstraintsOnView(viewOnRight)

						if (self.masterViewOrientation == Orientation.Horizontal) {

							self.insertSubview(view, atIndex: index)

							view.translatesAutoresizingMaskIntoConstraints = false

							self.constrainWidth(view)

							self.addTopConstraint(view, viewTop2: self)
							self.addBottomConstrant(view, viewBottom2: self)


							if let viewOnLeft = viewOnLeft {

								//find right constraint between viewOnLeft and super view
								for cnst in self.constraints {
									if let viewLeft = cnst.firstItem as? UIView {
										if (viewLeft == viewOnLeft) {
											if let viewRight = cnst.secondItem as? UIView {
												if (viewRight == self){
													if (cnst.firstAttribute == NSLayoutAttribute.Trailing) {
														//Both views match, delete Left Constraint
														self.removeConstraint(cnst)
														break
													}
												}
											}
										}
									}
								}
								self.addRightConstrant(view, viewRight2: self)
								self.addHorizontalConstraint(viewOnLeft, viewRight: view, viewParent: self)
							} else {
								//no views in superview.. add first one.. This case should never happen
								self.addFirstView(view)
							}

							
						} else if (self.masterViewOrientation == Orientation.Vertical) {
							
						}

				}
			} else {
				//return index out of range
			}


		} else {
			if(index == 0) {
				//Insert view at index 0
				//no views in superview.. add first one.
				self.addFirstView(view)

			} else  {
				//Return error can not insert at index because index is out of range
			}
		}

		self.numViews = subviews.count;

		//TODO:Animation not yet supported
//		UIView.animateWithDuration(2, animations: {
			self.layoutIfNeeded()
//			})

	}

	private func addFirstView(view : UIView) {
		self.addSubview(view)

		view.translatesAutoresizingMaskIntoConstraints = false
		self.translatesAutoresizingMaskIntoConstraints = false

		self.constrainWidth(view)
		self.addLeftConstrant(view, viewLeft2: self)
		self.addRightConstrant(view, viewRight2: self)
		self.setEqualHeights(view, view2: self)
		self.setCenterY(view, view2: self)

		self.heightConstraint.constant = self.masterViewHeight
	}


	//Removes the view located at "index" from the masterView
	public func removeView(index: Int, animated: Bool) {
		//check if first view
		if (index < 0) {
			// return error index out of range
		}

		let views = self.subviews
		if (views.count == 0) {
			//return nothing to delete
		}

		if (views.count > 0 && index >= 0) {
			if((views.count == (index + 1)) && (index == 0)) {
				// 1) index is last view and first view == only one view in views

				//self.removeAllConstraintsOnView(viewOnRight)

				if (self.masterViewOrientation == Orientation.Horizontal) {
					let deleteView : UIView? = views[index]
					if let deleteView = deleteView {
						self.removeAllConstraintsOnView(deleteView)
						deleteView.removeFromSuperview()
					}
					self.heightConstraint.constant = 0
				} else if (self.masterViewOrientation == Orientation.Vertical) {
					//setup vertical
				}
			} else if ((views.count == (index + 1)) && (index > 0)) {
				// 2) index is last view, but not first view

				let viewOnRight : UIView? = views[index]
				let leftIndex = index - 1
				var viewOnLeft: UIView?
				if (leftIndex >= 0) {
					viewOnLeft = views[leftIndex]
				}

				if let viewOnRight = viewOnRight {
					self.removeAllConstraintsOnView(viewOnRight)

					if (self.masterViewOrientation == Orientation.Horizontal) {

						viewOnRight.removeFromSuperview()

						if let viewOnLeft = viewOnLeft {
							self.addRightConstrant(viewOnLeft, viewRight2: self)
						} else {
							//should not be possible
						}
					} else if (self.masterViewOrientation == Orientation.Vertical) {
						//setup vertical
					}
				}


			} else if ((views.count > (index + 1)) && (index == 0)) {
				// 3) index is first view but not last view
				let rightIndex = index + 1
				let viewOnRight : UIView? = views[rightIndex]
				let viewOnLeft: UIView? = views[index]

				if let viewOnLeft = viewOnLeft {
					if (self.masterViewOrientation == Orientation.Horizontal) {

						self.removeAllConstraintsOnView(viewOnLeft)
						viewOnLeft.removeFromSuperview()

						if let viewOnRight = viewOnRight {
							self.addLeftConstrant(viewOnRight, viewLeft2: self)
						} else {
						 //should not be possible
						}
					} else if (self.masterViewOrientation == Orientation.Vertical) {
						//setup vertical
					}

				} else {
					//should not be possible
				}

			} else if ((views.count > (index + 1)) && (index > 0)){
				// 4) index is not first view, and not last view, so there is a view on right and on left

				let rightIndex = index + 1
				let viewOnRight : UIView? = views[rightIndex]
				let currentView: UIView? = views[index]
				let leftIndex = index - 1
				let viewOnLeft: UIView? = views[leftIndex]

				if let currentView = currentView {
					if (self.masterViewOrientation == Orientation.Horizontal) {

						self.removeAllConstraintsOnView(currentView)
						currentView.removeFromSuperview()

						if let viewOnRight = viewOnRight {

							if let viewOnLeft = viewOnLeft {
								self.addHorizontalConstraint(viewOnLeft, viewRight: viewOnRight, viewParent: self)
							} else {
								// should not be possible
							}
						} else {
						 //should not be possible
						}
					} else if (self.masterViewOrientation == Orientation.Vertical) {
						//setup vertical
					}

				} else {
					//should not be possible
				}


			} else {
				//impossible case
			}
			
		} else {
			//return cannot delete
		}

		self.numViews = self.subviews.count
		self.layoutIfNeeded()
	}


	//Helper Functions
	private func addAndConstrainViewsHorizontally(subviews: [UIView]) { //TODO: Can shrink all this to one for loop

		if (subviews.count == 1) {
			let view = subviews[0]
			self.addFirstView(view)
		} else if (subviews.count == 2) {
			let viewLeft = subviews[0]
			self.addSubview(viewLeft)

			let viewRight = subviews[1]
			self.addSubview(viewRight)

			viewLeft.translatesAutoresizingMaskIntoConstraints = false
			viewRight.translatesAutoresizingMaskIntoConstraints = false
			self.translatesAutoresizingMaskIntoConstraints = false

			self.constrainWidth(viewLeft)
			self.constrainWidth(viewRight)

			self.addTopConstraint(viewLeft, viewTop2: self)
			self.addTopConstraint(viewRight, viewTop2: self)
			self.addBottomConstrant(viewLeft, viewBottom2: self)
			self.addBottomConstrant(viewRight, viewBottom2: self)

			self.addLeftConstrant(viewLeft, viewLeft2: self)
			self.addRightConstrant(viewRight, viewRight2: self)

			self.addHorizontalConstraint(viewLeft, viewRight: viewRight, viewParent: self)

		} else {
			let views : [UIView] = subviews //TODO: may not need views array, just use subviews directly

			for var index = 0; index < views.count; index++ {
				if (index == 0) {
					let viewLeft = views[0]
					self.addSubview(viewLeft)

					viewLeft.translatesAutoresizingMaskIntoConstraints = false
					self.translatesAutoresizingMaskIntoConstraints = false

					self.constrainWidth(viewLeft)
					self.addTopConstraint(viewLeft, viewTop2: self)
					self.addBottomConstrant(viewLeft, viewBottom2: self)
					self.addLeftConstrant(viewLeft, viewLeft2: self)
					continue
				}

				if (index == (views.count - 1)) {
					let viewRight = views[index]
					self.addSubview(viewRight)

					viewRight.translatesAutoresizingMaskIntoConstraints = false

					self.constrainWidth(viewRight)
					self.addTopConstraint(viewRight, viewTop2: self)
					self.addBottomConstrant(viewRight, viewBottom2: self)
					self.addRightConstrant(viewRight, viewRight2: self)

					let viewBeforeRight = views[index - 1]
					if (self.subviews.contains(viewBeforeRight)) {
						self.addHorizontalConstraint(viewBeforeRight, viewRight: viewRight, viewParent: self)
					} else {
						NSLog("ERROR View is not in masterView")
					}
					continue
				}


				let viewOnRight = views[index]
				let viewOnLeft = views[index-1]
				self.addSubview(viewOnRight)

				viewOnRight.translatesAutoresizingMaskIntoConstraints = false

				self.constrainWidth(viewOnRight)

				self.addTopConstraint(viewOnRight, viewTop2: self)
				self.addBottomConstrant(viewOnRight, viewBottom2: self)

				if (self.subviews.contains(viewOnLeft)) {
					self.addHorizontalConstraint(viewOnLeft, viewRight: viewOnRight, viewParent: self)
				} else {
					NSLog("ERROR View is not in masterView")
				}
			}
		}

		self.numViews = subviews.count;
	}

	private func addAndConstrainViewsVertically(subviews: [UIView]) {

	}
	



	//Constraint Helper Functions
	private func addTopConstraint(viewTop1 : UIView, viewTop2: UIView) {
		let topConstraint = NSLayoutConstraint(item: viewTop1, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: viewTop2, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
		viewTop2.addConstraint(topConstraint)
	}

	private func addBottomConstrant(viewBottom1: UIView, viewBottom2: UIView) {
		let bottomConstraint = NSLayoutConstraint(item: viewBottom1, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: viewBottom2, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
		viewBottom2.addConstraint(bottomConstraint)
	}

	private func addLeftConstrant(viewLeft1: UIView, viewLeft2: UIView) {
		let leftConstraint = NSLayoutConstraint(item: viewLeft1, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: viewLeft2, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
		viewLeft2.addConstraint(leftConstraint)
	}

	private func addRightConstrant(viewRight1: UIView, viewRight2: UIView) {
		let rightConstraint = NSLayoutConstraint(item: viewRight1, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: viewRight2, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0)
		viewRight2.addConstraint(rightConstraint)
	}

	private func addVerticalConstraint(viewBottom: UIView, viewTop: UIView) {
		let verticalConstraint = NSLayoutConstraint(item: viewBottom, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: viewTop, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
		viewTop.addConstraint(verticalConstraint)
	}

	private func addHorizontalConstraint(viewLeft: UIView, viewRight: UIView, viewParent: UIView) {
		let horizontalConstraint = NSLayoutConstraint(item: viewLeft, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: viewRight, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0)
		self.addConstraint(horizontalConstraint)
	}

	private func constrainWidth(view: UIView) {
		let width = view.frame.size.width
		let widthCnst = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: width)
		view.addConstraint(widthCnst)
	}

	private func setEqualHeights(view1: UIView, view2: UIView) {
		let equalHeightCnst = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
		view2.addConstraint(equalHeightCnst)
	}
	private func setCenterY(view1: UIView, view2: UIView) {
		let centerYCnst = NSLayoutConstraint(item: view1, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view2, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
		view2.addConstraint(centerYCnst)
	}

	private func removeAllConstraintsOnView(view: UIView) {
		view.removeConstraints(view.constraints)
	}









}