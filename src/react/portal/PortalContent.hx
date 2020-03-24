package react.portal;

import react.ReactComponent;
import react.portal.PortalContext;

typedef PortalContentProps = {
	var target:String;
	var children:ReactFragment;
	@:optional var priority:Priority;
	@:optional var alwaysClearOnUnmount:Bool;
}

private typedef State = {
	var target:String;
	var content:ReactFragment;
	var priority:Priority;
}

@:context(PortalContext.Context)
class PortalContent extends ReactComponentOf<PortalContentProps, State> {
	static var defaultProps:Partial<PortalContentProps> = {
		priority: Average
	}

	public function new(props:PortalContentProps) {
		super(props);

		state = {
			target: null,
			content: null,
			priority: Average
		};
	}

	override public function render():ReactFragment return null;
	override public function componentDidMount() update();
	override public function componentDidUpdate(_, _) update();

	function update():Void {
		if (props.target == state.target && props.children == state.content && props.priority == state.priority) return;
		context.setContent(props.target, this, props.children, props.priority);

		setState({
			target: props.target,
			content: props.children,
			priority: props.priority
		});
	}

	override public function componentWillUnmount():Void {
		var current = context.content.get(state.target);

		if (current != null) {
			var current = current.getPriority(props.priority);
			if (current != null && (current.owner == this || props.alwaysClearOnUnmount))
				context.setContent(state.target, this, null, props.priority);
		}
	}
}
