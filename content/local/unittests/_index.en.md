+++
title = "Run the unit tests"
date = 2019-10-03T09:05:09-07:00
weight = 20
+++

As you typically would, with any software project, running the unit tests locally is no different for 
Serverless applications. Developers run them before pushing changes to a code repository. So, 
go ahead and run the unit tests for your project.

In the terminal, run this command from the `sam-app/HelloWorldFunction` folder to run the unit tests:

```
cd ~/environment/sam-app/HelloWorldFunction
mvn test
```

The tests should fail. This is expected!

### Fix the unit test
Makes sense right? We changed the response message to **hello my friend** and the unit test was expecting **hello world**. This is an easy fix, let's update the unit test. 

Open the file `sam-app/HelloWorldFunction/src/test/java/helloworld` and update the expected value for the response 
to match the new message. The unit test should look like this after the update:

```
package helloworld;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import org.junit.Test;

public class AppTest {
  @Test
  public void successfulResponse() {
    App app = new App();
    GatewayResponse result = (GatewayResponse) app.handleRequest(null, null);
    assertEquals(result.getStatusCode(), 200);
    assertEquals(result.getHeaders().get("Content-Type"), "application/json");
    String content = result.getBody();
    assertNotNull(content);
    assertTrue(content.contains("\"message\""));
    assertTrue(content.contains("\"hello my friend\""));
  }
   
}
```

### Run the tests again
Run the same command again.

```
mvn test
```

Now the tests should pass:


{{% notice note %}}
This project uses the [jUnit Framework](https://www.junit.org) for running the unit tests, but you can chose 
any other framework. SAM doesn't enforce any particular one. You can continue to have the 
same unit testing workflow that you do in a non-serverless application.
{{% /notice%}}