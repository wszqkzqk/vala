void main() {
    f(t);
}

int t(Comp<int> a, Comp<int> b) {
    return a.a+b.a;
}

void f(delegate(Comp<int> x, Comp<int> y) => int abc) {
    stdout.printf ("%d", abc(new Comp<int>(1), new Comp<int>(2)));
}

class Comp<A> {
    public A a { get; private set; }

    public Comp (A a) {
        this.a = a;
    }
}
