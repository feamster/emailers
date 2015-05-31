#include <stdio.h>

int arr[]= {10, 20, 30};
int x= 2;

void f(int r1, int r2,
       int n1, int n2) {
  arr[0]= r1 + n2 - 1;
  n2= (x * 5) % 3;
  n1= n1 + 1;
  arr[r2 + x]= n1 - arr[0];
  r1++;
}

int main() {
  f(arr[x], x, arr[x], x);
  printf("%d %d %d %d\n", x,
         arr[0], arr[1], arr[2]);

  return 0;
}
