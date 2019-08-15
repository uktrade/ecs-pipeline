FROM alpine:3.10

RUN apk --no-cache add \
		ca-certificates \
		curl \
		bash \
		jq \
		python3 && \
	pip3 install \
		awscli===1.16.218 && \
	curl -L https://github.com/silinternational/ecs-deploy/archive/3.6.0.tar.gz > ecs-deploy.tar.gz && \
	echo "e850709b196bfa89cff92d664af9d601  ecs-deploy.tar.gz" | md5sum -c && \
	tar -zxvf ecs-deploy.tar.gz && \
	rm -r -f ecs-deploy.tar.gz
 
ENTRYPOINT ["/ecs-deploy-3.6.0/ecs-deploy"]
