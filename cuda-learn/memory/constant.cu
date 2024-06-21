
constexpr int N = 256;
__constant__ float constData[N];
float data[N];

int main() {
  cudaMemcpyToSymbol(constData, data, sizeof(data));
  cudaMemcpyFromSymbol(data, constData, sizeof(data));

  return 0;
}