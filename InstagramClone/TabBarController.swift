import UIKit
import Firebase


class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBarController()
    }

    fileprivate func setupTabBarController() {
        view.backgroundColor = .white
        delegate = self
        //Instantiate controllers
        //Home
        let homeFlow = UICollectionViewFlowLayout()
        let home = UINavigationController.init(rootViewController: HomeCollectionVC(collectionViewLayout: homeFlow))
        home.tabBarItem.image = #imageLiteral(resourceName: "home_unselected")
        home.tabBarItem.selectedImage = #imageLiteral(resourceName: "home_selected")
        //Profile
        let profileFlow = UICollectionViewFlowLayout()
        let profile = UINavigationController.init(rootViewController: ProfileCollectionVC(collectionViewLayout: profileFlow))
        profile.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        profile.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        //Search
        let searchFlow = UICollectionViewFlowLayout()
        let search =  UINavigationController.init(rootViewController: SearchCollectionVC(collectionViewLayout: searchFlow))
        search.tabBarItem.image = #imageLiteral(resourceName: "search_unselected")
        search.tabBarItem.selectedImage = #imageLiteral(resourceName: "search_selected")
        //Like
        let likeFlow = UICollectionViewFlowLayout()
        let like =  UINavigationController.init(rootViewController: LikeCollectionVC(collectionViewLayout: likeFlow))
        like.tabBarItem.image = #imageLiteral(resourceName: "like_unselected")
        like.tabBarItem.selectedImage = #imageLiteral(resourceName: "like_selected")
        //New Post
        let post = UIViewController()
        post.tabBarItem.image = #imageLiteral(resourceName: "plus_unselected")
        post.tabBarItem.selectedImage = #imageLiteral(resourceName: "plus_unselected")
        //Set to Tab Bar
        //tabBar.tintColor = .black
        viewControllers = [home, search, post, like, profile]
        if let items = tabBar.items {
            for item in items{
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.lastIndex(of: viewController)
        if index == 2 {
            let flow = UICollectionViewFlowLayout()
            let controller =  UINavigationController.init(rootViewController: NewPostCollectionVC(collectionViewLayout: flow))
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true, completion: nil)
            return false
        }
        return true
    }
}
