
import Foundation
import TaskemFoundation

@IBDesignable
class ScheduleToolbar: XibFileView, ThemeObservable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var toolbar: TaskemToolbar!

    var share: ScheduleToolbarItem!
    var delete: ScheduleToolbarItem!
    var list: ScheduleToolbarItem!

    var onShare: (() -> Void)?
    var onDelete: (() -> Void)?
    var onList: (() -> Void)?

    public init(selected: Int, all: Int) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        let isEnableAction = isEnableActions(selected: selected)

        delete = ScheduleToolbarItem(
            title: "DELETE",
            image: Icons.icScheduleEditDelete.image
        )
        delete.onTouch = { [weak self] in self?.onDelete?() }
        delete.isEnabled = isEnableAction
        let deleteItem = UIBarButtonItem(customView: delete)
        
        share = ScheduleToolbarItem(
            title: "SHARE",
            image: Icons.icScheduleEditShare.image
        )
        share.onTouch = { [weak self] in self?.onShare?() }
        share.isEnabled = isEnableAction
        let shareItem = UIBarButtonItem(customView: share)
        
        list = ScheduleToolbarItem(
            title: "LIST",
            image: Icons.icScheduleEditList.image
        )
        list.onTouch = { [weak self] in self?.onList?() }
        list.isEnabled = isEnableAction
        let listItem = UIBarButtonItem(customView: list)
        
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
            
        )
        toolbar.toolbar.items = [space, deleteItem, space, space, shareItem, space, space, listItem, space]
        
        update(current: selected, all: all)
        
        observeAppTheme()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyTheme(_ theme: AppTheme) {
        backgroundColor = theme.toolbar
        title.textColor = theme.secondTitle
    }

    public func update(current: Int, all: Int) {
        let isEnable = isEnableActions(selected: current)
        list.isEnabled = isEnable
        delete.isEnabled = isEnable
        share.isEnabled = isEnable

        updateTitle(current: current)
    }

    private func updateTitle(current: Int) {
        title.text = "SELECTED: \(current) ITEMS"
    }

    private func isEnableActions(selected: Int) -> Bool {
        return selected != 0
    }

    func show(in controller: UIViewController) {
        controller.view.addSubview(self)

        let margins = controller.view.layoutMarginsGuide

        bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        let safeMargins = controller.view.safeAreaLayoutGuide

        rightAnchor.constraint(equalTo: safeMargins.rightAnchor).isActive = true
        leftAnchor.constraint(equalTo: safeMargins.leftAnchor).isActive = true

        setNeedsLayout()
        layoutIfNeeded()

        alpha = 0
        let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut) {
            self.alpha = 1
        }
        animator.startAnimation()
    }
}
