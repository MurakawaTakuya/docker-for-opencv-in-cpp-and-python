#include <opencv2/opencv.hpp>
#include <bits/stdc++.h>

using namespace std;
using namespace cv;

int main()
{
  Mat img1 = imread("image1.jpg", IMREAD_GRAYSCALE);
  Mat img2 = imread("image2.jpg", IMREAD_GRAYSCALE);

  if (img1.empty() || img2.empty()){
    cerr << "Cannot read image file." << endl;
    return -1;
  }

  // ファイルの縦横の画素数が異なる場合の処理
  // if (img1.size() != img2.size()) {
  //   cerr << "Error: The sizes of the two images do not match." << endl;
  //   return -1;
  // }
  resize(img2, img2, img1.size());

  // 差分画像を計算
  Mat diff;
  absdiff(img1, img2, diff);

  // 差分画像を閾値処理 (見やすくするため)
  Mat thresh;
  threshold(diff, thresh, 10, 255, THRESH_BINARY);

  // 差分画像を保存
  imwrite("output.jpg", thresh);

  cout << "Image processing is successfully done. Output image is saved as 'output.jpg'." << endl;

  return 0;
}
