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

	function setContent(target:String, owner:ReactComponent, content:ReactFragment):Void {
		setState(function(state) {
			var current = state.content.get(target);

			if (current != null && current.owner == owner) {
				if (React.isValidElement(content) && React.isValidElement(current.content)) {
					if (ReactFastCompare.isEqual(current.content, content)) return null;
				} else if (current.content == content) return null;
			}

			var newContent = state.content.copy();
			newContent.set(target, {content: content, owner: owner});
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
