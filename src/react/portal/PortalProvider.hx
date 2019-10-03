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

		PortalContext.init();
		state = {content: []};
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

	function setContent(target:String, content:ReactFragment):Void {
		setState(function(state) {
			var oldContent = state.content.get(target);
			if (oldContent == content) return null;

			var newContent = state.content.copy();
			newContent.set(target, content);

			return {content: newContent};
		});
	}
}
