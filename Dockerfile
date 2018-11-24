FROM        centos/systemd

MAINTAINER  "Robert Haidari" <robert.haidari@hotemu.com>

ENV         CORENLP_ARCHIVE="stanford-corenlp-full-2018-10-05"
ENV         CORENLP_FILE="${CORENLP_ARCHIVE}.zip"
ENV         CORENLP_ARCHIVE_TMP_LOCATION="/tmp/${CORENLP_ARCHIVE}" \
            CORENLP_ARCHIVE_TMP_ZIP="/tmp/${CORENLP_FILE}" \
            CORENLP_PERMANANT_LOCATION="/opt/corenlp"

ENV         SUDO_USER="nlp" \
            SUDO_USER_PASS=""

RUN         yum -y update \
            && yum clean all

RUN         yum -y install git authbind wget unzip sudo java-1.8.0-openjdk-devel \
            && yum clean all

RUN         yum remove systemd-container \
            && yum remove systemd-container-libs \
            && yum -y install systemd systemd-libs

RUN         wget -O ${CORENLP_ARCHIVE_TMP_ZIP} "http://nlp.stanford.edu/software/${CORENLP_FILE}" \
            && mkdir ${CORENLP_PERMANANT_LOCATION} \
            && unzip -j ${CORENLP_ARCHIVE_TMP_ZIP} -d ${CORENLP_PERMANANT_LOCATION} \
            && rm ${CORENLP_ARCHIVE_TMP_ZIP} \
            && cd ${CORENLP_PERMANANT_LOCATION}

COPY        env_vars.sh ${CORENLP_PERMANANT_LOCATION}/env_vars.sh

RUN         rm "${CORENLP_PERMANANT_LOCATION}/corenlp.sh" \
            && wget "https://raw.githubusercontent.com/HotEmu/dockerfiles/master/corenlp.sh" -P ${CORENLP_PERMANANT_LOCATION} \
            && sudo chmod a+x "${CORENLP_PERMANANT_LOCATION}/corenlp.sh"

RUN         sudo wget "https://raw.githubusercontent.com/HotEmu/dockerfiles/master/corenlp.service" -P "/etc/systemd/system"

RUN         useradd -g wheel ${SUDO_USER} \
            && echo "${SUDO_USER}:${SUDO_USER_PASS}" | chpasswd \
            && sed -i -e 's/^\(%wheel\s\+.\+\)/##\1/gi' /etc/sudoers \
            && echo -e '\n%wheel ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
            && echo -e '\nDefaults:nlp   !requiretty' >> /etc/sudoers \
            && echo -e '\nDefaults:%wheel !requiretty' >> /etc/sudoers \
            && sudo groupadd nlp \
            && usermod -a -G nlp nlp \
            && sudo mkdir -p /etc/authbind/byport/ \
            && sudo touch /etc/authbind/byport/9000 \
            && sudo chown nlp:nlp /etc/authbind/byport/9000 \
            && sudo chmod 600 /etc/authbind/byport/9000

RUN         systemctl enable corenlp.service

EXPOSE      9000

CMD         ["/usr/sbin/init"]