# Install Python venv
sudo apt install python3-venv -y

# Create and activate virtual environment on the disk
python3 -m venv <MOUNT_POINT>/env
sudo chown -R $USER:$USER <MOUNT_POINT>/env
source <MOUNT_POINT>/env/bin/activate

# Install requirements
pip install -r <MOUNT_POINT>/GCP_Lab/requirements.txt

# Set VM type and run the script
# For Standard VM:
export VM_TYPE="standard"
python3 <MOUNT_POINT>/GCP_Lab/car_price_regressor.py

# For CPU-Optimized VM:
export VM_TYPE="cpu_optimized"
python3 <MOUNT_POINT>/GCP_Lab/car_price_regressor.py