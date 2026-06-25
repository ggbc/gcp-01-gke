FROM python:3.10-slim

WORKDIR /app

RUN pip install --no-cache-dir \
    numpy==1.24.3 \
    scikit-learn==1.3.0 \
    pandas==2.0.3 \
    google-cloud-storage==2.10.0

COPY train.py .

ENTRYPOINT ["python", "train.py"]