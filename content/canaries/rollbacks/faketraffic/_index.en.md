+++
title = "Invoke the canary"
date = 2019-11-12T13:21:47-08:00
weight = 10
+++

**While the deployment is running**, you need to generate traffic to the new Lambda function to make it fail and trigger the CloudWatch Alarm. In a real production environment, your users will likely generate organic traffic to the canary function, so you may not need to do this.

In your terminal, run the following command to invoke the Lambda function:

```
aws lambda invoke --function-name <your-function-name> --payload '{}' response.json
```

Example: 

**Remember:** During deployment, only 10% of the traffic will be routed to the new version. So, **keep on invoking your lambda many times**. 1 out of 10 invocations should trigger the new broken lambda, which is what you want to cause a rollback.

Here is a command that invokes your function every 2 seconds. Feel free to run it in your terminal.

```
counter=1
while [ $counter -le 15 ]
do
    aws lambda invoke --function-name <your-java-function> --payload '{}' response.json
    sleep 1
    ((counter++))
done
```