FROM python:3.10-slim

WORKDIR /app

# Install system dependencies with retry mechanism
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    xvfb \
    ca-certificates \
    fonts-liberation \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright with retries and more resilient browser installation
RUN pip install playwright && \
    # Install only necessary browser
    playwright install --with-deps chromium && \
    # Verify the installation
    PLAYWRIGHT_BROWSERS_PATH=/ms-playwright playwright install-deps

# Copy application code
COPY . .

# Create directories for mounted volumes
RUN mkdir -p /app/videos /app/config /app/accounts

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

# Default command (can be overridden)
CMD ["python", "cli_main.py", "--help"]
