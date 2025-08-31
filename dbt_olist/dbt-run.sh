#!/bin/bash

# Olist dbt Data Transformation Script
# Usage: ./dbt-run.sh [command] [args...]
# Examples:
#   ./dbt-run.sh debug
#   ./dbt-run.sh run
#   ./dbt-run.sh test
#   ./dbt-run.sh run --select staging
#   ./dbt-run.sh docs generate

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Project info
PROJECT_NAME="dbt_olist"
PROFILE_NAME="meltano_olist"
PROFILES_DIR="/Users/jefflee/SCTP/M2Project/M2Project_Meltano_Olist"
DEFAULT_TARGET="staging"

echo -e "${CYAN}=================================================================${NC}"
echo -e "${CYAN}🧹 Olist Data Transformation - Using Centralized Profiles${NC}"
echo -e "${CYAN}=================================================================${NC}"
echo -e "${BLUE}[${PROJECT_NAME}] Profile: ${PROFILE_NAME}${NC}"
echo -e "${BLUE}[${PROJECT_NAME}] Profile Directory: ${PROFILES_DIR}${NC}"
echo -e "${BLUE}[${PROJECT_NAME}] Default Target: ${DEFAULT_TARGET}${NC}"
echo ""

# Default to debug if no command provided
COMMAND=${1:-debug}
shift 2>/dev/null || true  # Remove first argument if it exists

echo -e "${BLUE}[${PROJECT_NAME}] Running: dbt ${COMMAND} --target ${DEFAULT_TARGET} --profiles-dir ${PROFILES_DIR} $@${NC}"
echo ""

# Activate conda environment if available
if command -v conda &> /dev/null; then
    echo -e "${YELLOW}[${PROJECT_NAME}] Activating conda environment: elt${NC}"
    source ~/Applications/anaconda3/etc/profile.d/conda.sh
    conda activate elt
fi

# Run the dbt command with centralized profiles and staging target
if dbt ${COMMAND} --target ${DEFAULT_TARGET} --profiles-dir ${PROFILES_DIR} "$@"; then
    echo ""
    echo -e "${GREEN}[SUCCESS] dbt command completed successfully!${NC}"
    echo -e "${CYAN}=================================================================${NC}"
else
    echo ""
    echo -e "${RED}[ERROR] dbt command failed!${NC}"
    echo -e "${YELLOW}[INFO] Check the output above for error details${NC}"
    echo -e "${CYAN}=================================================================${NC}"
    exit 1
fi
