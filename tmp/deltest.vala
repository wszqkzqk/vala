void main() {
    f(t);
}

int t(int a, int b) {
    return a+b;
}

void f(delegate(int x, int y) => int abc) {
    stdout.printf ("%d", abc(1, 2));
}
