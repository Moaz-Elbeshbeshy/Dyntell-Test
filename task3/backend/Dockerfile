# Use official Python image
FROM python:3.13-slim

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt ./

# Install dependencies globally in the container
RUN pip install  --upgrade pip && \
    pip install -r requirements.txt

# Copy app code
COPY . .

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
ENV FLASK_ENV=development

# Expose port
EXPOSE 3000

# Run Flask
CMD ["flask", "run", "--host=0.0.0.0", "--port=3000"]