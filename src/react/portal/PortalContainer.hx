package react.portal;

import react.ReactComponent;

typedef PortalContainerProps = {
	var id:String;
}

private typedef Props = {
	> PortalContainerProps,
	var content:Map<String, ReactFragment>;
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
		var content = nextProps.content.get(nextProps.id);
		if (content == state.content) return null;

		return {content: content};
	}

	public function new(props:Props) {
		super(props);

		state = {content: null};
	}

	override public function render():ReactFragment return state.content;
}
