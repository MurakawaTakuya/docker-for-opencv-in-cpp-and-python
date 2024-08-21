# Dockerコンテナ名
CONTAINER_NAME=image_processing_with_opencv_container

# Dockerイメージ名
IMAGE_NAME=murakawatakuya/opencv-in-cpp-and-python:latest # imageをpullした場合
# IMAGE_NAME=image_processing_with_opencv # imageをbuildした場合

# C++ソースファイル名
CPP_FILE=processImage.cpp

# C++実行ファイル名(バイナリファイル名)
EXECUTABLE=processImage

# Pythonスクリプトファイル名
PYTHON_FILE=processImage.py

# コンテナを停止するコマンド
ifeq ($(OS),Windows_NT)
	STOP_CONTAINER = powershell -Command "if (docker ps -q -f name=$(CONTAINER_NAME)) { docker stop $(CONTAINER_NAME) }"
else
	STOP_CONTAINER = bash -c 'if [ $$(docker ps -q -f name=$(CONTAINER_NAME)) ]; then docker stop $(CONTAINER_NAME); fi'
endif

# イメージをプルする
pull-image:
	@echo. && echo Pulling the image...
	docker pull $(IMAGE_NAME)
	@echo Image pulled successfully.

# コンテナを起動する(前回エラーでコンテナが停止していない場合に再起動する)
run-container:
	@echo. && echo Running the container...
	@$(STOP_CONTAINER)
	docker run -dit --rm --name $(CONTAINER_NAME) $(IMAGE_NAME)
	@echo Container started successfully.

# 画像ファイルをコンテナにコピーする
IMAGE1=image1.jpg
IMAGE2=image2.jpg
copy-images:
	@echo. && echo Copying images to the container...
	docker cp $(IMAGE1) $(CONTAINER_NAME):/
	docker cp $(IMAGE2) $(CONTAINER_NAME):/
	@echo Images copied successfully.

# ソースファイルと画像ファイルをコンテナにコピーする（C++用）
copy-files-cpp:
	@echo. && echo Copying C++ source file to the container...
	docker cp $(CPP_FILE) $(CONTAINER_NAME):/$(CPP_FILE)
	@echo Files copied successfully.

# ソースファイルと画像ファイルをコンテナにコピーする（Python用）
copy-files-python:
	@echo. && echo Copying Python script to the container...
	docker cp $(PYTHON_FILE) $(CONTAINER_NAME):/$(PYTHON_FILE)
	@echo Files copied successfully.

# C++プログラムをコンパイルする
cpp-compile:
	@echo. && echo Compiling cpp program...
	docker exec -it $(CONTAINER_NAME) bash -c "g++ -o $(EXECUTABLE) $(CPP_FILE) -I/usr/local/include/opencv4 -L/usr/local/lib -lopencv_core -lopencv_imgcodecs -lopencv_highgui -lopencv_imgproc"
	@echo Program compiled successfully.

# C++プログラムを実行する
run-cpp:
	@echo. && echo Running cpp program...
	docker exec -it $(CONTAINER_NAME) bash -c "LD_LIBRARY_PATH=/usr/local/lib ./$(EXECUTABLE)"
	@echo Program finished.

# Pythonスクリプトを実行する
run-python:
	@echo. && echo Running python script...
	docker exec -it $(CONTAINER_NAME) bash -c "PYTHONIOENCODING=utf-8 python3 $(PYTHON_FILE)"
	@echo Script finished.

# 結果の画像をホストにコピーする
OUTPUT_IMAGE=output.jpg
copy-output:
	@echo. && echo Copying output image to the host...
	docker cp $(CONTAINER_NAME):/$(OUTPUT_IMAGE) $(OUTPUT_IMAGE)
	@echo Output image copied successfully.

# コンテナを停止
stop-container:
	@echo. && echo Cleaning up...
	docker stop $(CONTAINER_NAME)
	@echo Cleaned up successfully.

success-message:
	@echo. && echo All process completed successfully.

init: run-container copy-images

finish: stop-container success-message

# C++版の全てのステップをまとめて実行する
cpp: init \
	copy-files-cpp \
	cpp-compile \
	run-cpp \
	copy-output \
	finish

# Python版の全てのステップをまとめて実行する
python: init \
	copy-files-python \
	run-python \
	copy-output \
	finish
