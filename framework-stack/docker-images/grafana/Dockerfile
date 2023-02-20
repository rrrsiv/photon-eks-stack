# Maintainer: Shivam Mudotia (shivam.mudotia@nagarro.com)
FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y apt-transport-https && \
    apt-get install -y software-properties-common wget && \
    echo "deb https://packages.grafana.com/enterprise/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list && \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add - && \
    add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" && \
    apt-get update && apt-get install -y grafana && \
    apt-get install -y curl && apt-get install -y jq && \
    apt-get install -y unzip

   
EXPOSE 3000

COPY autohome-compareQueries-datasource-master.zip ./usr/share/grafana/data/plugins/

RUN unzip /usr/share/grafana/data/plugins/autohome-compareQueries-datasource-master.zip -d /usr/share/grafana/data/plugins/ && rm -f /usr/share/grafana/data/plugins/autohome-compareQueries-datasource-master.zip
RUN chmod -R 777 /usr/share/grafana/data/plugins

CMD ["grafana-server","--homepath=/usr/share/grafana"]

#ENTRYPOINT ["./bin/bash"]