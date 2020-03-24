package react.portal;

import react.Empty;
import react.ReactComponent;
import react.ReactMacro.jsx;
import react.portal.PortalContext;

private typedef Props = {
	var children:ReactFragment;
}

class PortalProvider extends ReactComponentOf<Props, PortalContextData> {
	public function new(_:Empty) {
		super();

		state = {
			content: []
		};
	}

	override public function render():ReactFragment {
		var data:PortalContextState = {
			content: state.content,
			setContent: setContent
		};

		return jsx(
			<PortalContext.Provider value={data}>
				{props.children}
			</PortalContext.Provider>
		);
	}

	function setContent(
		target:String,
		owner:ReactComponent,
		content:ReactFragment,
		priority:Priority
	):Void {
		setState(function(state) {
			var current = state.content.get(target);

			if (current != null) {
				var currentPriority = current.getPriority(priority);

				if (currentPriority != null && currentPriority.owner == owner) {
					if (React.isValidElement(content) && React.isValidElement(currentPriority.content)) {
						if (ReactFastCompare.isEqual(currentPriority.content, content)) return null;
					} else if (currentPriority.content == content) return null;
				}

				current = current.copyWith(priority, {owner: owner, content: content});
			} else {
				current = new PrioritizedData();
				current.setPriority(priority, {owner: owner, content: content});
			}

			var newContent = state.content.copy();
			newContent.set(target, current);
			return {content: newContent};
		});
	}

}

// TODO: port to Haxe
@:jsRequire("react-fast-compare")
extern class ReactFastCompare {
	@:selfCall
	static function isEqual(a:Any, b:Any):Bool;
}
