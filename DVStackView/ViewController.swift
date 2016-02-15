//
//  ViewController.swift
//  DVStackView
//
//  Created by Monica Brinkman on 2016-01-10.
//  Copyright © 2016 Wonderlabs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet weak var stackView: DVStackView!
	@IBOutlet weak var viewRed: UIView!
	@IBOutlet weak var viewYellow: UIView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		let view : UIView = UIView(frame: CGRectMake(0, 0, 50, 50))
		view.backgroundColor = UIColor.redColor()

		let view2 : UIView = UIView(frame: CGRectMake(0, 0, 70, 70))
		view2.backgroundColor = UIColor.blueColor()

		let view3 : UIView = UIView(frame: CGRectMake(0, 0, 20, 20))
		view3.backgroundColor = UIColor.brownColor()

		let view4 : UIView = UIView(frame: CGRectMake(0, 0, 100, 100))
		view4.backgroundColor = UIColor.greenColor()

		let view5 : UIView = UIView(frame: CGRectMake(0, 0, 40, 40))
		view5.backgroundColor = UIColor.purpleColor()

		stackView.initHorizontalStackView([view, view2, view3, view4, view5]) //Testing a populated horizontal view
		//stackView.initHorizontalStackView(nil) //Testing an empty horizontal view

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func addViewButtonClicked(sender: UIButton) {
		let viewCustom : UIView = UIView(frame: CGRectMake(0, 0, 20, 20))
		viewCustom.backgroundColor = UIColor.blackColor()

		stackView.insertView(viewCustom, index: 2, animated: true) //If you change the index number, it will change the position of the added view
	}

	@IBAction func removeViewButtonClicked(sender: UIButton) {
		stackView.removeView(0, animated: true)
	}
}

