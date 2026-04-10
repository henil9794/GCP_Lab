# Attach disk to Standard VM
gcloud compute instances attach-disk <STANDARD_VM_NAME> \
    --disk=<DISK_NAME> \
    --zone=<YOUR_ZONE>

# Format, mount and set permissions (run inside Standard VM)
sudo mkfs.ext4 -F /dev/sdb
sudo mkdir <MOUNT_POINT>
sudo mount /dev/sdb <MOUNT_POINT>
sudo chown <YOUR_USERNAME> <MOUNT_POINT>

# Copy lab files to the disk (run from local machine)
scp -r GCP_Lab/ <YOUR_USERNAME>@<STANDARD_VM_EXTERNAL_IP>:<MOUNT_POINT>

# Detach disk from Standard VM before attaching to CPU-Optimized VM
gcloud compute instances detach-disk <STANDARD_VM_NAME> \
    --disk=<DISK_NAME> \
    --zone=<YOUR_ZONE>

# Attach disk to CPU-Optimized VM
gcloud compute instances attach-disk <CPU_VM_NAME> \
    --disk=<DISK_NAME> \
    --zone=<YOUR_ZONE>

# Mount disk on CPU-Optimized VM (run inside CPU-Optimized VM)
sudo mkdir <MOUNT_POINT>
sudo mount /dev/sdb <MOUNT_POINT>