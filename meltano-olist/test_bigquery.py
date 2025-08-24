#!/usr/bin/env python3
import os
import json

# Set the credentials file path
creds_file = "/Users/jefflee/SCTP/M2Project/extended-legend-470014-n7-db75dec7d87a.json"

# Check if file exists and is readable
if os.path.exists(creds_file):
    print(f"✓ Credentials file exists: {creds_file}")
    
    # Check if it's valid JSON
    try:
        with open(creds_file, 'r') as f:
            creds = json.load(f)
        print("✓ Credentials file contains valid JSON")
        
        # Check required fields
        required_fields = ['type', 'project_id', 'private_key_id', 'private_key', 'client_email']
        missing_fields = [field for field in required_fields if field not in creds]
        
        if missing_fields:
            print(f"✗ Missing required fields: {missing_fields}")
        else:
            print("✓ All required fields present")
            print(f"  - Project ID: {creds.get('project_id')}")
            print(f"  - Client Email: {creds.get('client_email')}")
            print(f"  - Type: {creds.get('type')}")
            
    except json.JSONDecodeError as e:
        print(f"✗ JSON decode error: {e}")
    except Exception as e:
        print(f"✗ Error reading file: {e}")
else:
    print(f"✗ Credentials file not found: {creds_file}")

# Try to import BigQuery client
try:
    from google.cloud import bigquery
    print("✓ google-cloud-bigquery package available")
    
    # Set environment variable
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = creds_file
    
    # Try to create client
    try:
        client = bigquery.Client()
        print("✓ BigQuery client created successfully")
        
        # Try to list datasets
        try:
            datasets = list(client.list_datasets())
            print(f"✓ Successfully listed {len(datasets)} datasets:")
            for dataset in datasets:
                print(f"  - {dataset.dataset_id}")
        except Exception as e:
            print(f"✗ Error listing datasets: {e}")
            
    except Exception as e:
        print(f"✗ Error creating BigQuery client: {e}")
        
except ImportError:
    print("✗ google-cloud-bigquery package not available")
    print("  You may need to: pip install google-cloud-bigquery")
