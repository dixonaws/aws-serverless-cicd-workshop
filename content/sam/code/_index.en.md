+++
title = "Explore the Lambda code"
date = 2019-10-02T15:21:26-07:00
weight = 15
+++

{{% notice note %}}
If you consider yourself an expert using Lambda functions, you can probably skip this page.
{{% /notice%}}

Let's take a look at the code of the Hello World Lambda function. Open the file `App.java` under the `HelloWorldFunction/src/main/java/helloworld` folder. **Note** that your function may have additional commented out code, those lines have been removed from the following example for clarity:

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

### The Lambda handler
The handler is the method in your Lambda function that processes events. When you invoke a function, the
 runtime runs the handler method. When the handler exits or returns a response, it becomes 
 available to handle another event. In this case, the lambda handler is the `handleRequest` function, as 
 specified in the SAM `template.yaml`. 

{{% notice tip %}}
Because the Lambda handler is executed on every invocation, a best practice is to place code that can 
be reused across invocations outside of the handler scope. A common example is to initialize 
database connections outside of the handler.
{{% /notice%}}

#### Event object
The first argument passed to the handler function is the `event` object, which contains information 
from the invoker. In this case, the invoker is API Gateway, which passes the HTTP request 
information as a JSON-formatted string, and the Lambda runtime converts it to an 
object. You can find examples of event payloads here: [https://docs.aws.amazon.com/lambda/latest/dg/lambda-services.html](https://docs.aws.amazon.com/lambda/latest/dg/lambda-services.html)

#### Context object
The second argument is the context object, which contains information about the invocation, function, and execution environment. You can get information like the CloudWatch log stream name or the remaining execution time for the function.

#### Handler Response
API Gateway expects the handler to return a response object that contains _statusCode_ and _body_, but it can also contain optional _headers_. 