# ------------------------------------------------------------------------------
# Pull base image
FROM ubuntu:focal


# ------------------------------------------------------------------------------
# Set environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C

# ------------------------------------------------------------------------------
# Install prerequisites (openjdk,openvpn) and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      dbus-x11 \
      fbpanel \
      hsetroot \
      locales \
      nano \
      openbox \
      python-xdg \
      sudo \
      tigervnc-common \
      tigervnc-standalone-server \
      tzdata \
      wget \
      x11-utils \
      x11-xserver-utils \
      xfonts-base \
      xterm \    
#
      openjdk-11-jre-headless \
      openvpn \
      tree \
      webkit2gtk-driver && \
    sed -e 's/^assistive_technologies/#assistive_technologies/' \
      -i /etc/java-11-openjdk/accessibility.properties && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# ------------------------------------------------------------------------------
# Configure the system
RUN mkdir -p /usr/share/ubuntu-desktop/openbox && \
    cat /etc/xdg/openbox/rc.xml \
      | sed -e 's@<number>4</number>@<number>8</number>@' \
      > /usr/share/ubuntu-desktop/openbox/rc.xml && \
    sed -e 's/# en_US.UTF-8/en_US.UTF-8/' -i /etc/locale.gen && \
    locale-gen

# ------------------------------------------------------------------------------
# Provide default BiglyBT config
COPY conf/biglybt.config /usr/share/biglybt/biglybt.config.default

# ------------------------------------------------------------------------------
# Install startup scripts
#COPY bin/set_wallpaper.sh /usr/bin/
COPY conf/xstartup /usr/share/ubuntu-desktop/vnc/
COPY conf/autostart conf/menu.xml /usr/share/ubuntu-desktop/openbox/
COPY conf/fbpaneldefault /usr/share/ubuntu-desktop/fbpanel/default
COPY conf/sudo /usr/share/ubuntu-desktop/sudo
COPY scripts/*.sh /app/scripts/
COPY app/*.sh /app/

# ------------------------------------------------------------------------------
# Identify Volumes
VOLUME /in
VOLUME /out

# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 5901

# ------------------------------------------------------------------------------
# Define default command
CMD ["/app/app.sh"]
