package react.portal;

import react.ReactComponent;
import react.portal.PortalContext.PortalContentData;

typedef PortalContainerProps = {
	var id:String;
}

private typedef Props = {
	> PortalContainerProps,
	var content:Map<String, PortalContentData>;
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

		if (current == null) {
			if (state.content == null) return null;
			return {content: null};
		}

		if (current.content == state.content) return null;
		return {content: current.content};
	}

	public function new(props:Props) {
		super(props);

		state = {content: null};
	}

	override public function render():ReactFragment return state.content;
}
