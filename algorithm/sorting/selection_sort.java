public class SelectionSort {
	public void selectionSort(int[] arr) {
		int i, j, minInedx, tmp;
		int n = arr.length;
		for (i = 0; i < n - 1; i++) {
			minInedx = i;
			for (j = i + 1; j < n; j++) {
				if (arr[minInedx] > arr[j]) {
					minInedx = j;
				}
			}

			if (i != minInedx) {
				tmp = arr[minInedx];
				arr[minInedx] = arr[i];
				arr[i] = tmp;
			}
		}
	}

	public static void main(String[] args) {
		int i;
		int[] a= new int[]{5, 1, 12, -5, 16, 2, 12, 14};
		selectionSort(a);
		for (i = 0; i < a.length; i++) {
			System.out.println(a[i]);
		}
	}
}