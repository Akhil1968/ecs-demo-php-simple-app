docker build -t tinyapp:v_$BUILD_NUMBER --pull=true /var/lib/jenkins/workspace/tinyapp   \
&& $(aws ecr get-login --no-include-email --region us-west-2) \
&&  docker tag tinyapp:v_$BUILD_NUMBER 786148255523.dkr.ecr.us-west-2.amazonaws.com/tinyapp:v_$BUILD_NUMBER   \
&&  docker push 786148255523.dkr.ecr.us-west-2.amazonaws.com/tinyapp:v_$BUILD_NUMBER 