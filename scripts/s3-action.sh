#!/bin/bash

op=$1

get_bucket_name() {
  local bucket_name
  bucket_name=$(jq -r '.outputs.s3_bucket_name.value' terraform/terraform.tfstate)
  echo "$bucket_name"
}

check_bucket_name() {
  local bucket_name="$1"
  if [ -z "$bucket_name" ]; then
    echo "Error: bucket_name is empty"
    exit 1
  fi
}

sync_to_s3() {
  local bucket_name="$1"
  aws s3 sync app/Boilerplate/build "s3://$bucket_name"
}

remove_from_s3() {
  local bucket_name="$1"
  aws s3 rm --recursive "s3://$bucket_name"
}

# Main script logic
case "$op" in
  "sync")
    bucket_name=$(get_bucket_name)
    check_bucket_name "$bucket_name"
    sync_to_s3 "$bucket_name"
    ;;
  "rm")
    bucket_name=$(get_bucket_name)
    check_bucket_name "$bucket_name"
    remove_from_s3 "$bucket_name"
    ;;
  *)
    echo "Error: invalid operation"
    exit 1
    ;;
esac
