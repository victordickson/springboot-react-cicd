# react-and-spring-data-rest

The application has a react frontend and a Spring Boot Rest API, packaged as a single module Maven application. You can build the application using maven and run it as a Spring Boot application using the flat jar generated in target (`java -jar target/*.jar`). The steps below demostrates how to automate its deployment to Google cloud. 

# Getting Started
---
1. First, enable the required APIs
```
gcloud services enable cloudbuild.googleapis.com run.googleapis.com containerregistry.googleapis.com
```
2. Next, change into the terraform directory, create .tfvars and populate it with the required values. Then run the following;
```
terraform init && terraform validate
terraform apply -auto-approve
```
3. Adjust the application.properties, the value for spring.cloud.gcp.sql.instance-connection-name should be in the following format `PROJECT-ID:REGION:INSTANCE-NAME`

4. Configure the service account used by Cloud Run so that it has the Cloud SQL Client role with permissions to connect to Cloud SQL.
- Run the following gcloud command to get a list of your project's service accounts:

```
gcloud iam service-accounts list
```
- Copy the EMAIL of the Compute Engine service account.
- Run the following command to add the Cloud SQL Client role to Compute Engine service account
```
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:SERVICE_ACCOUNT_EMAIL" \
  --role="roles/cloudsql.client"
```

5. Adjust the cloudbuild.yaml accordingly. Change to the project directory and run the following command;
```
gcloud builds submit
```
The above command does the following;
- Builds the docker image from the current Dockerfile
- Pushes the docker image to the google cloud container registry
- Deploys image to Google Cloud Run service.

6. Navigate to google cloud console, access Cloud Run service and copy the URL. Paste it on a browser and access the application. Login with `greg/turnquist`
---
# Cleaning up
---
1. Run the following command to destroy the database instance
```
terraform destroy -auto-approve
```
2. Navigate to the Cloud Run service and delete it. 