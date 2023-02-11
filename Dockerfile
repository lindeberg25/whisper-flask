FROM registry.access.redhat.com/ubi9/ubi

RUN echo "sslverify=false" >> /etc/yum.conf

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN dnf install -y https://download1.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm
RUN dnf upgrade -y
RUN dnf install -y --enablerepo=codeready-builder-for-rhel-9-x86_64-rpms ffmpeg

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN dnf update && dnf install git -y


ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /python-docker/medium.pt


RUN pip3 install -r requirements.txt
RUN pip3 install "git+https://github.com/openai/whisper.git" 

COPY . .

EXPOSE 5000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
