# Amazon ECS PHP App with jenkins based CICD pipeline

This document aims to create a CICD pipeline for a development environment wherein 
  -your source code (a simple PHP web application) resides in your Github account, 
  -the code is dockerized and 
  -it runs in an AWS ECS cluster. 

The CICD pipeline is established by jenkins running in an EC2 standalone instance.

This document is based on: 
      Amazon Codebase:   https://github.com/aws-samples/ecs-demo-php-simple-app
      Directions on how to run this sample app on Amazon ECS can be found in the documentation: [Docker       basics]
      http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html

Here are the steps----

Step 1: Create an ECR repository in AWS ECS. This repository is going to store your docker images.

Step 2: Create an EC2 instance based on an Amazon Linux instance AMI. 
      This standalone EC2 instance will be used to build docker image and push the image to ECR. 
      Instructions: https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/install-docker-git.txt

Step 3: Create a VPC with a couple of public subnets. Within that VPC, create the following-
    -an ECS Cluster, 
    -an ECS Task defition(using the docker image pushed in ECR in step 1), 
    -a task, 
    -a load balancer and 
    -an ECS service. 

Step 4: Check that your ECS cluster is running your container instances, service and task(s). 
    Also check that you are able to access your tasks using the load balancer DNS URL.

Step 5: Use the same EC2 standalone instance (created in Step 1) to setup Jenkins for CICD pipeline. 
    Make sure the security group allows access to http ports 80 and 8080.  
    Instructions: https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/install-jenkins.txt
    
Step 6: Login to Jenkins server using your browser. 
    - install standard jenkins plugins
    - Create a new jenkins job in which
        -- provide the Github URL https://github.com/Akhil1968/ecs-demo-php-simple-app.git
        -- add two excute shell scripts
            --- one for pulling building PHP source code from github, building docker image and pushing it to the ECR registry created in the first step. Build Shell script code- https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/build.sh.
            --- the other shell script is a deployment shell script which updates the ECS service. The code for the deploy shell script is here- https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/deploy.sh.
            
Step 7: Test the jenkins job by clicking "Build Now" link the the jenkins job created in the previous step.

Step 8: This step will fully automate the CICD pipeline, so that when any code commit happens in your GitHub account, 
     the jenkin server gets triggered which in turn creates a new docker image, pushes it to ECR and updates th ECS service. 
    For this -
        -install Jenkins plugin in github and provide the URL of your jenkins server in your github account. 
         This will trigger the jenkins server.
        -setup jenkins server to respond to GitHub trigger.
            
    
