イメージのみ必要な場合は2だけで十分ですが、実行確認やイメージを編集したい場合は1~4の手順を行ってください

## 1. このGitをクローンする<br>
`git clone https://github.com/MurakawaTakuya/docker-for-opencv-in-cpp-and-python.git`

## 2. Docker HubからImageを取得<br>
ImageをDocker Hubに公開しているので、<br>
`make pull`<br>
でローカルに取得してください。

## 3. (まだ入れてなければ)Makefileをインストール<br>
https://www.kkaneko.jp/tools/win/make.html<br>
where makeでパスが通っていればOKです。

## 4. make cppもしくはmake pythonで実行
C++
`make cpp`
Python
`make python`

`Image processing is successfully done. Output image is saved as 'output.jpg'.`と`Process completed successfully.`が表示され、差分を取ったoutput.jpgが生成されていれば成功です。<br>
あとはお好きなようにプログラムを作成・実行してください。

<br><br>

1でインストールできない場合、もしくはDockerfileを編集した場合は`docker build -t image_processing_with_opencv .`でビルドしてください。また、自分でビルドした場合は`Makefile`の`IMAGE_NAME`を`imageをbuildした場合`にコメントアウトを入れ替えてください。

ビルドはスペックによって20分以上かかります。<br>
メモリ不足でクラッシュする場合は`make -j8 && \`の`-j`の後の数字を変えるとコア数を変更できます。(この場合は8コア)<br>
CPU使用率やメモリ使用率がぎりぎりになっている場合はクラッシュする可能性があるので、コア数を少なくしてください。<br>
逆に、スペックに余裕がある場合はコア数を増やすと早くなります。

参考<br>
XPS 15<br>
11th Gen Intel Core i7-11800H<br>
メモリ 16GB<br>
の場合約13分, 平均CPU使用率約70%, 平均メモリ使用率約80%
