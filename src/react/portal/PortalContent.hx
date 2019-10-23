package react.portal;

import react.ReactComponent;
import react.portal.PortalContext;

typedef PortalContentProps = {
	var target:String;
	var children:ReactFragment;
	@:optional var alwaysClearOnUnmount:Bool;
}

private typedef State = {
	var target:String;
	var content:ReactFragment;
}

@:context(PortalContext.Context)
class PortalContent extends ReactComponentOf<PortalContentProps, State> {
	public function new(props:PortalContentProps) {
		super(props);

		state = {
			target: null,
			content: null
		};
	}

	override public function render():ReactFragment return null;
	override public function componentDidMount() update();
	override public function componentDidUpdate(_, _) update();

	function update():Void {
		if (props.target == state.target && props.children == state.content) return;
		context.setContent(props.target, this, props.children);

		setState({
			target: props.target,
			content: props.children
		});
	}

	override public function componentWillUnmount():Void {
		// TODO: This should only remove content this component owned
		if (context.currentOwner == this || props.alwaysClearOnUnmount)
			context.setContent(state.target, this, null);
	}
}
