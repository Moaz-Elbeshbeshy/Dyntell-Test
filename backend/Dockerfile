# ---------- Build Stage ----------
    FROM python:3.13-slim AS builder

    WORKDIR /app
    
    COPY requirements.txt ./
    RUN pip install --upgrade pip && \
        pip install --prefix=/install -r requirements.txt
    
    # ---------- Runtime Stage ----------
    FROM python:3.13-slim
    
    WORKDIR /app
    
    # Copy installed packages from builder
    COPY --from=builder /install /usr/local
    
    # Copy app source code
    COPY . .
    
    # Set Flask environment variables
    ENV FLASK_APP=app.py
    ENV FLASK_ENV=production
    
    EXPOSE 5000
    
    # Run the app using ENTRYPOINT and CMD
    ENTRYPOINT ["flask"]
    CMD ["run", "--host=0.0.0.0", "--port=5000"]
    