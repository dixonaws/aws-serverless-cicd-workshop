+++
title = "Initialize project"
date = 2019-10-02T14:22:32-07:00
weight = 5
+++

AWS SAM provides you with a command line tool, the AWS SAM CLI, that makes it easy for you to create and manage serverless applications. It particularly makes easy the scaffolding of a new project, as it creates the initial skeleton of a hello world application, so you can use it as a baseline and continue building your project from there. 

Run the following command to scaffold a new project:
```bash
sam init
```

It will prompt for project configuration parameters: 

1. Type `1` to select AWS Quick Start Templates
![samInit](/images/screenshot-sam-init-1.png)

2. Choose `Java 11` (5) for runtime

3. Choose `maven` for the dependency manager

4. Leave default `sam-app` for project name

5. Type `Y` to accept download from GitHub

- The template wil be downloaded from the github template repository.

6. Type `1` to select the `Hello World Example`


{{% notice tip %}}
This command supports cookiecutter templates, so you could write your own custom scaffolding templates and specify them using the location flag, For example: sam init --location git+ssh://git@github.com/aws-samples/cookiecutter-aws-sam-python.git.
{{% /notice%}}

## Project should now be initialized

You should see a new folder `sam-app` created with a basic Hello World scaffolding.
![samInit](/images/screenshot-sam-init-7.png)

If you are interested in learning more about initializing SAM projects, you can find the full reference for the `sam init` command in the [SAM CLI reference](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-cli-command-reference-sam-init.html).