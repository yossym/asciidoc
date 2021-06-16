#include    <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 10
int sort[N];

void BubleSort(void)
{
    int i, j, flag;
    do {
	flag = 0;
	for (i = 0; i < N - 1; i++) {
	    if (sort[i] > sort[i + 1]) {
		flag = 1;
		j = sort[i];
		sort[i] = sort[i + 1];
		sort[i + 1] = j;

	    }
	}
    }
    while (flag == 1);
}

int main(coid)
{
    int i;
    srand((unsigned int) time(NULL));
    printf("\nsort initalize:\n");
    for (i = 0; i < N; i++) {
	sort[i] = rand();
	printf("%d,", sort[i]);
    }
    printf("\n sort start:\n");
    BubleSort();

    printf("\nsort end\n");

    for (i = 0; i < N; i++) {
	printf("%d ", sort[i]);
    }
    return EXIT_SUCCESS;

}
