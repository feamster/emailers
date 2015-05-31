#include <stdio.h>

int w= 1, x= 1;

void f(void) {
  w += 1;
  x *= 2;
  printf("f: %d %d\n", w, x);
}

void g(void) {
  int w= 1;

  w += 1;
  x *= 2;
  f();
  printf("g: %d %d\n", w, x);
}

void h(void) {
  int x= 1;

  w += 1;
  x *= 2;
  g();
  printf("h: %d %d\n", w, x);
}

int main() {
  h();
  printf("main: %d %d\n", w, x);

  return 0;
}
