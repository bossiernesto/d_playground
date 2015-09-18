struct S {
	// variables
	int a;
	int b;
	void delegate() c;
	string d;
	alias e = d;
	// functions
	void foo() {}
	int bar() { return 0; }

// types
struct Bar {}
enum Foo { a, b }
}

template TestTemplate(string s) {
enum TestTemplate = to!int(s);
}

// the helper for easier aliasing we'll need in step 3
alias helper(alias T) = T;
// This function writes details about all members of what it
// is passed. The string before argument is related to
// indenting the data it prints.
void inspect(alias T)(string before) {
import std.stdio;
import std.algorithm;
// step 2
foreach(memberName; __traits(allMembers, T)) {
	// step 3
	alias member = helper!(__traits(getMember, T, memberName));
	// step 4 - inspecting types
	static if(is(member)) {
		string specifically;
		static if(is(member == struct))
			specifically = "struct";
		else static if(is(member == class))
			specifically = "class";
		else static if(is(member == enum))
			specifically = "enum";
			writeln(before, memberName, " is a type (", specifically, ")");
		// drill down (step 1 again)
		inspect!member(before ~ "\t");
	} else static if(is(typeof(member) == function)) {
	// step 5, inspecting functions
	writeln(before, memberName, " is a function typed ",
	typeof(member).stringof);
	} else {
	// step 6, everything else
	static if(member.stringof.startsWith("module "))
		writeln(before, memberName, " is a module");
	else static if(is(typeof(member.init)))
		writeln(before, memberName, " is a variable typed ",typeof(member).stringof);
	else
		writeln(before, memberName, " is likely a template");
	}
	}
}

void main() {
// step 1: we'll start with a reference
// to the current module, gotten with mixin.
// Note: __MODULE__ is a special symbol the
// compiler replaces with the current module name.
inspect!(mixin(__MODULE__))("");
}


