# --- CONFIGURATION ---
# Using the Windows Launcher for 3.10 to bypass the 3.13 "ghost"
ifeq ($(OS),Windows_NT)
    PYTHON_BASE = py -3.10
    VENV = .venv_3_10
    VENV_BIN = $(VENV)/Scripts
else
    # EC2 / Linux Compatibility
    PYTHON_BASE = python3.10
    VENV = .venv_3_10
    VENV_BIN = $(VENV)/bin
endif

KERNEL_NAME = pycaret_env_3_10

# --- TARGETS ---
.PHONY: setup install clean run nb-run format lint test test-nb data all

# 1. SETUP: Create the 3.10 venv and upgrade pip
setup:
	@if [ ! -d "$(VENV)" ]; then \
		echo "Creating new Python 3.10 Virtual Environment..."; \
		$(PYTHON_BASE) -m venv $(VENV); \
	else \
		echo "Environment .venv_3_10 already exists. Skipping creation."; \
	fi
	@echo "Upgrading pip inside $(VENV)..."
	@$(VENV_BIN)/python -m pip install --upgrade pip

# 2. INSTALL: Binary-first NumPy (8GB RAM Safety) + Requirements + Kernel
install: setup
	@echo "Installing all requirements from requirements.txt..."
	@$(VENV_BIN)/pip install -r requirements.txt
	@echo "Registering Kernel for VS Code..."
	@$(VENV_BIN)/python -m ipykernel install --user --name=$(KERNEL_NAME)
	
# 3. CLEAN: Safe, explicit removal of venv and kernelspec
clean:
	@echo "Removing Virtual Environment and Jupyter Kernel..."
	@if [ -d "$(VENV)" ]; then rm -rf $(VENV); fi
	@jupyter kernelspec uninstall $(KERNEL_NAME) -f || true
	@echo "Clean complete."

# 4. CODE QUALITY: nbqa for notebooks, ruff/black for scripts
format:
	@echo "Cleaning up imports and linting notebooks..."
	# nbqa runs ruff INSIDE your notebook cells
	@$(VENV_BIN)/nbqa ruff *.ipynb --select I,E,F --fix --unsafe-fixes
	
	# @echo "Cleaning up imports and linting python scripts..."
	# @$(VENV_BIN)/ruff check *.py --select I,E,F --fix --unsafe-fixes
	
	@echo "Formatting code style with Black..."
	@$(VENV_BIN)/nbqa black *.ipynb
	# @$(VENV_BIN)/black *.py

lint:
	@echo "Linting .ipynb and .py files..."
	@$(VENV_BIN)/nbqa pylint --disable=R,C *.ipynb
	@$(VENV_BIN)/pylint --disable=R,C *.py

# 5. TESTING: Logic tests (pytest) and Notebook Integrity (nbconvert)
# test-nb: Runs the notebook and fails if any cell throws an error.
test-nb:
	@echo "Testing Jupyter Notebook integrity (Headless execution)..."
	@$(VENV_BIN)/jupyter nbconvert --to notebook --execute --ExecutePreprocessor.timeout=600 Final_Project.ipynb --output .venv_3_10/test_output.ipynb || (echo "Notebook Test Failed!" && exit 1)

# test: Runs standard pytest for your utility scripts.
test:
	@echo "Running pytest for scripts..."
	@$(VENV_BIN)/pytest -vv

# Change the nb-run target to this:
nb-run:
	@echo "Executing full notebook analysis in-place using .venv_3_10..."
	@$(VENV_BIN)/python -m jupyter nbconvert --to notebook --execute --inplace \
		--ExecutePreprocessor.kernel_name=$(KERNEL_NAME) \
		Final_Project.ipynb

# run: Runs the final energy prediction script.
run:
	@echo "Running production prediction script..."
	@$(VENV_BIN)/python predict_energy.py

# --- DATA TARGET ---
data:
	@echo "Fetching CCPP dataset from Google Storage..."
	@mkdir -p data
	@curl -L "https://storage.googleapis.com/aipi_datasets/CCPP_data.csv" -o data/CCPP_data.csv
	@echo "Data successfully localized to data/CCPP_data.csv"

# 7. ALL-IN-ONE: The full reproduction suite from clean slate to execution.
all: clean install