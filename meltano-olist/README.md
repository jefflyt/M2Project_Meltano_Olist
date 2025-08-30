# Meltano Olist ETL Project

This is the core Meltano project for the Olist E-commerce Data Pipeline. It handles the extraction, transformation, and loading of Olist e-commerce data from PostgreSQL to Google BigQuery.

## 🚀 Quick Start

### Prerequisites
- Python 3.8+
- Google Cloud service account with BigQuery permissions
- Supabase PostgreSQL database access

### Setup
1. **Install dependencies:**
   ```bash
   meltano install
   ```

2. **Configure credentials:**
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/credentials.json"
   ```

3. **Run the pipeline:**
   ```bash
   ./run_pipeline.sh
   ```

## 📊 Data Pipeline

### Source: PostgreSQL (Supabase)
- **Host:** aws-1-ap-southeast-1.pooler.supabase.com
- **Database:** postgres
- **Schema:** public
- **Tables:** All Olist e-commerce datasets

### Target: Google BigQuery
- **Project:** extended-legend-470014-n7
- **Dataset:** olist_raw
- **Method:** Batch loading with denormalization

## 🔧 Configuration

### Environment Variables
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to BigQuery service account key
- `TAP_POSTGRES_PASSWORD`: PostgreSQL database password (stored in .env)

### Meltano Configuration
See `meltano.yml` for detailed plugin configurations including:
- PostgreSQL connection settings
- BigQuery credentials and dataset configuration
- Batch processing parameters

## 📁 Project Structure

```
meltano-olist/
├── meltano.yml              # Main Meltano configuration
├── requirements.txt         # Python dependencies
├── run_pipeline.sh         # Pipeline execution script
├── test_bigquery.py        # BigQuery connection test
├── .env                    # Environment variables
├── .gitignore             # Git ignore patterns
├── .meltano/              # Meltano internal files
├── analyze/               # Data analysis scripts
├── extract/               # Extraction configurations
├── load/                  # Loading configurations
├── transform/             # Data transformation logic
├── notebook/              # Jupyter notebooks
├── orchestrate/           # Orchestration scripts
└── output/                # Pipeline outputs and logs
```

## 🧪 Testing

### Test BigQuery Connection
```bash
python test_bigquery.py
```

### Test PostgreSQL Connection
```bash
meltano config tap-postgres test
```

### Test Individual Components
```bash
meltano invoke tap-postgres --about
meltano invoke target-bigquery --help
```

## 📈 Monitoring

- **Pipeline Status:** `meltano state`
- **Logs:** `meltano logs`
- **BigQuery Jobs:** Google Cloud Console → BigQuery → Job History

## 🔄 Pipeline Execution

### Manual Execution
```bash
meltano run tap-postgres target-bigquery
```

### Automated Execution
```bash
./run_pipeline.sh
```

### Custom Execution
```bash
# Run with specific environment
meltano run --environment=prod tap-postgres target-bigquery

# Run with debug logging
meltano --log-level=debug run tap-postgres target-bigquery
```

## 🐛 Troubleshooting

### Common Issues

1. **BigQuery Authentication Error:**
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/correct/path/to/credentials.json"
   ```

2. **PostgreSQL Connection Error:**
   - Check credentials in `meltano.yml`
   - Verify Supabase connection string
   - Check network connectivity

3. **Dataset Not Found:**
   ```bash
   bq mk --dataset extended-legend-470014-n7:olist_raw
   ```

### Debug Mode
```bash
meltano --log-level=debug run tap-postgres target-bigquery
```

## 📚 Resources

- [Meltano Documentation](https://docs.meltano.com/)
- [Google BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Olist Dataset Documentation](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## 🤝 Contributing

1. Test your changes locally
2. Update documentation as needed
3. Follow the existing code style
4. Create descriptive commit messages

---

**Last Updated:** August 30, 2025
