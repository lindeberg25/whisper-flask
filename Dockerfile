# Basing the build image on RHEL UBI image.
# See `docker search registry.access.redhat.com/ubi` 
FROM registry.access.redhat.com/ubi8/python-38

USER root

ARG USERNAME
ARG PASSWORD

# CodeReady contains packages required for develpers (i.e. imake)
# Must register system using RHEL subscription in order to access these packages

RUN subscription-manager register --username lindeberg.lpl@pf.gov.br --password Lin25068484 --auto-attach \
  && yum repolist \
  && subscription-manager attach --auto \
  && subscription-manager repos --enable=codeready-builder-for-rhel-8-x86_64-rpms \
  && yum repolist

RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm

RUN dnf upgrade
RUN dnf install ffmpeg



#RUN dnf update -y

#RUN dnf upgrade -y

RUN echo "sslverify=false" >> /etc/yum.conf

#RUN dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm -y
#RUN dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm -y 


#RUN dnf -y install https://pkgs.dyn.su/el8/base/x86_64/raven-release-1.0-1.el8.noarch.rpm
#RUN dnf -y install raven-release

#RUN dnf --enablerepo=raven-extras --skip-broken install SDL2





#RUN dnf install --nobest --skip-broken ffmpeg
#RUN dnf install ffmpeg 


WORKDIR /deployment

COPY requirements.txt requirements.txt
RUN  dnf -y install git


ADD https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt /deployment
RUN chmod 777 /deployment/medium.pt



RUN pip install -r requirements.txt
RUN pip install "git+https://github.com/openai/whisper.git" 

COPY . .

EXPOSE 5000

#USER 1000

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]
