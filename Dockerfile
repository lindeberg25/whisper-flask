FROM registry.access.redhat.com/ubi8/python-38

USER 0

RUN dnf update -y

RUN dnf upgrade -y

RUN echo "sslverify=false" >> /etc/yum.conf

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
RUN dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm -y 


RUN dnf -y install https://pkgs.dyn.su/el8/base/x86_64/raven-release-1.0-1.el8.noarch.rpm
RUN dnf -y install raven-release

RUN dnf --enablerepo=raven-extras --skip-broken install SDL2





RUN dnf install --nobest --skip-broken ffmpeg
#RUN dnf install ffmpeg 


WORKDIR /deployment

COPY requirements.txt requirements.txt
RUN dnf update && dnf install git -y


ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt



RUN pip install -r requirements.txt
RUN pip install "git+https://github.com/openai/whisper.git" 

COPY . .

EXPOSE 5000

#USER 1000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
