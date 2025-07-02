# ---------- Build Stage ----------
FROM python:3.13-slim as build

WORKDIR /app

# Install build dependencies if needed


# Copy requirements first for better cache
COPY requirements.txt ./
RUN pip install  --upgrade pip && \
    pip install --prefix=/install -r requirements.txt

# Copy app code
COPY . .

# ---------- Final Stage ----------
FROM python:3.13-slim

WORKDIR /app

# Copy only installed packages from build stage
COPY --from=build /install /usr/local
COPY --from=build /app /app

# Set environment variables for Flask
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=3000
ENV FLASK_ENV=production

# Expose port
EXPOSE 3000

# Run Flask
CMD ["flask", "run", "--host=0.0.0.0", "--port=3000"]