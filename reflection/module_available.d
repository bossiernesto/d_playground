static if(__traits(compiles, { import test.foo; })) {
import test.foo; /* safe to use */
} else {
// module not available, work around
}

