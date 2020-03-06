+++
title = "Invoke the canary"
date = 2019-11-12T13:21:47-08:00
weight = 10
+++

**While the deployment is running**, you need to generate traffic to the new Lambda function to make it fail and trigger the CloudWatch Alarm. In a real production environment, your users will likely generate organic traffic to the canary function, so you may not need to do this.

In your terminal (local or Cloud9), run the following command to invoke the Lambda function:

```
watch -d "curl -X GET <your API gateway URL>"
```

Your API will be invoked once every 2 seconds. 

![PreviewSamLocal](/images/screenshot-faketraffic.png)

Example: 

**Remember:** During deployment, only 10% of the traffic will be routed to the new version. So, **keep on invoking your lambda many times**. 1 out of 10 invocations should trigger the new broken lambda, which is what you want to cause a rollback.

