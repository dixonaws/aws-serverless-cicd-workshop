#!/bin/bash

git add .
git commit -m "Cleanup of instructions"
git push
hugo
cd public
aws s3 sync . s3://www.dixonaws.com/aws-serverless-cdci-workshop/
cd ..
aws cloudfront create-invalidation --distribution-id "E1ZEGQOWEQTU7I" --paths "/*"
