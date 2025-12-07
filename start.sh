#!/usr/bin/env bash

# CharacterGen Launch Script (bash)

set -u

# Prefer python3, fall back to python if needed
PYTHON_BIN="python3"
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PYTHON_BIN="python"
fi

# Check if Python is installed
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "Python is not found! Please install Python 3.x"
  exit 1
fi

# Check Python version is 3.x
if ! "$PYTHON_BIN" -c 'import sys; raise SystemExit(0 if sys.version_info.major == 3 else 1)' >/dev/null 2>&1; then
  echo "Python 3.x is required."
  exit 1
fi

# Check if virtual environment exists
if [ ! -d "venv" ]; then
  echo "Creating virtual environment..."
  "$PYTHON_BIN" -m venv venv || {
    echo "Failed to create virtual environment."
    exit 1
  }
fi

# Activate virtual environment
# shellcheck disable=SC1091
source "venv/bin/activate"

# Ensure pip is available/up to date (optional but helpful)
"$PYTHON_BIN" -m pip --version >/dev/null 2>&1 || {
  echo "pip is not available in the venv."
  deactivate 2>/dev/null || true
  exit 1
}

# Explicitly check and install required packages
if ! "$PYTHON_BIN" -c "import PIL" >/dev/null 2>&1; then
  echo "Installing Pillow..."
  "$PYTHON_BIN" -m pip install Pillow || {
    echo "Failed to install Pillow."
    deactivate 2>/dev/null || true
    exit 1
  }
fi

if ! "$PYTHON_BIN" -c "import yaml" >/dev/null 2>&1; then
  echo "Installing PyYAML..."
  "$PYTHON_BIN" -m pip install pyyaml || {
    echo "Failed to install PyYAML."
    deactivate 2>/dev/null || true
    exit 1
  }
fi

if ! "$PYTHON_BIN" -c "import PyQt6" >/dev/null 2>&1; then
  echo "Installing PyQt6..."
  "$PYTHON_BIN" -m pip install PyQt6 || {
    echo "Failed to install PyQt6."
    deactivate 2>/dev/null || true
    exit 1
  }
fi

if ! "$PYTHON_BIN" -c "import requests" >/dev/null 2>&1; then
  echo "Installing requests..."
  "$PYTHON_BIN" -m pip install requests || {
    echo "Failed to install requests."
    deactivate 2>/dev/null || true
    exit 1
  }
fi

# Launch application
"$PYTHON_BIN" main.py
status=$?

if [ $status -ne 0 ]; then
  echo "Application crashed! Check the logs for details."
fi

# Deactivate virtual environment
deactivate 2>/dev/null || true

exit $status
