# M2Project - Olist E-commerce Data Pipeline

A comprehensive ETL (Extract, Transform, Load) pipeline built with Meltano for processing and analyzing Olist e-commerce data. This project extracts data from a PostgreSQL database and loads it into Google BigQuery for advanced analytics and business intelligence.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Data Sources](#data-sources)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This project implements a robust data pipeline that:

- **Extracts** e-commerce data from PostgreSQL database (hosted on Supabase)
- **Transforms** the data for optimal analytics
- **Loads** processed data into Google BigQuery for scalable analytics
- **Provides** infrastructure for data analysis and visualization

The pipeline is designed to handle large volumes of e-commerce data including customer information, orders, products, payments, and reviews.

## 🏗️ Architecture

```
PostgreSQL (Supabase) → Meltano → Google BigQuery
       ↓                        ↓
   Raw E-commerce Data     ETL Pipeline     Analytics-Ready Data
   - Customers            - Extraction      - Denormalized Tables
   - Orders               - Transformation  - Optimized Schema
   - Products             - Loading         - Query Performance
   - Payments
   - Reviews
   - Geolocation
```

### Components

- **Extractor**: `tap-postgres` - Extracts data from PostgreSQL
- **Loader**: `target-bigquery` - Loads data into Google BigQuery
- **Orchestrator**: Meltano - Manages the entire ETL workflow

## 📋 Prerequisites

Before running this project, ensure you have:

- **Python 3.8+**
- **Google Cloud Account** with BigQuery enabled
- **Service Account Key** for BigQuery access
- **Supabase PostgreSQL** database access
- **Meltano CLI** installed

### Required Permissions

Your Google Cloud service account needs:
- BigQuery Data Editor
- BigQuery Job User
- Storage Object Admin (for temporary files)

## 🚀 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jefflyt/M2Project_Meltano_Olist.git
   cd M2Project_Meltano_Olist
   ```

2. **Navigate to the Meltano project:**
   ```bash
   cd meltano-olist
   ```

3. **Install Meltano (if not already installed):**
   ```bash
   pip install meltano
   ```

4. **Install project dependencies:**
   ```bash
   meltano install
   ```

## ⚙️ Configuration

### 1. Google Cloud Setup

1. **Create a Google Cloud Project** or use existing one
2. **Create a Service Account:**
   ```bash
   gcloud iam service-accounts create olist-etl-service
   ```
3. **Generate Service Account Key:**
   ```bash
   gcloud iam service-accounts keys create credentials.json \
     --iam-account=olist-etl-service@your-project.iam.gserviceaccount.com
   ```
4. **Grant necessary permissions:**
   ```bash
   gcloud projects add-iam-policy-binding your-project \
     --member="serviceAccount:olist-etl-service@your-project.iam.gserviceaccount.com" \
     --role="roles/bigquery.dataEditor"
   ```

### 2. Environment Configuration

1. **Copy the credentials file** to the project directory:
   ```bash
   cp /path/to/credentials.json extended-legend-470014-n7-db75dec7d87a.json
   ```

2. **Set environment variables:**
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="extended-legend-470014-n7-db75dec7d87a.json"
   ```

### 3. Meltano Configuration

The main configuration is in `meltano.yml`. Key settings:

- **Source Database**: PostgreSQL on Supabase
- **Target**: Google BigQuery
- **Dataset**: `olist_raw`
- **Project**: `extended-legend-470014-n7`

## 🎬 Usage

### Running the Pipeline

1. **Activate the environment:**
   ```bash
   conda activate elt
   ```

2. **Navigate to project directory:**
   ```bash
   cd meltano-olist
   ```

3. **Run the complete pipeline:**
   ```bash
   ./run_pipeline.sh
   ```

   Or manually:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="extended-legend-470014-n7-db75dec7d87a.json"
   meltano run tap-postgres target-bigquery
   ```

### Testing Components

1. **Test PostgreSQL connection:**
   ```bash
   meltano config tap-postgres test
   ```

2. **Test BigQuery connection:**
   ```bash
   python test_bigquery.py
   ```

3. **Run individual components:**
   ```bash
   meltano invoke tap-postgres --about
   ```

### Monitoring

- Pipeline logs are available in the Meltano interface
- BigQuery job history can be monitored in Google Cloud Console
- Use `meltano state` to check pipeline state

## 📁 Project Structure

```
M2Project_Meltano_Olist/
├── meltano-olist/                 # Main Meltano project
│   ├── meltano.yml               # Meltano configuration
│   ├── requirements.txt          # Python dependencies
│   ├── run_pipeline.sh          # Pipeline execution script
│   ├── test_bigquery.py         # BigQuery connection test
│   ├── .meltano/                # Meltano internal files
│   ├── analyze/                 # Data analysis notebooks
│   ├── extract/                 # Extraction configurations
│   ├── load/                    # Loading configurations
│   ├── transform/               # Data transformation logic
│   ├── notebook/                # Jupyter notebooks
│   ├── orchestrate/             # Orchestration scripts
│   └── output/                  # Pipeline outputs
├── README.md                    # This file
└── .gitignore                   # Git ignore rules
```

## 📊 Data Sources

The pipeline processes the following Olist datasets:

- **Customers** (`olist_customers`) - Customer information and demographics
- **Orders** (`olist_orders`) - Order details and timestamps
- **Order Items** (`olist_order_items`) - Individual order line items
- **Products** (`olist_products`) - Product catalog and descriptions
- **Payments** (`olist_order_payments`) - Payment transaction data
- **Reviews** (`olist_order_reviews`) - Customer reviews and ratings
- **Geolocation** (`olist_geolocation`) - Geographic location data
- **Sellers** (`olist_sellers`) - Seller information
- **Product Categories** (`product_category_name_translation`) - Category translations

## 🔧 Development

### Adding New Data Sources

1. **Add extractor to meltano.yml:**
   ```yaml
   extractors:
   - name: tap-new-source
     variant: meltanolabs
     config:
       # Configuration here
   ```

2. **Install the new extractor:**
   ```bash
   meltano install extractor tap-new-source
   ```

3. **Update the pipeline:**
   ```bash
   meltano run tap-new-source target-bigquery
   ```

### Custom Transformations

Transformations can be added in the `transform/` directory using:
- SQL scripts for BigQuery
- Python scripts for complex transformations
- dbt models for advanced transformations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow PEP 8 for Python code
- Use meaningful commit messages
- Update documentation for new features
- Test changes before submitting

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

1. **Credentials Error:**
   - Ensure `GOOGLE_APPLICATION_CREDENTIALS` is set correctly
   - Verify service account has proper permissions

2. **Database Connection Error:**
   - Check PostgreSQL credentials in `meltano.yml`
   - Verify Supabase connection string

3. **BigQuery Dataset Not Found:**
   - Create the dataset manually or update configuration
   - Check project ID and dataset name

4. **Pipeline Fails:**
   - Check Meltano logs: `meltano logs`
   - Verify all dependencies are installed

### Support

For issues and questions:
- Check existing GitHub issues
- Create a new issue with detailed error logs
- Include your environment details and configuration

## 📚 Documentation

- **[Meltano Project README](./meltano-olist/README.md)** - Detailed project documentation
- **[Contributing Guide](./CONTRIBUTING.md)** - Development and contribution guidelines
- **[Changelog](./CHANGELOG.md)** - Version history and release notes
- **[License](./LICENSE)** - MIT License terms

## 📋 Additional Resources

- **Testing**: Run `python test_bigquery.py` to verify BigQuery setup
- **Pipeline Execution**: Use `./run_pipeline.sh` for automated execution
- **Configuration**: Check `meltano.yml` and `.env` for settings
- **Logs**: Monitor pipeline with `meltano logs` and `meltano state`