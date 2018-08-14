#!/bin/bash

REGION="us-west-2"
SERVICE_NAME="movie-svc"
CLUSTER="theater"
IMAGE_VERSION="v_"${BUILD_NUMBER}
TASK_FAMILY="tinyapp-taskdef"

#create a new task def for this build

sed -e "s;%BUILD_NUMBER%;${BUILD_NUMBER};g"  tinyapp.json  > tinyapp-v_${BUILD_NUMBER}.json
echo "new json created successfully"
aws ecs register-task-definition --family ${TASK_FAMILY} --region ${REGION} --cli-input-json "file://tinyapp-v_${BUILD_NUMBER}.json"
echo "aws ecs register-task-definition executed successfully"

#update the service with new task def and desired count
REVISION=`aws ecs describe-task-definition --task-definition ${TASK_FAMILY} --region ${REGION} | egrep "revision" | tr "/"  " " | awk '{print $2}' | sed 's/"$//'`
SERVICES=`aws ecs describe-services --services ${SERVICE_NAME}  --cluster ${CLUSTER}  --region ${REGION} | jq .failures[]`
echo "Variables REVISION and SERVICES assigned successfully"
#create or Update service
if [ "${SERVICES}" == "" ];  then
  echo "entering existing service"
  DESIRED_COUNT=`aws ecs describe-services --services ${SERVICE_NAME}  --cluster ${CLUSTER}  --region ${REGION} | jq .services[].desiredCount`
  echo "Variables DESIRED_COUNT assigned successfully"
  if [ ${DESIRED_COUNT} == "0" ]; then
    DESIRED_COUNT = "1"
  fi
  echo "ecs update-service to be called with REVISON=${REVISION}"
  aws ecs update-service --cluster ${CLUSTER} --region ${REGION} --service ${SERVICE_NAME} --task-definition ${TASK_FAMILY}:${REVISION}  --desired-count ${DESIRED_COUNT} --deployment-configuration maximumPercent=100,minimumHealthyPercent=0 
  echo "ecs update-service called successfully"
else
  echo "entering new service"
  aws ecs create-service  --service-name  ${SERVICE_NAME} --desired-count 1 --task-definition ${TASK_FAMILY} --cluster ${CLUSTER}  --region ${REGION}  
fi 
