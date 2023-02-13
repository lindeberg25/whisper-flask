FROM python:3.10-slim

USER root

#RUN dnf update -y

#RUN dnf upgrade -y

#RUN echo "sslverify=false" >> /etc/yum.conf

#RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
#RUN dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm -y 


#RUN dnf -y install https://pkgs.dyn.su/el8/base/x86_64/raven-release-1.0-1.el8.noarch.rpm
#RUN dnf -y install raven-release

#RUN dnf --enablerepo=raven-extras --skip-broken install SDL2

#RUN dnf install --nobest --skip-broken ffmpeg
#RUN dnf install ffmpeg 

WORKDIR /deployment

RUN apt-get -qq update \
    && apt-get -qq install --no-install-recommends ffmpeg


COPY requirements.txt requirements.txt
RUN  apt-get -y install git


ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt

RUN chmod -R 777 /deployment/



RUN pip install -r requirements.txt
RUN pip install "git+https://github.com/openai/whisper.git" 

COPY . .

EXPOSE 5000

#USER 1001

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
