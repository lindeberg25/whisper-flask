FROM ubi8/s2i-base:rhel8.7

USER root

RUN echo "sslverify=false" >> /etc/yum.conf

RUN yum install epel-release
RUN yum localinstall --nogpgcheck https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
RUN yum install ffmpeg ffmpeg-devel

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN dnf update && dnf install git -y


ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /python-docker/medium.pt


RUN pip3 install -r requirements.txt
RUN pip3 install "git+https://github.com/openai/whisper.git" 

COPY . .

EXPOSE 5000

USER 1000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
