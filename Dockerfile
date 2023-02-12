FROM registry.access.redhat.com/ubi8/ubi:8.1

USER root

RUN echo "sslverify=false" >> /etc/yum.conf

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
RUN dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm -y 
#RUN dnf install https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm -y
RUN dnf upgrade -y
RUN dnf install --nobest --skip-broken ffmpeg

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
