#include<stdio.h>

/* �}�[�W�\�[�g */
void merge_sort (int array[], int left, int right) {
  int i, j, k, mid;
  int work[10];  // ��Ɨp�z��
  if (left < right) {
    mid = (left + right)/2; // �^��
    merge_sort(array, left, mid);  // ���𐮗�
    merge_sort(array, mid+1, right);  // �E�𐮗�
    for (i = mid; i >= left; i--) { work[i] = array[i]; } // ������
    for (j = mid+1; j <= right; j++) {
      work[right-(j-(mid+1))] = array[j]; // �E�������t��
    }
    i = left; j = right;
    for (k = left; k <= right; k++) {
      if (work[i] < work[j]) { array[k] = work[i++]; }
      else                   { array[k] = work[j--]; }
    }
  }
}

int main (void) {
  int array[10] = { 2, 1, 8, 5, 4, 7, 9, 0, 6, 3 };
  int i;

  printf("Before sort: ");
  for (i = 0; i < 10; i++) { printf("%d ", array[i]); }
  printf("\n");

  merge_sort(array, 0, 9);

  printf("After sort: ");
  for (i = 0; i < 10; i++) { printf("%d ", array[i]); }
  printf("\n");

  return 0;
}
