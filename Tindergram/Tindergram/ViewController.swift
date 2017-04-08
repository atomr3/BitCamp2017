//
//  ViewController.swift
//  Tindergram
//
//  Created by thomas on 3/31/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit

let pageController = ViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

class ViewController: UIPageViewController {
  
  let cardsVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardsNavController") 
  let profileVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileNavController") 
  let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MatchesNavController") 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.white
    dataSource = self
    setViewControllers([cardsVC], direction: .forward, animated: true, completion: nil)
  }
  
  func goToNextVC() {
    let nextVC = pageViewController(self, viewControllerAfterViewController: viewControllers![0] as! UIViewController)!
    setViewControllers([nextVC], direction: .Forward, animated: true, completion: nil)
  }
  
  func goToPreviousVC() {
    let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers![0] as! UIViewController)!
    setViewControllers([previousVC], direction: .Reverse, animated: true, completion: nil)
  }
  
}

// MARK - UIPageViewControllerDataSource
extension ViewController: UIPageViewControllerDataSource {
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    
    switch viewController {
    case cardsVC:
      return profileVC
    case profileVC:
      return nil
    case matchesVC:
      return cardsVC
    default:
      return nil
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    
    switch viewController {
    case cardsVC:
      return matchesVC
    case profileVC:
      return cardsVC
    default:
      return nil
    }
  }
  
}

