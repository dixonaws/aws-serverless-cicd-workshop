+++
title = "Make a code change"
date = 2019-10-03T08:52:21-07:00
weight = 15
+++

Open the file `sam-app/HelloWorldFuction/src/main/java/helloworld/App.java` and make a simple code change. For 
example, change the response message to return `hello my friend` instead of _hello world_. 

**Note: Make sure you save the file after changing it.**

When using Python or Node, you don't have to restart the `sam local` process, just refresh the browser 
tab or re-trigger the CURL command to see the changes reflected in your endpoint. However, when using Java, you will need
to rebuild the module with ```sam build``` for ech change.
![SamLocalCodeChange](/images/screenshot-samlocal-code-change.png)

{{% notice tip %}}
You also need to restart `sam local` if you change the `template.yaml`.
{{% /notice%}}
