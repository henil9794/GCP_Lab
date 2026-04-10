gcloud compute disks create vm1-gcplab-disk \
    --project=YOUR_PROJECT_ID \
    --type=pd-ssd \
    --size=10GB \
    --resource-policies=projects/YOUR_PROJECT_ID/regions/us-central1/resourcePolicies/default-schedule-1 \
    --zone=us-central1-a