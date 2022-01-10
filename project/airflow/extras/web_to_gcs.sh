dataset_url=${dataset_url}
dataset_file=${dataset_file}
path_to_local_file=${path_to_local_file}
path_to_creds=${path_to_creds}

curl -sS "$dataset_url" > $path_to_local_file/$dataset_file
gcloud auth activate-service-account --key-file=$path_to_creds
gsutil -m cp $path_to_local_file/$dataset_file gs://$BUCKET
