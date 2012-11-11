import haxe.macro.Context;
import haxe.macro.Expr;
class Test {
	// String -> Controllerという型の関数をコンパイル時に生成する
	@:macro public static function makeRoutingFunction(classNames:Array<String>) : Expr
	{
		var switchStmt = "function (m) { return switch (m) {";
		for (className in classNames) {
			switchStmt += "case \"" + className + "\": new " + className + "();";
		}
		// Context.parseは文字列をhaxe構文と解釈してparse、Exprを返す
		return Context.parse(switchStmt + "}}", Context.currentPos());
	}

	static function main()
	{
		var routing : String -> Controller = makeRoutingFunction(["Hoge", "Moge"]);
		var ctl = routing("Moge"); // "Moge"文字列からMogeオブジェクトを生成
		trace("class:" + ctl.action());
	}
}

interface Controller {
	public function action() : String;
}
class Hoge implements Controller {
	public function new() {}
	public function action() {
		return "Hoge obj is created";
	}
}
class Moge implements Controller {
	public function new() {}
	public function action() {
		return "Moge obj is created";
	}
}
