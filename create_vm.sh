# Standard VM
gcloud compute instances create <STANDARD_VM_NAME> \
    --project=<YOUR_PROJECT_ID> \
    --zone=<YOUR_ZONE> \
    --machine-type=e2-custom-2-4096 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=<YOUR_SERVICE_ACCOUNT>@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=<STANDARD_VM_NAME>,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250311,mode=rw,size=10,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any \
&& \
printf 'agentsRule:\n  packageState: installed\n  version: latest\ninstanceFilter:\n  inclusionLabels:\n  - labels:\n      goog-ops-agent-policy: v2-x86-template-1-4-0\n' > config.yaml \
&& \
gcloud compute instances ops-agents policies create goog-ops-agent-v2-x86-template-1-4-0-<YOUR_ZONE> \
    --project=<YOUR_PROJECT_ID> \
    --zone=<YOUR_ZONE> \
    --file=config.yaml \
&& \
gcloud compute resource-policies create snapshot-schedule default-schedule-1 \
    --project=<YOUR_PROJECT_ID> \
    --region=<YOUR_REGION> \
    --max-retention-days=14 \
    --on-source-disk-delete=keep-auto-snapshots \
    --daily-schedule \
    --start-time=16:00 \
&& \
gcloud compute disks add-resource-policies <STANDARD_VM_NAME> \
    --project=<YOUR_PROJECT_ID> \
    --zone=<YOUR_ZONE> \
    --resource-policies=projects/<YOUR_PROJECT_ID>/regions/<YOUR_REGION>/resourcePolicies/default-schedule-1

# CPU-Optimized VM
gcloud compute instances create <CPU_VM_NAME> \
    --project=<YOUR_PROJECT_ID> \
    --zone=<YOUR_ZONE> \
    --machine-type=c2d-highcpu-2 \
    --network-interface=network-tier=PREMIUM,stack-type=IPV4_ONLY,subnet=default \
    --metadata=enable-osconfig=TRUE \
    --maintenance-policy=MIGRATE \
    --provisioning-model=STANDARD \
    --service-account=<YOUR_SERVICE_ACCOUNT>@developer.gserviceaccount.com \
    --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/trace.append \
    --create-disk=auto-delete=yes,boot=yes,device-name=<CPU_VM_NAME>,image=projects/debian-cloud/global/images/debian-12-bookworm-v20250311,mode=rw,size=10,type=pd-balanced \
    --no-shielded-secure-boot \
    --shielded-vtpm \
    --shielded-integrity-monitoring \
    --labels=goog-ops-agent-policy=v2-x86-template-1-4-0,goog-ec-src=vm_add-gcloud \
    --reservation-affinity=any \
&& \
gcloud compute disks add-resource-policies <CPU_VM_NAME> \
    --project=<YOUR_PROJECT_ID> \
    --zone=<YOUR_ZONE> \
    --resource-policies=projects/<YOUR_PROJECT_ID>/regions/<YOUR_REGION>/resourcePolicies/default-schedule-1