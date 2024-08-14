イメージのみ必要な場合は2だけで十分ですが、実行確認やイメージを編集したい場合は1~4の手順を行ってください

1. このGitをクローンする
`git clone https://github.com/MurakawaTakuya/docker-for-opencv-in-cpp-and-python.git`

2. Docker HubからImageを取得
ImageをDocker Hubに公開しているので、
`docker pull murakawatakuya/opencv-in-cpp-and-python:latest`
でローカルに取得してください。

3. (まだ入れてなければ)Makefileをインストール
https://www.kkaneko.jp/tools/win/make.html
where makeでパスが通っていればOKです。

4. make cppもしくはmake pythonで実行
C++
`make cpp`
Python
`make python`

`Image processing is successfully done. Output image is saved as 'output.jpg'.`と`Process completed successfully.`が表示され、差分を取ったoutput.jpgが生成されていれば成功です。
あとはお好きなようにプログラムを作成・実行してください。

1でインストールできない場合、もしくはDockerfileを編集した場合は`docker build -t image_processing_with_opencv .`でビルドしてください。スペックによっては10分以上かかります。
メモリ不足でクラッシュする場合は`make -j4 && \`の`-j`の後の数字を変えるとコア数を変更できます。(この場合は4コア)
CPU使用率やメモリ使用率がぎりぎりになっている場合はクラッシュする可能性があるので、コア数を少なくしてください。
逆に、スペックに余裕がある場合はコア数を増やすと早くなります。

参考
XPS 15
11th Gen Intel Core i7-11800H
メモリ 16GB
の場合約8分, 平均CPU使用率約50%, 平均メモリ使用率約80%
