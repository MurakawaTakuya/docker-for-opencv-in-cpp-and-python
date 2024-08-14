#include <opencv2/opencv.hpp>
#include <bits/stdc++.h>

using namespace std;
using namespace cv;

int main()
{
  Mat img1 = imread("image1.jpg", IMREAD_GRAYSCALE);
  Mat img2 = imread("image2.jpg", IMREAD_GRAYSCALE);

  if (img1.empty() || img2.empty())
  {
    cerr << "Cannot read image file." << endl;
    return -1;
  }

  // 差分画像を計算
  Mat diff;
  absdiff(img1, img2, diff);

  // 差分画像を閾値処理 (見やすくするため)
  Mat thresh;
  threshold(diff, thresh, 30, 255, THRESH_BINARY);

  // 差分画像を保存
  imwrite("output.jpg", thresh);

  cout << "Image processing is successfully done. Output image is saved as 'output.jpg'." << endl;

  return 0;
}
