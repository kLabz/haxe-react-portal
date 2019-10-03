package react.portal;

import react.ReactComponent;
import react.portal.PortalContext;

typedef PortalContentProps = {
	var target:String;
	var children:ReactFragment;
}

private typedef Props = {
	> PortalContentProps,
	var setContent:String->ReactFragment->Void;
}

private typedef State = {
	var target:String;
	var content:ReactFragment;
}

@:publicProps(PortalContentProps)
@:wrap(PortalContext.withSetContent)
class PortalContent extends ReactComponentOf<Props, State> {
	static function getDerivedStateFromProps(
		nextProps:Props,
		state:State
	):Null<Partial<State>> {
		if (
			nextProps.target == state.target
			&& nextProps.children == state.content
		) return null;

		nextProps.setContent(nextProps.target, nextProps.children);

		return {
			target: nextProps.target,
			content: nextProps.children
		};
	}

	public function new(props:Props) {
		super(props);

		state = {
			target: null,
			content: null
		};
	}

	override public function render():ReactFragment return null;

	override public function componentWillUnmount():Void {
		// TODO: This should only remove content this component owned
		props.setContent(state.target, null);
	}
}
