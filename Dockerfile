FROM ubuntu-debootstrap:14.04
MAINTAINER Bitnami

ENV BITNAMI_PREFIX=/usr/local/bitnami
ENV BITNAMI_APP_NAME mariadb
ENV BITNAMI_APP_DIR=$BITNAMI_PREFIX/mysql
ENV BITNAMI_VOL_PREFIX=/bitnami/$BITNAMI_APP_NAME
ENV BITNAMI_APP_VERSION 5.5.42-0

ADD https://storage.googleapis.com/bitnami-artifacts/install.sh?GoogleAccessId=432889337695-e1gggo94k5qubupjsb35tajs91bdu0hg@developer.gserviceaccount.com&Expires=1434934078&Signature=QNkAu%2F8E2RlalSQy4n1sxMhsGKF%2FVltr6zu65HU6A9H0HKOgl6u9etqy9w6OwD4DsLMxYuy2uymOK3iDc5RbfkAMncKI1zJpxcwRQ4Mt43Oe8PBXKbQYcZ7mQaYPtpnjYblDs1S2p12Pu5NTDJHK2hJ1MrIUYwBup5n60R6OJRI%3D /tmp/install.sh
COPY post-install.sh /tmp/post-install.sh

# We need to specify a mysql password since the installer initializes the database, but it is
# removed in the post install and re-initialized at runtime.
RUN sh /tmp/install.sh\
    --base_password bitnami --mysql_password bitnami --mysql_allow_all_remote_connections 1 --disable-components common --mysql_init_data_dir 0

# Temporary, should be removed from installer
RUN rm -rf $BITNAMI_APP_DIR/data

ENV PATH $BITNAMI_APP_DIR/bin:$PATH
EXPOSE 3306
VOLUME ["$BITNAMI_VOL_PREFIX/data", "$BITNAMI_VOL_PREFIX/conf", "$BITNAMI_VOL_PREFIX/logs"]

COPY entrypoint.sh /entrypoint.sh
ADD https://www.dropbox.com/s/kce54xvd1jmka3h/bitnami-utils.sh?dl=1 /bitnami-utils.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld.bin"]
