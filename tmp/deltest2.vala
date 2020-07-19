void main() {
    f(t);
}

int t(int a, int b) {
    return a+b;
}

delegate int oma123(int x, int y);

void f(oma123 abc) {
    stdout.printf ("%d", abc(1, 2));
}
