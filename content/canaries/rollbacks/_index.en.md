+++
title = "Rollbacks"
date = 2019-11-12T08:00:36-08:00
weight = 30
+++

Monitoring the health of your canary allows CodeDeploy to make a decision to whether a rollback 
is needed or not. If any of the CloudWatch Alarms specified gets to ALARM status, CodeDeploy 
will roll back the deployment automatically. 

### Introduce an error on purpose

Lets break the Lambda function on purpose so that the _CanaryErrorsAlarm_ gets triggered during deployment. Update the lambda code to throw an error on every invocation, like this:

First, lets introduce a method called wait(), as below:

```
public static void wait(int ms){
        try
        {
            Thread.sleep(ms);
        }
        catch(InterruptedException ex)
        {
            Thread.currentThread().interrupt();
        }
    }
```

Let us have your handleRequest method wait for 10,000ms on each request. Doing this will trigger an alarm in Cloudwatch and 
automatically roll back our deployment.

```
    wait(10000)
```

 
Your App.java should look like this when finished:
```
package helloworld;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

/**
 * Handler for requests to Lambda function.
 */
public class App implements RequestHandler<Object, Object> {

    public Object handleRequest(final Object input, final Context context) {
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");
        try {
            final String pageContents = this.getPageContents("https://checkip.amazonaws.com");
            String output = String.format("{ \"version\": \"3.0 (intential latency)\", \"message\": \"hello world, my friends!\", \"location\": \"%s\", \"metadata\": \"please deploy all changes through codepipeline for maximum reliability.\" }", pageContents);
            
            // interntionally introduce latency
            wait(10000);
            
            return new GatewayResponse(output, headers, 200);
        } catch (IOException e) {
            return new GatewayResponse("{}", headers, 500);
        }
    }


    private String getPageContents(String address) throws IOException{
        URL url = new URL(address);
        try(BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream()))) {
            return br.lines().collect(Collectors.joining(System.lineSeparator()));
        }
    }
    
    public static void wait(int ms){
        try
        {
            Thread.sleep(ms);
        }
        catch(InterruptedException ex)
        {
            Thread.currentThread().interrupt();
        }
    }
}

```

### Push the changes

In the terminal, run the following commands from the root directory of your `sam-app` project.

```
git add .
git commit -m "Breaking the lambda function on purpose"
git push
```