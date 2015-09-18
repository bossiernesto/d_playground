ClassInfo[] getChildClasses(ClassInfo c) {
    ClassInfo[] info;
	foreach(mod; ModuleInfo) {
            foreach(cla; mod.localClasses) {
		if(cla.base is c)
		    info ~= cla;
		}
	     }
	}
	return info;
}

class A {}
class B : A {}
class C : A {}

void main() {
    foreach(cla; getChildClasses(A.classinfo)) {
        import std.stdio;
	writeln(cla.name); // you could also create the class with
        cla.create();
    }
}
