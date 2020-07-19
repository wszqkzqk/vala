class Foo { }

void main() {
    //with(% = new Foo()) { } // ok
    //with(var % = new Foo()) { } // not ok: `=' is not the problem here
    //with(% f = new Foo()) { } // ok: % isn't a correct type identifier
    //with(Foo f new Foo()) { } // not ok: `with(Foo f) isn't correct, either
    //with(var f new Foo()) { } // ok: a `=' is missing
    //with(f new Foo()) { } // ok: a `=' is missing
}
