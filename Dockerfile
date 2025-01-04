FROM gcc:9.5.0

# You can use `apt list PACKAGE` to determine the exact version.

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt install -y \
        runit \
        sudo \
        net-tools \
        iputils-ping \
        python3 \
        python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/* \
    && pip3 install -U setuptools==59.1.1 \
    && pip3 install --upgrade pip==24.0.0 \
    && pip3 install \
        pyyaml==6.0 \
        pyserial

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY entrypoint.sh /usr/bin
ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
