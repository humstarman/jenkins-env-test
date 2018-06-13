FROM ubuntu:16.04
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh 
