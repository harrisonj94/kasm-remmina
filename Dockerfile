ARG BASE_TAG="develop"
ARG BASE_IMAGE="core-ubuntu-focal"
FROM kasmweb/$BASE_IMAGE:$BASE_TAG
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
ENV REMMINA_CONNS $HOME/.local/share/remmina

WORKDIR $HOME

RUN mkdir -p $REMMINA_CONNS
COPY ./src/ubuntu/install/remmina/connections/*.remmina $REMMINA_CONNS/

COPY ./src/ubuntu/install/remmina $INST_SCRIPTS/remmina/
RUN bash $INST_SCRIPTS/remmina/install_remmina.sh  && rm -rf $INST_SCRIPTS/remmina/

COPY ./src/ubuntu/install/remmina/custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x $STARTUPDIR/custom_startup.sh
RUN chmod 755 $STARTUPDIR/custom_startup.sh

RUN mkdir $HOME/.config/remmina/
COPY ./src/ubuntu/install/remmina/remmina.pref $HOME/.config/remmina/remmina.pref
RUN chown -R 1000:1000 $HOME/.config/remmina/

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/extra/backgrounds/bg_kasm.png /usr/share/extra/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

RUN chown 1000:0 $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
