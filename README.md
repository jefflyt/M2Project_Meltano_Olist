# M2Project - Olist E-commerce Data Pipeline

A comprehensive ETL (Extract, Transform, Load) pipeline built with Meltano for processing and analyzing Olist e-commerce data. This project extracts data from a PostgreSQL database and loads it into Google BigQuery for advanced analytics and business intelligence.

## 📋 Table of Contents

- [Quick Start](#quick-start)
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

## ⚡ Quick Start

1. **Extract data from Supabase to BigQuery:**
   ```bash
   cd meltano-olist && ./run_pipeline.sh
   ```

2. **Transform raw data to analytics-ready format:**
   ```bash
   cd ../dbt_olist && ./dbt-run.sh run
   ```

3. **Query clean data from BigQuery `olist_staging` dataset**

## 🎯 Overview

This project implements a robust data pipeline that:

- **Extracts** e-commerce data from PostgreSQL database (hosted on Supabase) using **Meltano**
- **Transforms** raw data into analytics-ready datasets using **dbt**
- **Loads** processed data into Google BigQuery for scalable analytics
- **Provides** infrastructure for data analysis and visualization

The pipeline follows modern ELT (Extract, Load, Transform) architecture and is designed to handle large volumes of e-commerce data including customer information, orders, products, payments, and reviews.

## 🏗️ Architecture

```
PostgreSQL (Supabase) → Meltano → BigQuery (Raw) → dbt → BigQuery (Staging)
       ↓                    ↓              ↓         ↓            ↓
   Raw E-commerce Data  Extraction    olist_raw   Transform   olist_staging
   - Customers         - tap-postgres    ↓        - Cleaning      ↓
   - Orders            - target-bigquery  ↓        - Modeling   Analytics-Ready
   - Products                             ↓        - Testing    - Denormalized
   - Payments          Raw Data Tables    ↓        - Docs       - Optimized
   - Reviews           - Unprocessed      ↓                     - Validated
   - Geolocation       - 1:1 Copy         ↓                     
                                         ↓
                                    Data Staging
```

### Components

- **Meltano Pipeline**: Handles data extraction and loading
  - **Extractor**: `tap-postgres` - Extracts data from PostgreSQL (Supabase)
  - **Loader**: `target-bigquery` - Loads raw data into BigQuery `olist_raw` dataset
- **dbt Project**: Handles data transformation
  - **Source**: `olist_raw` dataset (raw extracted data)
  - **Target**: `olist_staging` dataset (clean, analytics-ready data)
  - **Models**: Staging → Intermediate → Marts architecture

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

### 3. Project Configuration

This project uses **centralized configuration management**:

1. **Root-level profiles.yml**: Manages both Meltano and dbt BigQuery connections
2. **Meltano configuration**: `meltano-olist/meltano.yml` (extraction pipeline)
3. **dbt configuration**: `dbt_olist/dbt_project.yml` (transformation pipeline)

**Key Configuration Files:**
- `profiles.yml` - Centralized BigQuery connection profiles
- `meltano-olist/meltano.yml` - Extraction pipeline configuration
- `dbt_olist/dbt_project.yml` - Transformation project configuration

### 3. Meltano Configuration

The main configuration is in `meltano-olist/meltano.yml`. Key settings:

- **Source Database**: PostgreSQL on Supabase
- **Target**: Google BigQuery `olist_raw` dataset
- **Project**: `extended-legend-470014-n7`

### 4. dbt Configuration

The dbt project uses centralized configuration:

- **Project Configuration**: `dbt_olist/dbt_project.yml`
- **Profile Configuration**: `profiles.yml` (centralized in root directory)
- **Source Dataset**: BigQuery `olist_raw` (from Meltano extraction)
- **Target Dataset**: BigQuery `olist_staging` (clean, analytics-ready data)

#### Centralized Profiles (`profiles.yml`)

The root-level `profiles.yml` manages configurations for both Meltano and dbt:

```yaml
# Meltano BigQuery loading configuration
meltano_olist:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: extended-legend-470014-n7
      dataset: olist_raw              # Raw data target

# dbt transformation configuration  
dbt_olist:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service-account
      project: extended-legend-470014-n7
      dataset: olist_staging          # Clean data target
```

## 🎬 Usage

### Running the Complete Pipeline

1. **Activate the environment:**
   ```bash
   conda activate elt
   ```

2. **Step 1: Extract data with Meltano** (Supabase → BigQuery Raw)
   ```bash
   cd meltano-olist
   ./run_pipeline.sh
   ```

   Or manually:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="extended-legend-470014-n7-db75dec7d87a.json"
   meltano run tap-postgres target-bigquery
   ```

3. **Step 2: Transform data with dbt** (Raw → Staging)
   ```bash
   cd ../dbt_olist
   ./dbt-run.sh run
   ```

### Testing Components

1. **Test Meltano extraction:**
   ```bash
   cd meltano-olist
   meltano config tap-postgres test
   ```

2. **Test dbt transformation:**
   ```bash
   cd dbt_olist
   ./dbt-run.sh debug
   ./dbt-run.sh test
   ```

3. **Test BigQuery connection:**
   ```bash
   cd meltano-olist
   python test_bigquery.py
   ```

### Individual Component Usage

1. **Run only extraction (Meltano):**
   ```bash
   cd meltano-olist
   meltano invoke tap-postgres --about
   ```

2. **Run only transformation (dbt):**
   ```bash
   cd dbt_olist
   ./dbt-run.sh compile  # Compile models
   ./dbt-run.sh run      # Execute transformations
   ./dbt-run.sh test     # Run data quality tests
   ```

### Monitoring

**Extraction Pipeline (Meltano):**
- Pipeline logs: `meltano logs`
- Pipeline state: `meltano state`
- BigQuery job history in Google Cloud Console

**Transformation Pipeline (dbt):**
- Model compilation: `./dbt-run.sh compile`
- Data quality tests: `./dbt-run.sh test`
- Documentation: `./dbt-run.sh docs generate && ./dbt-run.sh docs serve`

**Overall Monitoring:**
- Raw data in BigQuery `olist_raw` dataset
- Clean data in BigQuery `olist_staging` dataset
- BigQuery query history and performance metrics

## 📁 Project Structure

```
M2Project_Meltano_Olist/
├── profiles.yml                  # ✨ Centralized dbt profiles configuration
├── meltano-olist/                # 🔄 Meltano extraction pipeline
│   ├── meltano.yml               # Meltano configuration (extraction only)
│   ├── requirements.txt          # Python dependencies
│   ├── run_pipeline.sh          # Pipeline execution script
│   ├── test_bigquery.py         # BigQuery connection test
│   ├── .meltano/                # Meltano internal files
│   ├── analyze/                 # Data analysis notebooks
│   ├── extract/                 # Extraction configurations
│   ├── load/                    # Loading configurations
│   ├── notebook/                # Jupyter notebooks
│   ├── orchestrate/             # Orchestration scripts
│   ├── output/                  # Pipeline outputs
│   └── plugins/                 # Meltano plugin configurations
├── dbt_olist/                   # 🔧 dbt transformation project
│   ├── dbt_project.yml          # dbt project configuration
│   ├── dbt-run.sh              # dbt convenience script
│   ├── models/                  # dbt transformation models
│   │   ├── staging/             # Raw data staging models
│   │   ├── intermediate/        # Business logic models
│   │   └── marts/               # Final analytics models
│   ├── tests/                   # Data quality tests
│   ├── macros/                  # Reusable SQL macros
│   └── seeds/                   # Static reference data
├── README.md                    # This file
└── .gitignore                   # Git ignore rules
```

### Data Flow

1. **🔄 Extraction** (`meltano-olist/`): Supabase PostgreSQL → BigQuery `olist_raw`
2. **🔧 Transformation** (`dbt_olist/`): BigQuery `olist_raw` → BigQuery `olist_staging`
3. **📊 Analytics**: Query clean data from `olist_staging` dataset

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

### Pipeline Architecture

This project follows a **modern ELT architecture** with clear separation of concerns:

1. **Extraction Layer** (`meltano-olist/`):
   - Handles data extraction from Supabase PostgreSQL
   - Loads raw data into BigQuery `olist_raw` dataset
   - Managed by Meltano ETL framework

2. **Transformation Layer** (`dbt_olist/`):
   - Processes raw data from `olist_raw`
   - Creates clean, analytics-ready data in `olist_staging`
   - Managed by dbt transformation framework

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
   cd meltano-olist
   meltano install extractor tap-new-source
   ```

3. **Update the pipeline:**
   ```bash
   meltano run tap-new-source target-bigquery
   ```

### Adding dbt Transformations

1. **Create new models in dbt_olist/models/:**
   ```bash
   cd dbt_olist
   # Add staging models
   touch models/staging/stg_new_table.sql
   # Add marts models  
   touch models/marts/mart_new_analysis.sql
   ```

2. **Test and run transformations:**
   ```bash
   ./dbt-run.sh compile  # Validate SQL
   ./dbt-run.sh run      # Execute models
   ./dbt-run.sh test     # Run data quality tests
   ```

### Configuration Management

- **Centralized Profiles**: All dbt profiles managed in root `profiles.yml`
- **Environment Variables**: Use `.env` files for sensitive configurations
- **Service Account**: Single service account key for both Meltano and dbt

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
   - Verify service account has proper BigQuery permissions
   - Check service account key path in `profiles.yml`

2. **Meltano Extraction Issues:**
   - Check PostgreSQL credentials in `meltano-olist/meltano.yml`
   - Verify Supabase connection string and database access
   - Test with: `cd meltano-olist && meltano config tap-postgres test`

3. **dbt Transformation Issues:**
   - Verify profile configuration: `cd dbt_olist && ./dbt-run.sh debug`
   - Check BigQuery dataset permissions for both `olist_raw` and `olist_staging`
   - Ensure centralized `profiles.yml` is accessible

4. **BigQuery Dataset Issues:**
   - Create missing datasets: `olist_raw` and `olist_staging`
   - Verify project ID: `extended-legend-470014-n7`
   - Check dataset locations (US region)

5. **Pipeline Coordination:**
   - Run Meltano extraction first to populate `olist_raw`
   - Then run dbt transformation to create `olist_staging`
   - Monitor both pipelines independently

### Pipeline-Specific Debugging

**Meltano Pipeline:**
```bash
cd meltano-olist
meltano logs        # Check extraction logs
meltano state       # Check pipeline state  
```

**dbt Pipeline:**
```bash
cd dbt_olist
./dbt-run.sh debug  # Test configuration
./dbt-run.sh test   # Run data quality tests
./dbt-run.sh docs generate && ./dbt-run.sh docs serve  # Generate documentation
```

### Support

For issues and questions:
- Check existing GitHub issues
- Create a new issue with detailed error logs
- Include your environment details and configuration

## 📚 Documentation

- **[Meltano Project README](./meltano-olist/README.md)** - Extraction pipeline documentation
- **[dbt Project](./dbt_olist/)** - Transformation pipeline and models
- **[Centralized Profiles](./profiles.yml)** - BigQuery connection configuration
- **[Contributing Guide](./CONTRIBUTING.md)** - Development and contribution guidelines
- **[Changelog](./CHANGELOG.md)** - Version history and release notes
- **[License](./LICENSE)** - MIT License terms

## 📋 Additional Resources

### Quick Commands

**Extraction Pipeline:**
```bash
cd meltano-olist && ./run_pipeline.sh
```

**Transformation Pipeline:**
```bash
cd dbt_olist && ./dbt-run.sh run
```

**Testing:**
```bash
# Test BigQuery connection
cd meltano-olist && python test_bigquery.py

# Test dbt configuration  
cd dbt_olist && ./dbt-run.sh debug

# Run data quality tests
cd dbt_olist && ./dbt-run.sh test
```

**Configuration:**
- **Meltano**: Check `meltano-olist/meltano.yml` for extraction settings
- **dbt**: Check `dbt_olist/dbt_project.yml` and root `profiles.yml` for transformation settings
- **Logs**: Monitor with `meltano logs` (extraction) and dbt output (transformation)