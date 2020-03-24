package react.portal;

enum abstract Priority(Int) to Int {
	var Insignificant = -5;
	var Lowest;
	var Lower;
	var Low;
	var BelowAverage;
	var Average;
	var AboveAverage;
	var High;
	var Higher;
	var Highest;
	var Ultimate;

	private function new(i:Int) this = i;

	var self(get, never):Priority;
	function get_self():Priority return new Priority(this);

	@:noCompletion @:op(A > B) public function gt(b:Priority) return this > (b:Int);
	@:noCompletion @:op(A >= B) public function gte(b:Priority) return this >= (b:Int);
	@:noCompletion @:op(A < B) public function lt(b:Priority) return this < (b:Int);
	@:noCompletion @:op(A <= B) public function lte(b:Priority) return this <= (b:Int);
	@:noCompletion @:op(A == B) public function eq(b:Priority) return this == (b:Int);
	@:noCompletion @:op(A != B) public function neq(b:Priority) return this != (b:Int);

	@:op(A++)
	inline public function incr():Null<Priority> {
		if (self >= Ultimate) {
			this = null;
			return null;
		}

		this = this + 1;
		return self;
	}

	@:op(A--)
	inline public function decr():Null<Priority> {
		if (self <= Insignificant) {
			this = null;
			return null;
		}

		this = this - 1;
		return self;
	}
}
