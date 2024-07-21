!/bin/sh

# Fetch the secret from Google Cloud Secret Manager
SECRET_NAME="projects/weighty-vertex-429415-t2/secrets/REACT_APP_DROPBOX_ACCESS_TOKEN/versions/latest"
ACCESS_TOKEN=$(curl -s -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" "https://secretmanager.googleapis.com/v1/${SECRET_NAME}:access" | jq -r .payload.data | base64 --decode)

# Export the secret as an environment variable
export REACT_APP_DROPBOX_ACCESS_TOKEN=$ACCESS_TOKEN

# Set the port environment variable
export PORT=8080

# Start the application
serve -s build -l $PORT