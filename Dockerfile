FROM google/cloud-sdk:176.0.0-alpine

COPY bazooka.sh /bazooka.sh
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

