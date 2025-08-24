#!/bin/bash

# Set Google Application Credentials
export GOOGLE_APPLICATION_CREDENTIALS="/Users/jefflee/SCTP/M2Project/extended-legend-470014-n7-db75dec7d87a.json"

# Activate the elt environment
source ~/anaconda3/etc/profile.d/conda.sh
conda activate elt

# Navigate to the meltano directory
cd /Users/jefflee/SCTP/M2Project/M2Project_Meltano_Olist/meltano-olist

# Run the meltano pipeline
meltano run tap-postgres target-bigquery
