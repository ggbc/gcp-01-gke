import os
import pickle
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from google.cloud import storage

# Dados sintéticos de qualidade de combustível
data = {
    'density': [0.85, 0.87, 0.83, 0.86, 0.84, 0.88, 0.82, 0.85, 0.86, 0.83,
                0.87, 0.84, 0.85, 0.83, 0.86, 0.88, 0.82, 0.84, 0.85, 0.87],
    'viscosity': [2.1, 2.5, 1.9, 2.3, 2.0, 2.7, 1.8, 2.2, 2.4, 2.0,
                  2.6, 2.1, 2.3, 1.9, 2.4, 2.8, 1.7, 2.0, 2.2, 2.5],
    'sulfur_content': [0.05, 0.08, 0.03, 0.06, 0.04, 0.09, 0.02, 0.05, 0.07, 0.03,
                       0.08, 0.04, 0.06, 0.03, 0.07, 0.10, 0.02, 0.04, 0.05, 0.08],
    'temperature': [15, 18, 12, 16, 14, 20, 11, 15, 17, 13,
                    19, 14, 16, 12, 17, 21, 10, 13, 15, 18],
    'quality': ['good', 'bad', 'good', 'good', 'good', 'bad', 'good', 'good', 'bad', 'good',
                'bad', 'good', 'good', 'good', 'bad', 'bad', 'good', 'good', 'good', 'bad']
}

df = pd.DataFrame(data)

print("Dataset criado:")
print(df.head())
print(f"\nDistribuição de qualidade:\n{df['quality'].value_counts()}")

# Treinar modelo
X = df[['density', 'viscosity', 'sulfur_content', 'temperature']]
y = df['quality']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = RandomForestClassifier(n_estimators=10, random_state=42)
model.fit(X_train, y_train)

# Avaliar modelo
y_pred = model.predict(X_test)
print("\nResultados:")
print(classification_report(y_test, y_pred))

# Salvar modelo
model_path = '/tmp/model.pkl'
with open(model_path, 'wb') as f:
    pickle.dump(model, f)

print(f"Modelo salvo em {model_path}")

# Upload para o GCS
bucket_name = os.environ.get('BUCKET_NAME', 'allianceit-vertex-allianceit-gke-lab')
model_dir = os.environ.get('AIP_MODEL_DIR', f'gs://{bucket_name}/models/fuel-quality/')

client = storage.Client()
bucket = client.bucket(bucket_name)
blob = bucket.blob('models/fuel-quality/model.pkl')
blob.upload_from_filename(model_path)

print(f"Modelo enviado para gs://{bucket_name}/models/fuel-quality/model.pkl")