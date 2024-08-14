# Dockerコンテナ名
CONTAINER_NAME=image_processing_with_opencv_container

# Dockerイメージ名
IMAGE_NAME=murakawatakuya/opencv-in-cpp-and-python:latest # imageをpullした場合
# IMAGE_NAME=image_processing_with_opencv # imageをbuildした場合

# C++ソースファイル名
CPP_FILE=processImage.cpp

# Pythonスクリプトファイル名
PYTHON_FILE=processImage.py

# 実行ファイル名(バイナリファイル名)
EXECUTABLE=processImage

# 画像ファイル
IMAGE1=image1.jpg
IMAGE2=image2.jpg
OUTPUT_IMAGE=output.jpg

# イメージをプルする
pull:
	docker pull $(IMAGE_NAME)

# コンテナを起動する
run-container:
	docker run -dit --rm --name $(CONTAINER_NAME) $(IMAGE_NAME)

# ソースファイルと画像ファイルをコンテナにコピーする（C++用）
copy-files-cpp:
	docker cp $(CPP_FILE) $(CONTAINER_NAME):/$(CPP_FILE)
	docker cp $(IMAGE1) $(CONTAINER_NAME):/$(IMAGE1)
	docker cp $(IMAGE2) $(CONTAINER_NAME):/$(IMAGE2)

# ソースファイルと画像ファイルをコンテナにコピーする（Python用）
copy-files-python:
	docker cp $(PYTHON_FILE) $(CONTAINER_NAME):/$(PYTHON_FILE)
	docker cp $(IMAGE1) $(CONTAINER_NAME):/$(IMAGE1)
	docker cp $(IMAGE2) $(CONTAINER_NAME):/$(IMAGE2)

# C++プログラムをコンパイルする
build:
	docker exec -it $(CONTAINER_NAME) bash -c "g++ -o $(EXECUTABLE) $(CPP_FILE) -I/usr/local/include/opencv4 -L/usr/local/lib -lopencv_core -lopencv_imgcodecs -lopencv_highgui -lopencv_imgproc"

# C++プログラムを実行する
run-cpp:
	docker exec -it $(CONTAINER_NAME) bash -c "LD_LIBRARY_PATH=/usr/local/lib ./$(EXECUTABLE)"

# Pythonスクリプトを実行する
run-python:
	docker exec -it $(CONTAINER_NAME) bash -c "PYTHONIOENCODING=utf-8 python3 $(PYTHON_FILE)"

# 結果の画像をホストにコピーする
copy-output:
	docker cp $(CONTAINER_NAME):/$(OUTPUT_IMAGE) $(OUTPUT_IMAGE)

# クリーンアップ（コンテナを停止）
clean:
	docker stop $(CONTAINER_NAME)

success-message:
	@echo. && echo Process completed successfully.

# C++版の全てのステップをまとめて実行する
cpp: run-container copy-files-cpp build run-cpp copy-output clean success-message

# Python版の全てのステップをまとめて実行する
python: run-container copy-files-python run-python copy-output clean success-message
