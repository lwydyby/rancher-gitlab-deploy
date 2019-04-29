# rancher-gitlab-deploy
gitlab ci auto update rancher2 docker project  

gitlabci.yml example:
```
image: docker

stages:
  - build
  - release
  - deploy
build:
  stage: build
  image: node:9.4.0
  cache:
    paths:
      - node_modules/
  script:
    - npm set registry https://registry.npm.taobao.org
    - npm install
    - npm run build
  artifacts:
    paths:
      - /dist
job-release:
  stage: release
  script:
    - docker info
    - DATE=`date +%Y%m%d`
    - TAG=$DATE-$CI_JOB_ID
    - docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD} ${DOCKER_REGISTER}
    - docker build -t ${DOCKER_REGISTER}/${PROJECT_NAME}:$TAG .
    - docker push ${DOCKER_REGISTER}/${PROJECT_NAME}:$TAG
    - docker tag ${DOCKER_REGISTER}/${PROJECT_NAME}:$TAG ${DOCKER_REGISTER}/${PROJECT_NAME}:latest
    - docker push ${DOCKER_REGISTER}/${PROJECT_NAME}:latest

deploy:
  stage: deploy
  image: lwydyby/rancher-gitlab-deploy:latest
  script:
    - bash  /data/update.sh  ${PROJECT_NAME}  ${RANCHER_WORKSPACE}  ${RANCHER_NAMESPACE}  ${RANCHER_IP}  ${RANCHER_TOKEN}
```



url: https://'${ip}'/v3/project/'${workspace}'/workloads/deployment:'${namespace}':'${programName}

PROJECT_NAME: Your project name

RANCHER_WORKSPACE： your rancher workspace

RANCHER_NAMESPACE:  your rancher namespace

RANCHER_IP: your rancher url

RANCHER_TOKEN: rancher token
