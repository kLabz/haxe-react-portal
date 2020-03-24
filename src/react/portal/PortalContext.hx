package react.portal;

import react.React;
import react.ReactComponent;
import react.ReactContext;
import react.ReactMacro.jsx;
import react.ReactType;

typedef PortalContextState = {
	> PortalContextData,
	> PortalContextActions,
}

typedef PortalContextData = {
	var content:Map<String, PrioritizedData<PortalContentData>>;
}

typedef PortalContextActions = {
	var setContent:String->ReactComponent->ReactFragment->Priority->Void;
}

typedef PortalContextConsumerProps = {
	var children:PortalContextState->ReactFragment;
}

typedef PortalContextProviderProps = {
	var value:PortalContextState;
}

typedef PortalContentData = {
	var owner:ReactComponent;
	var content:ReactFragment;
}

class PortalContext {
	public static var Context(get, null):ReactContext<PortalContextState>;
	public static var Provider(get, null):ReactTypeOf<PortalContextProviderProps>;
	public static var Consumer(get, null):ReactTypeOf<PortalContextConsumerProps>;

	static function get_Context() {ensureReady(); return Context;}
	static function get_Provider() {ensureReady(); return Provider;}
	static function get_Consumer() {ensureReady(); return Consumer;}

	static function ensureReady() @:bypassAccessor {
		if (Context == null) {
			Context = React.createContext();
			Context.displayName = "PortalContext";
			Consumer = Context.Consumer;
			Provider = Context.Provider;
		}
	}

	// TODO: double-check external usage
	public static function withContent<TProps:{}>(Comp:ReactType):ReactTypeOf<TProps> {
		return function (props:TProps) {
			return jsx(
				<Consumer>
					{value -> <Comp {...props} content={value.content} />}
				</Consumer>
			);
		}
	}

	public static function withHasContent<TProps:{}>(key:String):ReactType->ReactTypeOf<TProps> {
		return function (Comp:ReactType):ReactTypeOf<TProps> {
			return function (props:TProps) {
				return jsx(
					<Consumer>
						{value -> <Comp {...props} hasContent={value.content.exists(key) && value.content.get(key).hasContent()} />}
					</Consumer>
				);
			}
		}
	}

	public static function withSetContent<TProps:{}>(Comp:ReactType):ReactTypeOf<TProps> {
		return function (props:TProps) {
			return jsx(
				<Consumer>
					{value -> <Comp {...props} setContent={value.setContent} />}
				</Consumer>
			);
		}
	}
}
