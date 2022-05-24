//
//  VCReview+PageController.swift
//  testFireDatabase
//
//  Created by Rajveer Kaur on 13/05/22.
//

import UIKit

extension VCReview :UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func menuBarDidSelectItemAt(index: Int) {
        print(index)
        if index > selectedIndex{
            switch index {
            case 0:
                if let firstViewController = orderedViewControllers.first {
                    pageVc.setViewControllers([firstViewController],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
                    if let visibleVC = firstViewController as? VCIndividualReview {
                        print(self.selectedFormId)
                        visibleVC.formId = self.selectedFormId!
                    }
                }
            case 1:
                pageVc.setViewControllers([self.newVc(viewController: "VCIndividualReview")],
                                          direction: .forward,
                                          animated: true,
                                          completion: nil)
                if let visibleVC = pageVc.viewControllers?.first as? VCIndividualReview {
                    visibleVC.formId = self.selectedFormId!
                }
                
            default:
                print("")
            }
        }else{
            switch index {
            case 0:
                if let firstViewController = orderedViewControllers.first {
                    pageVc.setViewControllers([firstViewController],
                                              direction: .reverse,
                                              animated: true,
                                              completion: nil)
                }
            case 1:
                let firstViewController = orderedViewControllers[1]
                pageVc.setViewControllers([firstViewController],
                                          direction: .reverse,
                                          animated: true,
                                          completion: nil)
            default:
                print("")
            }
        }
        
    }
    
    func newVc(viewController: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    func changeTab(index:Int){
        for btn in btnList{
            btn.setTitleColor(UIColor.lightGray, for: .normal)
        }
        for view in viewList{
            view.backgroundColor = UIColor.lightGray
        }
        btnList[index].setTitleColor(UIColor(named: "AppDarkBlue"), for: .normal)
        viewList[index].backgroundColor = UIColor(named: "AppDarkBlue")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let visibleViewController = pageViewController.viewControllers?.first
        let index = orderedViewControllers.firstIndex(of: visibleViewController!)
        changeTab(index:index!)
       
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        if let visibleVC = orderedViewControllers[previousIndex] as? VCIndividualReview {
            visibleVC.formId = self.selectedFormId
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        if let visibleVC = orderedViewControllers[nextIndex] as? VCIndividualReview {
            print(self.selectedFormId)
            visibleVC.formId = self.selectedFormId!
        }
        return orderedViewControllers[nextIndex]
    }
}

