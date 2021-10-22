#!/bin/bash

AWS_BUCKET=$1
SEEDCODE_PATH="awsome-sagemaker-projects-templates/seedcodes"

echo $FULL_PATH

if [ -z "$1" ]
then
    echo "[ERROR] Please run sh init.sh <BUCKET_NAME>"
    exit
fi

mkdir -p outputs
cd 'seedcode/async-inference/'; zip -qr9 ../../outputs/async-seedcode.zip .
cd '../../seedcode/batch-inference/'; zip -qr9 ../../outputs/batch-seedcode.zip .
cd '../../seedcode/realtime-inference/'; zip -qr9 ../../outputs/realtime-seedcode.zip .

cd ../..
for filename in outputs/*.zip; do
    aws s3 cp $filename s3://$AWS_BUCKET/$SEEDCODE_PATH/$filename --quiet
done
echo "Upload of seedcodes successful."


sed -i "" "s|<#####BUCKET-PLACEHOLDER#####>|$AWS_BUCKET|" "./template.yml"
sed -i "" "s|<#####FILE-PATH-PLACEHOLDER#####>|$SEEDCODE_PATH|" "./template.yml"
echo "Update of the template file complete."