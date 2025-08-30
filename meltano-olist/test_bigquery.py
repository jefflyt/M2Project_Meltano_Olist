#!/usr/bin/env python3
"""
BigQuery Connection and Permission Test Script
==============================================

This script tests the BigQuery connection and validates the service account
permissions required for the Olist ETL pipeline.

Usage:
    python test_bigquery.py

Requirements:
    - Google Cloud service account credentials
    - GOOGLE_APPLICATION_CREDENTIALS environment variable set
    - google-cloud-bigquery package

Author: M2Project Team
Last Updated: August 30, 2025
"""

import os
import sys
import json
from pathlib import Path

# Configuration
CREDENTIALS_FILE = "/Users/jefflee/SCTP/M2Project/extended-legend-470014-n7-db75dec7d87a.json"
PROJECT_ID = "extended-legend-470014-n7"
DATASET_ID = "Olist_staging"

def print_header():
    """Print script header information."""
    print("🔍 BigQuery Connection Test")
    print("=" * 50)
    print(f"Project ID: {PROJECT_ID}")
    print(f"Dataset ID: {DATASET_ID}")
    print(f"Credentials: {CREDENTIALS_FILE}")
    print()

def check_credentials_file():
    """Check if credentials file exists and is valid JSON."""
    print("1. Checking credentials file...")

    # Check if file exists
    if not os.path.exists(CREDENTIALS_FILE):
        print(f"   ❌ Credentials file not found: {CREDENTIALS_FILE}")
        return False

    print(f"   ✅ Credentials file exists: {CREDENTIALS_FILE}")

    # Check if it's valid JSON
    try:
        with open(CREDENTIALS_FILE, 'r') as f:
            creds = json.load(f)
        print("   ✅ Credentials file contains valid JSON")

        # Check required fields
        required_fields = ['type', 'project_id', 'private_key_id', 'private_key', 'client_email']
        missing_fields = [field for field in required_fields if field not in creds]

        if missing_fields:
            print(f"   ❌ Missing required fields: {missing_fields}")
            return False
        else:
            print("   ✅ All required fields present")
            print(f"      - Project ID: {creds.get('project_id')}")
            print(f"      - Client Email: {creds.get('client_email')}")
            print(f"      - Type: {creds.get('type')}")
            return True

    except json.JSONDecodeError as e:
        print(f"   ❌ JSON decode error: {e}")
        return False
    except Exception as e:
        print(f"   ❌ Error reading file: {e}")
        return False

def check_environment_variable():
    """Check if GOOGLE_APPLICATION_CREDENTIALS is set correctly."""
    print("\n2. Checking environment variable...")

    env_creds = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
    if not env_creds:
        print("   ❌ GOOGLE_APPLICATION_CREDENTIALS environment variable not set")
        print(f"   💡 Run: export GOOGLE_APPLICATION_CREDENTIALS=\"{CREDENTIALS_FILE}\"")
        return False

    if env_creds != CREDENTIALS_FILE:
        print(f"   ⚠️  Environment variable points to different file:")
        print(f"      Expected: {CREDENTIALS_FILE}")
        print(f"      Actual: {env_creds}")
        return False

    print("   ✅ GOOGLE_APPLICATION_CREDENTIALS is set correctly")
    return True

def test_bigquery_connection():
    """Test BigQuery connection and permissions."""
    print("\n3. Testing BigQuery connection...")

    try:
        from google.cloud import bigquery
        print("   ✅ google-cloud-bigquery package available")
    except ImportError:
        print("   ❌ google-cloud-bigquery package not available")
        print("   💡 Install with: pip install google-cloud-bigquery")
        return False

    try:
        # Set environment variable if not set
        if not os.getenv('GOOGLE_APPLICATION_CREDENTIALS'):
            os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = CREDENTIALS_FILE

        # Create BigQuery client
        client = bigquery.Client(project=PROJECT_ID)
        print("   ✅ BigQuery client created successfully")

        # Test listing datasets
        try:
            datasets = list(client.list_datasets())
            print(f"   ✅ Successfully connected! Found {len(datasets)} datasets")

            # Check if our target dataset exists
            dataset_names = [dataset.dataset_id for dataset in datasets]
            if DATASET_ID in dataset_names:
                print(f"   ✅ Target dataset '{DATASET_ID}' exists")
            else:
                print(f"   ⚠️  Target dataset '{DATASET_ID}' not found")
                print(f"   💡 Create with: bq mk --dataset {PROJECT_ID}:{DATASET_ID}")

            # List first few datasets
            if datasets:
                print("   📊 Available datasets:")
                for dataset in datasets[:5]:  # Show first 5
                    print(f"      - {dataset.dataset_id}")

            return True

        except Exception as e:
            print(f"   ❌ Error listing datasets: {e}")
            print("   💡 Check service account permissions in Google Cloud Console")
            return False

    except Exception as e:
        print(f"   ❌ Error creating BigQuery client: {e}")
        print("   💡 Verify credentials file and GOOGLE_APPLICATION_CREDENTIALS")
        return False

def test_dataset_permissions():
    """Test specific dataset permissions."""
    print("\n4. Testing dataset permissions...")

    try:
        from google.cloud import bigquery

        client = bigquery.Client(project=PROJECT_ID)
        dataset_ref = client.dataset(DATASET_ID)

        # Try to get dataset metadata
        try:
            dataset = client.get_dataset(dataset_ref)
            print(f"   ✅ Can access dataset '{DATASET_ID}'")
            print(f"      - Location: {dataset.location}")
            print(f"      - Created: {dataset.created}")
            return True
        except Exception as e:
            print(f"   ❌ Cannot access dataset '{DATASET_ID}': {e}")
            print(f"   💡 Create dataset or check permissions")
            return False

    except Exception as e:
        print(f"   ❌ Error testing dataset permissions: {e}")
        return False

def print_summary(results):
    """Print test summary."""
    print("\n" + "=" * 50)
    print("📋 TEST SUMMARY")
    print("=" * 50)

    all_passed = all(results.values())

    for test_name, passed in results.items():
        status = "✅ PASS" if passed else "❌ FAIL"
        print(f"{status} {test_name}")

    print()

    if all_passed:
        print("🎉 All tests passed! Your BigQuery setup is ready for the ETL pipeline.")
        print("\n🚀 You can now run the pipeline:")
        print("   ./run_pipeline.sh")
    else:
        print("⚠️  Some tests failed. Please address the issues above before running the pipeline.")
        print("\n🔧 Common fixes:")
        print("   - Set GOOGLE_APPLICATION_CREDENTIALS environment variable")
        print("   - Verify service account has BigQuery permissions")
        print("   - Create the target dataset if it doesn't exist")
        print("   - Install required Python packages")

def main():
    """Main test function."""
    print_header()

    results = {}

    # Run all tests
    results["Credentials File"] = check_credentials_file()
    results["Environment Variable"] = check_environment_variable()
    results["BigQuery Connection"] = test_bigquery_connection()
    results["Dataset Permissions"] = test_dataset_permissions()

    # Print summary
    print_summary(results)

    # Exit with appropriate code
    sys.exit(0 if all(results.values()) else 1)

if __name__ == "__main__":
    main()
