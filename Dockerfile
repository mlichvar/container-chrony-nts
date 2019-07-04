FROM registry.fedoraproject.org/fedora:30
LABEL name="chrony-nts"
LABEL usage="docker run -d --name chrony-nts -p 11123:11123/udp -p 11443:11443/tcp $NAME"

RUN dnf install -y --nodocs --setopt=install_weak_deps=False \
		gnutls-devel nettle-devel libcap-devel libseccomp-devel \
		bison git-core gcc make rubygem-asciidoctor && \
	dnf -y clean all

RUN git clone https://github.com/mlichvar/chrony-nts.git

RUN cd chrony-nts && \
	./configure --enable-debug --enable-scfilter --prefix=/usr && \
	make -j1 && \
	make install

RUN mkdir /etc/chrony

COPY chrony.conf /etc
COPY server.crt server.key /etc/chrony/

USER 0

CMD ["/usr/sbin/chronyd", "-x", "-u", "nobody", "-d", "-d", "-F", "1"]
