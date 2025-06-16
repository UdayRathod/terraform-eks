#STAGE 1 : BUILD
# Use official Python SLIM image as base
FROM python:3.12-slim AS build

# Set environment variables to prevent Python from buffering output and writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements & Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --prefix=/install --no-cache-dir -r requirements.txt

#Copy application code
COPY . . 

###############################################################################

#STAGE 2 : DEPLOY

FROM gcr.io/distroless/python3

# Set Python to look for packages in /usr/local (where we copied to from build)
ENV PYTHONPATH="/usr/local/lib/python3.12/site-packages"
ENV FLASK_SECRET_KEY="supersecretkey"

# Copy build stage
COPY --from=build /install /usr/local
COPY --from=build /app /app

# Set working directory
WORKDIR /app

# Expose port
EXPOSE 5000

# Run the app
CMD ["app.py"]