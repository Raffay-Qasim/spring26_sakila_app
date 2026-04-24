FROM python:3.9-slim

# Metadata (important for marks)
LABEL maintainer="Abdul Raffay"
LABEL version="1.0"
LABEL description="Optimized Sakila Flask App"

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy only requirements first (better caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy rest of the app
COPY . .

# Environment variables (no hardcoded passwords)
ENV MYSQL_HOST=localhost
ENV MYSQL_USER=root
ENV MYSQL_DB=sakila

# Expose only needed port
EXPOSE 5000

# Healthcheck (important)
HEALTHCHECK CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000')"

# Switch to non-root user
USER appuser

CMD ["python", "app.py"]
