import time
import os
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, mean_absolute_error, r2_score

# Load dataset
data_url = "carprice_dataset.csv"
car_data = pd.read_csv(data_url)

# Select features
features = ['year', 'km_driven', 'mileage(km/ltr/kg)', 'engine', 'max_power', 'seats']
target = 'selling_price'

# Coerce feature columns to numeric
for col in features + [target]:
    car_data[col] = pd.to_numeric(car_data[col], errors='coerce')

# Drop rows with missing values
cleaned_data = car_data.dropna(subset=features + [target])

# Split features and target
X = cleaned_data[features]
y = cleaned_data[target]

# 80/20 Train and test split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
start_train = time.time()
model = RandomForestRegressor(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
end_train = time.time()

# Run inference
start_pred = time.time()
predictions = model.predict(X_test)
end_pred = time.time()

# Calculate metrics
mse = mean_squared_error(y_test, predictions)
mae  = mean_absolute_error(y_test, predictions)
r2   = r2_score(y_test, predictions)
training_time = round(end_train - start_train, 4)
inference_time = round(end_pred - start_pred, 4)

print(f"Training Time  : {training_time} seconds")
print(f"Inference Time : {inference_time} seconds")
print(f"MSE            : {round(mse, 2)}")
print(f"MAE            : {round(mae, 2)}")
print(f"R² Score       : {round(r2, 4)}")

# VM type
vm_type = os.environ.get("VM_TYPE", "unknown")

# Save metrics to CSV on the disk
metrics_path = "/mlops-disk/metrics.csv"
write_header = not os.path.exists(metrics_path)

with open(metrics_path, "a") as f:
    if write_header:
        f.write("vm_type,training_time_sec,inference_time_sec,mse, mae, r2\n")
    f.write(f"{vm_type},{training_time},{inference_time},{round(mse, 2)}, {round(mae, 2)}, {round(r2, 4)}\n")

print(f"\nMetrics saved to {metrics_path}")