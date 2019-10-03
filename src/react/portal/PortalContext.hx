package react.portal;

import react.React;
import react.ReactMacro.jsx;
import react.ReactComponent;
import react.ReactType;

typedef PortalContextState = {
	> PortalContextData,
	> PortalContextActions,
}

typedef PortalContextData = {
	var content:Map<String, ReactFragment>;
}

typedef PortalContextActions = {
	var setContent:String->ReactFragment->Void;
}

typedef PortalContextConsumerProps = {
	var children:PortalContextState->ReactFragment;
}

typedef PortalContextProviderProps = {
	var value:PortalContextState;
}

class PortalContext {
	public static var Consumer:ReactTypeOf<PortalContextConsumerProps>;
	public static var Provider:ReactTypeOf<PortalContextProviderProps>;

	public static function init() {
		var context = React.createContext();
		Consumer = context.Consumer;
		Provider = context.Provider;
	}

	public static function withContent<TProps:{}>(Comp:ReactType):ReactTypeOf<TProps> {
		return function (props:TProps) {
			return jsx(
				<Consumer>
					{value -> <Comp {...props} content={value.content} />}
				</Consumer>
			);
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
