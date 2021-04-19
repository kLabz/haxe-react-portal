package react.portal;

import react.ReactComponent;
import react.portal.PortalContext.PortalContentData;

typedef PortalContainerProps = {
	var id:String;
	@:optional var children:ReactFragment;
}

private typedef Props = {
	> PortalContainerProps,
	var content:Map<String, PrioritizedData<PortalContentData>>;
}

private typedef State = {
	var content:ReactFragment;
}

@:publicProps(PortalContainerProps)
@:wrap(PortalContext.withContent)
class PortalContainer extends ReactComponentOf<Props, State> {
	static function getDerivedStateFromProps(
		nextProps:Props,
		state:State
	):Null<Partial<State>> {
		var current = nextProps.content.get(nextProps.id);

		if (current == null || !current.has(hasContent)) {
			if (state.content == null) return null;
			return {content: null};
		}

		var currentContent = current.get(hasContent).content;
		if (currentContent == state.content) return null;
		return {content: currentContent};
	}

	public function new(props:Props) {
		super(props);

		state = {content: null};
	}

	static function hasContent(c:PortalContentData):Bool return c.content != null;
	override public function render():ReactFragment {
		var ret = state.content;
		if (ret == null && props.children != null) return props.children;
		return ret;
	}
}
