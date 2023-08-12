#!/bin/sh

KEY=$(jq -r .awskey /data/options.json)
SECRET=$(jq -r .awssecret /data/options.json)
BUCKET=$(jq -r .bucketname /data/options.json)
DELETE=$(jq -r .delete /data/options.json)  # Renamed from MIRROR
STORAGE_CLASS=$(jq -r '.storage_class // "STANDARD"' /data/options.json)

now="$(date +'%d/%m/%Y - %H:%M:%S')"

echo $now

aws configure set aws_access_key_id $KEY
aws configure set aws_secret_access_key $SECRET

delete_option=""
if [ "$DELETE" = "true" ]; then
  delete_option="--delete"
fi

aws s3 sync $delete_option --storage-class $STORAGE_CLASS /backup/ s3://$BUCKET/
echo "Done"
