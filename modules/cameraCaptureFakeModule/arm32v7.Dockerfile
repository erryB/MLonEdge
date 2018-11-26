FROM resin/rpi-raspbian:stretch

RUN [ "cross-build-start" ]

WORKDIR /app
ADD ./test_image.jpg .

RUN apt-get update && apt-get install -y --no-install-recommends\
    python3 \
    python3-pip \
    build-essential \
    libboost-python1.62.0 \
    python3-picamera \
    python3-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip 
RUN pip install --upgrade setuptools 
COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY . .

RUN mkdir /capturedImage
RUN chmod 777 /capturedImage

RUN useradd -ms /bin/bash moduleuser
RUN usermod -a -G video moduleuser
USER moduleuser




ENTRYPOINT [ "python3", "-u", "./main.py" ]