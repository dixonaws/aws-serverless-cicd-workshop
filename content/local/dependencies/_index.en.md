+++
title = "Build Java Module"
date = 2019-10-02T16:20:25-07:00
weight = 5
+++

Before we run the application locally, we need to build it. The dependencies are managed by maven in our case (pom.xml). 
In general, dependencies are defined in a file that varies depending on the runtime, for example _package.json_ for NodeJS 
projects or _requirements.txt_ for Python ones. 

In the terminal, go into the `sam-app/HelloWorldFunction` directory (the directory that contains the pom.xml file).
```
cd sam-app/HelloWorldFunction
```

And install the dependencies:
```
sam build
```

