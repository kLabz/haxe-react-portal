package react.portal;

class PrioritizedData<T> {
	var map:Map<Priority, Null<T>>;

	public function new(?map:Map<Priority, Null<T>>) {
		this.map = map == null ? [] : map;
	}

	public function copy():PrioritizedData<T> {
		return new PrioritizedData<T>(map.copy());
	}

	public function copyWith(p:Priority, data:T):PrioritizedData<T> {
		var map = map.copy();
		map.set(p, data);
		return new PrioritizedData<T>(map);
	}

	public inline function has(predicate:T->Bool):Bool return get(predicate) != null;

	public function get(predicate:T->Bool):Null<T> {
		var p:Priority = Ultimate;

		while (p != null) {
			var content = map.get(p);
			if (content != null && predicate(content)) return content;
			p--;
		}

		return null;
	}

	public inline function hasPriority(p:Priority):Bool return map.exists(p);
	public inline function getPriority(p:Priority):Null<T> return map.get(p);
	public inline function setPriority(priority:Priority, content:T):Void map.set(priority, content);
}
