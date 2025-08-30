# Contributing to M2Project - Olist ETL Pipeline

Thank you for your interest in contributing to the Olist E-commerce Data Pipeline! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Development Workflow](#development-workflow)
- [Code Standards](#code-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Submitting Changes](#submitting-changes)
- [Issue Reporting](#issue-reporting)

## 🚀 Getting Started

### Prerequisites
- Python 3.8 or higher
- Git
- Google Cloud account with BigQuery access
- Supabase PostgreSQL database access

### Quick Setup
```bash
# Clone the repository
git clone https://github.com/jefflyt/M2Project_Meltano_Olist.git
cd M2Project_Meltano_Olist/meltano-olist

# Install dependencies
pip install -r requirements.txt
meltano install

# Set up environment
cp .env.example .env
# Edit .env with your credentials

# Test setup
python test_bigquery.py
```

## 🛠️ Development Setup

### 1. Environment Setup
```bash
# Create conda environment
conda create -n elt python=3.10 meltano -c conda-forge
conda activate elt

# Install additional dependencies
pip install -r requirements.txt
```

### 2. Google Cloud Setup
```bash
# Authenticate with Google Cloud
gcloud auth login
gcloud config set project extended-legend-470014-n7

# Create service account (if needed)
gcloud iam service-accounts create olist-etl-dev
```

### 3. Database Setup
Ensure you have access to:
- Supabase PostgreSQL instance
- BigQuery project with appropriate permissions

## 🔄 Development Workflow

### 1. Choose an Issue
- Check existing [GitHub issues](https://github.com/jefflyt/M2Project_Meltano_Olist/issues)
- Create a new issue if your idea isn't covered
- Comment on the issue to indicate you're working on it

### 2. Create a Branch
```bash
# Create and switch to a feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b bugfix/issue-number-description
```

### 3. Make Changes
- Follow the code standards below
- Write tests for new functionality
- Update documentation as needed
- Test your changes locally

### 4. Commit Changes
```bash
# Stage your changes
git add .

# Commit with descriptive message
git commit -m "feat: add new data transformation pipeline

- Add customer segmentation logic
- Implement data validation checks
- Update documentation

Closes #123"
```

### 5. Push and Create Pull Request
```bash
# Push your branch
git push origin feature/your-feature-name

# Create a Pull Request on GitHub
```

## 📏 Code Standards

### Python Code
- Follow [PEP 8](https://pep8.org/) style guidelines
- Use type hints for function parameters and return values
- Write docstrings for all public functions and classes
- Use meaningful variable and function names

### Example:
```python
def process_customer_data(data: pd.DataFrame) -> pd.DataFrame:
    """
    Process and clean customer data.

    Args:
        data: Raw customer data from PostgreSQL

    Returns:
        Cleaned and processed customer data
    """
    # Implementation here
    pass
```

### YAML Configuration
- Use consistent indentation (2 spaces)
- Add comments for complex configurations
- Group related settings together

### SQL Scripts
- Use uppercase for SQL keywords
- Add comments for complex queries
- Use meaningful table aliases

## 🧪 Testing

### Running Tests
```bash
# Run all tests
pytest

# Run specific test file
pytest test_bigquery.py

# Run with coverage
pytest --cov=. --cov-report=html
```

### Test Structure
```
tests/
├── test_extractors/
├── test_loaders/
├── test_transformations/
└── test_integration/
```

### Writing Tests
```python
import pytest
from your_module import your_function

def test_your_function():
    """Test your_function with valid inputs."""
    # Arrange
    input_data = {"key": "value"}

    # Act
    result = your_function(input_data)

    # Assert
    assert result is not None
    assert "expected_key" in result
```

## 📚 Documentation

### Code Documentation
- Use docstrings for all public functions
- Include type hints
- Document parameters, return values, and exceptions

### README Updates
- Update README.md for new features
- Add examples for new functionality
- Update installation instructions if needed

### Commit Messages
Follow conventional commit format:
```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Testing
- `chore`: Maintenance

## 📝 Submitting Changes

### Pull Request Process
1. **Title**: Use descriptive, concise title
2. **Description**: Explain what changes and why
3. **Checklist**:
   - [ ] Tests pass locally
   - [ ] Code follows style guidelines
   - [ ] Documentation updated
   - [ ] No sensitive data committed

### Review Process
- At least one maintainer review required
- Address review comments
- CI/CD checks must pass
- Squash commits if requested

### Example Pull Request Description
```
## Description
This PR adds customer segmentation functionality to the ETL pipeline.

## Changes Made
- Added customer_segmentation.py module
- Updated meltano.yml with new transformation
- Added tests for segmentation logic

## Testing
- All existing tests pass
- New tests added for segmentation
- Manual testing with sample data

## Screenshots
[If applicable, add screenshots of new features]

Fixes #123
```

## 🐛 Issue Reporting

### Bug Reports
When reporting bugs, please include:
- **Description**: Clear description of the issue
- **Steps to reproduce**: Step-by-step instructions
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: OS, Python version, Meltano version
- **Logs**: Relevant error logs or output

### Feature Requests
For new features, please include:
- **Description**: What feature you want
- **Use case**: Why you need this feature
- **Proposed solution**: How you think it should work
- **Alternatives**: Other solutions you've considered

## 🎯 Development Guidelines

### General Principles
- **DRY**: Don't Repeat Yourself
- **KISS**: Keep It Simple, Stupid
- **SOLID**: Single responsibility, Open-closed, Liskov substitution, Interface segregation, Dependency inversion

### ETL Best Practices
- **Idempotent**: Pipelines should be safe to run multiple times
- **Fault-tolerant**: Handle errors gracefully
- **Observable**: Log important events and metrics
- **Testable**: Write tests for all components

### Security
- Never commit credentials or sensitive data
- Use environment variables for configuration
- Follow principle of least privilege
- Rotate credentials regularly

## 📞 Getting Help

- **Documentation**: Check the README and docs/ folder
- **Issues**: Search existing GitHub issues
- **Discussions**: Use GitHub Discussions for questions
- **Slack**: Join the Meltano community Slack

## 🙏 Recognition

Contributors will be recognized in:
- GitHub repository contributors list
- CHANGELOG.md for significant contributions
- Project documentation

Thank you for contributing to the Olist ETL Pipeline! 🚀

---

**Last Updated:** August 30, 2025
