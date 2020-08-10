RUN apt-get update && apt-get install -yq unzip
WORKDIR /tk4-/
ADD http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip /tk4-/
RUN unzip tk4-_v1.00_current.zip && \
    rm -rf /tk4-/tk4-_v1.00_current.zip
ADD https://polybox.ethz.ch/index.php/s/sZk2wRMhsF2uwai/download /tk4-/sdl_summer.zip
RUN unzip -o sdl_summer.zip && \
    rm -rf /tk4-/sdl_summer.zip
RUN ./activate_SDL
ADD https://polybox.ethz.ch/index.php/s/pz5Ed1pDPB0PFJz/download /tk4-/sdl_latest.zip
RUN unzip -o sdl_latest.zip && \
    rm -rf /tk4-/sdl_latest.zip
RUN echo "CONSOLE">/tk4-/unattended/mode
RUN rm -rf /tk4-/hercules/darwin && \
    rm -rf /tk4-/hercules/windows && \
    rm -rf /tk4-/hercules/source && \
    rm -rf /tk4-/hercules_SDL/darwin && \
    rm -rf /tk4-/hercules_SDL/windows && \
    rm -rf /tk4-/hercules_SDL/source
RUN apt-get -y purge unzip && \
    apt-get -y autoclean && apt-get -y autoremove && \
    apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
    rm -rf /var/lib/apt/lists/*
RUN dir /tk4-/local_conf/

FROM ubuntu:18.04
WORKDIR /tk4-/
COPY --from=builder /tk4-/ .

VOLUME [ "/tk4-/conf","/tk4-/local_conf","/tk4-/local_scripts","/tk4-/prt","/tk4-/dasd","/tk4-/pch","/tk4-/jcl","tk4-/log" ]
CMD ["/tk4-/mvs"]
EXPOSE 3270 8038
