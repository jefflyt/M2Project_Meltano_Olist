#!/bin/bash
# =============================================================================
# Meltano Olist ETL Pipeline Runner
# =============================================================================
#
# This script automates the execution of the Olist e-commerce data pipeline.
# It handles environment setup, dependency activation, and pipeline execution.
#
# Usage: ./run_pipeline.sh
#
# Prerequisites:
# - Google Cloud service account credentials file
# - Conda environment 'elt' with Meltano installed
# - Proper permissions for BigQuery and PostgreSQL access
#
# Author: M2Project Team
# Last Updated: August 30, 2025
# =============================================================================

set -e  # Exit on any error

echo "🚀 Starting Meltano Olist ETL Pipeline..."
echo "=========================================="

# Set Google Application Credentials
# This environment variable tells Google Cloud SDK which service account to use
echo "🔐 Setting Google Cloud credentials..."
export GOOGLE_APPLICATION_CREDENTIALS="/Users/jefflee/SCTP/M2Project/extended-legend-470014-n7-db75dec7d87a.json"

# Verify credentials file exists
if [ ! -f "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo "❌ Error: Credentials file not found at $GOOGLE_APPLICATION_CREDENTIALS"
    echo "   Please ensure the BigQuery service account key file exists."
    exit 1
fi

# Activate the elt conda environment
echo "🐍 Activating conda environment 'elt'..."
source /Users/jefflee/Applications/anaconda3/etc/profile.d/conda.sh

if ! conda activate elt; then
    echo "❌ Error: Failed to activate conda environment 'elt'"
    echo "   Please ensure conda is installed and the 'elt' environment exists."
    echo "   Run: conda create -n elt python=3.10 meltano -c conda-forge"
    exit 1
fi

# Navigate to the meltano project directory
echo "📁 Navigating to Meltano project directory..."
cd /Users/jefflee/SCTP/M2Project/M2Project_Meltano_Olist/meltano-olist

# Verify we're in the correct directory
if [ ! -f "meltano.yml" ]; then
    echo "❌ Error: meltano.yml not found in current directory"
    echo "   Please ensure you're in the correct Meltano project directory."
    exit 1
fi

# Display pipeline information
echo "📊 Pipeline Configuration:"
echo "   Source: PostgreSQL (Supabase)"
echo "   Target: Google BigQuery (extended-legend-470014-n7:olist_raw)"
echo "   Environment: $(meltano config get default_environment)"
echo ""

# Run the meltano pipeline
echo "⚡ Executing ETL pipeline..."
echo "   Command: meltano run tap-postgres target-bigquery"
echo ""

meltano run tap-postgres target-bigquery

# Check pipeline execution result
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Pipeline completed successfully!"
    echo "📈 Data has been loaded to BigQuery dataset: olist_raw"
    echo ""
    echo "🔍 Next steps:"
    echo "   - Check BigQuery console for loaded data"
    echo "   - Run analysis notebooks in the notebook/ directory"
    echo "   - Monitor pipeline performance with: meltano state"
else
    echo ""
    echo "❌ Pipeline failed!"
    echo "🔍 Troubleshooting steps:"
    echo "   - Check Meltano logs: meltano logs"
    echo "   - Test connections: python test_bigquery.py"
    echo "   - Verify credentials: gcloud auth list"
    echo "   - Run with debug: meltano --log-level=debug run tap-postgres target-bigquery"
    exit 1
fi

echo "🎉 Pipeline execution completed!"
echo "=========================================="
