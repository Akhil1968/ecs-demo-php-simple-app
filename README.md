# Amazon ECS PHP App with jenkins based CICD pipeline

This document aims to create a CICD pipeline for a development environment wherein 
  -your source code (a simple PHP web application) resides in your Github account, 
  -the code is dockerized and 
  -it runs in an AWS ECS cluster. 

The CICD pipeline is established by jenkins running in an EC2 standalone instance.
Architecture Sketch: https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/App-arch.png

This document is based on: 
      Amazon Codebase:   https://github.com/aws-samples/ecs-demo-php-simple-app
      Directions on how to run this sample app on Amazon ECS can be found in the documentation: [Docker       basics]
      http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html

# Here are the steps----

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

Step 4: Check that your ECS cluster is running your container instances, service and task(s). For this paste the DNS URL of load balancer in your browser's address bar.

Step 5: Use the same EC2 standalone instance (created in Step 1) to setup Jenkins for CICD pipeline. 
    Make sure the security group allows access to http ports 80 and 8080.  
    Instructions: https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/install-jenkins.txt
    
Step 6: Login to Jenkins server using your browser and install standard jenkins plugins. 

Create a new jenkins job in which under source code management section provide the Github URL https://github.com/Akhil1968/ecs-demo-php-simple-app.git. 

In the same jenkins job under build section add two excute shell scripts. First shell script is a build script which pulls PHP source code from github, builds docker image and pushes it to the ECR registry. The Build Shell script is available here- https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/build.sh.

The other shell script is a deployment shell script which updates the ECS service. The code for the deploy shell script is here- https://github.com/Akhil1968/ecs-demo-php-simple-app/blob/master/deploy.sh.
            
Step 7: Test the jenkins job by clicking "Build Now" link the the jenkins job created in the previous step.

Step 8: This step and the next will fully automate the CICD pipeline, so that when any code commit happens in your GitHub account, 
     the jenkin server gets triggered which in turn creates a new docker image, pushes it to ECR and updates th ECS service. 
    
      Execute the following sub-steps to achieve this automation -
        -install Jenkins plugin in github by going to setings page and then clicking "Integrations and Services" link on left panel.
        -Search for "Jenkins" plugin in "available pluins" tab. Choose it and provide the URL of your jenkins server using the URL x.x.x.x:8080/github-webhook/. This will trigger the jenkins server upon any code commit to the current repository.
        
Step 9: Setup jenkins server to respond to GitHub trigger. 
      -Login to your jenkins account and go to Manage Jenkins-->Manage Plugins page. Install "Github Integration plugin" and restart jenkins. 
      - After jenkins restarts, open you jenkins job and then click the configure link on left panel. In  "General" tab of the Configure page, provide Github project URL. Under "Buid Triggers" tab, check the checkbox "GitHub hook trigger for GITScm polling".  Click Apply and Save.
      
 Step 10: Go to your github repository and make a code change. Check your service in ECS and see that it goes through 6 events. Your applications web page will be down for some time (5 mins approx). When your ECS sevice's Events tab shows this status "service xxxx has reached a steady state", your webpage starts working. :)
 
            
    
