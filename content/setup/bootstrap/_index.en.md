+++
title = "Upgrade SAM CLI"
date = 2019-10-16T16:29:54-07:00
weight = 10
+++

One of the tools this workshop relies on, is the AWS SAM Command Line Interface. However, we need a newer version 
than what Cloud9 has pre-installed. The version we are targetting is **SAM CLI, version 0.31.1 or greater**. We will also need
to install a JDK and Maven (tested with Amazon Corretto Java 11).

{{% notice warning %}}   
Important: Before running this script, wait until the Cloud9 instance is fully initialized and ready. Head over to the EC2 console and 
you will see that the Cloud9 instace is named *aws-cloud9-<label>-<random string>*. Wait until instance state is *Running* and 
*2/2 Checks Complete*.
{{% /notice %}}


### Bootstrap Script

We have put together a bootstrap script that will make the upgrade easier for you. Download it by running the 
following command from your Cloud9 terminal. 

```
wget -O - https://raw.githubusercontent.com/dixonaws/aws-serverless-cicd-workshop/master/bootstrap.sh |bash
```

**THIS MAY TAKE A FEW MINUTES TO COMPLETE.**

Example output: 
![BootstrapScreenshot](/images/screenshot-bootstrap.png)

Once the script has finished, close the terminal window and open a new one. 


### Verify the new version

Run the following command: 

```
sam --version
```

You should see *SAM CLI, version 0.31.1* or greater.

```
java -version
```

You should see *OpenJDK Runtime Environment Corretto-11.0.6.10.1* or similar.

```
mvn -version
```

You should see *Maven version 3.6.3* or greater. 