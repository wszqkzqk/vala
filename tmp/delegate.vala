void main() {
    f(t);
}

delegate A Test<A>(A x, A y);

int t(int a, int b) {
    return a+b;
}

void f(Test<int> y) {
    stdout.printf ("%d", y("1", "2"));
}
