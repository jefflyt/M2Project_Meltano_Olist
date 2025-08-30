# Changelog

All notable changes to the M2Project - Olist ETL Pipeline will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive project documentation
- BigQuery connection testing script (`test_bigquery.py`)
- Automated pipeline runner script (`run_pipeline.sh`)
- Environment configuration template (`.env`)
- Detailed README files for project and Meltano components
- Contributing guidelines and development workflow
- Comprehensive `.gitignore` patterns

### Changed
- Updated Meltano configuration with detailed comments
- Enhanced pipeline execution with error handling and logging
- Improved credential management and security practices

### Fixed
- BigQuery authentication and permission issues
- Pipeline execution reliability
- Documentation inconsistencies

## [1.0.0] - 2025-08-30

### Added
- Initial ETL pipeline implementation
- PostgreSQL to BigQuery data extraction and loading
- Meltano framework integration
- Google Cloud BigQuery target configuration
- Supabase PostgreSQL source configuration
- Basic project structure and documentation

### Features
- **Data Sources**: Olist e-commerce datasets (customers, orders, products, payments, reviews)
- **Data Target**: Google BigQuery with denormalized schema
- **Batch Processing**: Optimized for large dataset processing
- **Error Handling**: Comprehensive logging and error recovery
- **Monitoring**: Pipeline state tracking and performance metrics

### Technical Details
- **Framework**: Meltano 3.7.8
- **Python**: 3.10.18
- **Source**: PostgreSQL (Supabase)
- **Target**: Google BigQuery
- **Datasets**: 9 Olist e-commerce tables
- **Processing**: Batch loading with 100MB batch size

---

## Types of Changes

- `Added` for new features
- `Changed` for changes in existing functionality
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features
- `Fixed` for any bug fixes
- `Security` in case of vulnerabilities

## Versioning

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

## Release Process

1. Update version in relevant files
2. Update CHANGELOG.md with release notes
3. Create git tag
4. Deploy to production environment
5. Update documentation

---

**Legend:**
- 🚀 New feature
- 🐛 Bug fix
- 📚 Documentation
- 🔧 Maintenance
- ⚡ Performance improvement
- 🔒 Security enhancement

---

**Last Updated:** August 30, 2025
