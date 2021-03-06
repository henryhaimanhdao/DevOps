# Create The Server 1.0
## 1. Use AWS EC2 (Elastic Compute Cloud)
* With the free trial, one can have access to 750 hours of AWS EC2
* Tons of documentation available with EC2, which means beginners have resources
## 2. Configuration 
### Step 0:
* On the EC2 Dashboard, one can go launch an instance

![image](https://user-images.githubusercontent.com/80073478/110174493-31f7f200-7dce-11eb-8560-d4a2cd5039de.png)

### Step 1: Choose AMI
* One can choose their AMI. In this case, I chose the free tier Amazon Linux 2 AMI

![image](https://user-images.githubusercontent.com/80073478/110174782-a6cb2c00-7dce-11eb-8fb2-4c57ecfcc959.png)

### Step 2: Choose Instance Type
* One can choose their Instance Type, I chose the free tier t2.micro option

![image](https://user-images.githubusercontent.com/80073478/110175165-53a5a900-7dcf-11eb-9ab8-36f6ea43540a.png)

### Step 3: Configure Instance
* When Configuring Instance Details, one can keep everything default, except the User Data option in Advanced Details, one can incorporate a bash script inside that part and when done right, one can create a NGINX server with the proper commands. Go to **Create the Server 1.1** for more info on what I tried to do.


![image](https://user-images.githubusercontent.com/80073478/110175534-e8a8a200-7dcf-11eb-8bfa-d245fe7a44d9.png)



### Step 4: Add Storage
* Keep settings default and move to next step

### Step 5: Add tags
* Make any key-value tag one wants

### Step 6: Configure Security Group 
* One wants to add a HTTP Type rule with the Port range 80, so NGINX can run on the localhost properly 

![image](https://user-images.githubusercontent.com/80073478/110176006-a338a480-7dd0-11eb-96fa-bba12587b9bb.png)

### Step 7: Select an Existing Key Pair or Create a New Key Pair
* You can choose based on preference

![image](https://user-images.githubusercontent.com/80073478/110176251-00345a80-7dd1-11eb-8409-a7aa0d8e7170.png)

### Step 8: Checking if Server is Running

* Go to Instances under Instances tab

![image](https://user-images.githubusercontent.com/80073478/110176879-00812580-7dd2-11eb-84c6-9a9308a0443c.png)

* Go to your Instance Summary and go to your Public IPv4 DNS, If it launches you to your NGINX server, you did it ! If it doesnt, then one has to retrace their steps.

![image](https://user-images.githubusercontent.com/80073478/110177363-d8de8d00-7dd2-11eb-90f7-fb51fbc9b295.png)

* Public NGINX server that I worked on:

[http://ec2-3-14-69-163.us-east-2.compute.amazonaws.com/](http://ec2-3-14-69-163.us-east-2.compute.amazonaws.com/)

* One should see this site if everything worked out:

![image](https://user-images.githubusercontent.com/80073478/110183911-e77e7180-7ddd-11eb-9034-28b9eee5eed7.png)


# Create The Server 1.1 (What I Did Instead/Mistakes)
* First I manually installed the NGINX server using this code on the Public working NGINX Server with

The commands are:
```
#To become root user in bash for preference
sudo bash

#Intalls nginx
amazon-linux-extras install -y nginx

#Starts NGINX 
service nginx start

#Still runs after reboot
service nginx enable

#Too see if localhost(Public DNS) is running
curl localhost
```
* This worked manually, my thought process was if I can do this manually then running it as a basic bash script in the User Data for **Step3: Configure Instance** should work accordingly. Unfortunately I was wrong, and nothing I did worked. There is definitely a gap of knowledge that I am missing and/or some mistakes that I will learn to fix down the line.

**Trial Scripts for User Data:**
```
#Trial 1
#Userdata already runs everything in sudo, so this is redundant
#!/bin/bash
sudo su
yum update -y
sudo amazon-linux-extras list | grep nginx
sudo amazon-linux-extras enable nginx1
sudo amazon-linux-extras install -y nginx1
sudo service nginx1 start                     

#Trial 2
#!/bin/bash
sudo bash 
sudo amazon-linux-extras install -y nginx
sudo service nginx start 
sudo Curl localhost 

#Trial 3
#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx
service nginx start 
service nginx enable
curl localhost

#Trial 4
#!/bin/bash
yum update -y
amazon-linux-extras install -y nginx
systemctl start nginx
systemctl enable nginx

#Trial 5
#!/bin/bash
bash
amazon-linux-extras install -y nginx
service nginx start
service nginx enable
```
# Run Checker Script

Inside the working NGINX Server, one can access it through **EC2 Instance Connect**

![image](https://user-images.githubusercontent.com/80073478/110181957-4e019080-7dda-11eb-985c-cb3cbb050d5d.png)

Inside the instance, I created a bash script that can be run periodically (and externally) to check if the server is up and serving the expected version number. 
```
#!/bin/bash
while systemctl status nginx && nginx -v ; 
do sleep 10; 
done

#end
```
**To add the bash scipt:**

```
vi checkversion.sh
#in the text editor add the script above

#After run this command to make the script executable 
chmod +x checkversion.sh 

#Run this to execute the code(Have to be in the right directory)
./checkversion.sh
```
**What it did:**
This script shows you if NGINX is running and it's version every 10 seconds. Of course every 10 seconds was just for an immediate response to see if the script was working. One can definitely change the 10 seconds to any time that they want, or one can use a cron tab to display this script for a certain time for any minute/hour/day/month/week/month/year that they desire.
![image](https://user-images.githubusercontent.com/80073478/110182680-41ca0300-7ddb-11eb-9187-4309f90ccb92.png)

* If one SSH into this instance with the root user, I believe the script would still be running relaying to the user if NGINX is running/it's version, if the script has not been stopped

# /version.txt

*Could not git add my /version.txt

![image](https://user-images.githubusercontent.com/80073478/110187145-4c899580-7de5-11eb-8acb-c9f623ef819f.png)
