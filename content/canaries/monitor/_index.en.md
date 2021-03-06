+++
title = "Monitor canary health"
date = 2019-11-11T16:24:12-08:00
weight = 23
+++

Canary deployments are considerably more successful if the code is being monitored during the deployment. You can configure CodeDeploy to automatically roll back the deployment if a specified CloudWatch metric has breached the alarm threshold. Common metrics to monitor are Lambda Invocation errors or Invocation Duration (latency), for example.

### Define a CloudWatch Alarm

Add the following alarm definition to the `template.yaml` file in the _Resources_ section after the _HelloWorldFunction_ definition. 

```
CanaryErrorsAlarm:
 CanaryErrorsAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmDescription: Lambda function canary errors
      ComparisonOperator: GreaterThanThreshold
      EvaluationPeriods: 2
      MetricName: Duration
      Namespace: AWS/Lambda
      Period: 60
      Statistic: Maximum
      Threshold: 7500
      Dimensions:
        - Name: Resource
          Value: !Sub "${HelloWorldFunction}:live"
        - Name: FunctionName
          Value: !Ref HelloWorldFunction
        - Name: ExecutedVersion
          Value: !GetAtt HelloWorldFunction.Version.Version```
```

And then add the following lines to the _DeploymentPreference_ section of the _HelloWorldFunction_ definition. 

```
Alarms:
    - !Ref CanaryErrorsAlarm
```

Your `template.yaml` should look like this:  

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Description: >
  sam-app

  Sample SAM Template for sam-app-java11

# More info about Globals: https://github.com/awslabs/serverless-application-model/blob/master/docs/globals.rst
Globals:
  Function:
    Timeout: 20

Resources:
  HelloWorldFunction:
    Type: AWS::Serverless::Function # More info about Function Resource: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#awsserverlessfunction
    Properties:
      CodeUri: HelloWorldFunction
      Handler: helloworld.App::handleRequest
      Runtime: java11
      AutoPublishAlias: live
      DeploymentPreference:
        Type: Linear10PercentEvery1Minute
        Alarms:
          - !Ref CanaryErrorsAlarm

      MemorySize: 512
      Environment: # More info about Env Vars: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#environment-object
        Variables:
          PARAM1: VALUE
      Events:
        HelloWorld:
          Type: Api # More info about API Event Source: https://github.com/awslabs/serverless-application-model/blob/master/versions/2016-10-31.md#api
          Properties:
            Path: /hello
            Method: get
      
  CanaryErrorsAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmDescription: Lambda function canary errors
      ComparisonOperator: GreaterThanThreshold
      EvaluationPeriods: 2
      MetricName: Duration
      Namespace: AWS/Lambda
      Period: 60
      Statistic: Maximum
      Threshold: 7500
      Dimensions:
        - Name: Resource
          Value: !Sub "${HelloWorldFunction}:live"
        - Name: FunctionName
          Value: !Ref HelloWorldFunction
        - Name: ExecutedVersion
          Value: !GetAtt HelloWorldFunction.Version.Version

Outputs:
  # ServerlessRestApi is an implicit API created out of Events key under Serverless::Function
  # Find out more about other implicit resources you can reference within SAM
  # https://github.com/awslabs/serverless-application-model/blob/master/docs/internals/generated_resources.rst#api
  HelloWorldApi:
    Description: "API Gateway endpoint URL for Prod stage for Hello World function"
    Value: !Sub "https://${ServerlessRestApi}.execute-api.${AWS::Region}.amazonaws.com/Prod/hello/"
  HelloWorldFunction:
    Description: "Hello World Lambda Function ARN"
    Value: !GetAtt HelloWorldFunction.Arn
  HelloWorldFunctionIamRole:
    Description: "Implicit IAM Role created for Hello World function"
    Value: !GetAtt HelloWorldFunctionRole.Arn
``` 

### Validate the SAM template
Run the following command on your terminal: 

```
cd ~/environment/sam-app
sam validate
```

If the template is correct, you will see `template.yaml is a valid SAM Template`. If you see an error, then you likely have an indentation issue on the YAML file. Double check and make sure it matches the screenshot shown above.

### Push the changes

In the terminal, run the following commands from the root directory of your `sam-app` project.

```
git add .
git commit -m "Added CloudWatch alarm to monitor the canary"
git push
```