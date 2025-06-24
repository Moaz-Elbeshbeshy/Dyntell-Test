# ---------- Build Stage ----------
    FROM node:22 as build
    WORKDIR /app
    
    # Copy package files first (better caching)
    COPY ./package*.json ./
    
    # Install dependencies
    RUN npm ci
    
    # Copy rest of the frontend code and build
    COPY . .
    RUN npm run build
    
    # ---------- Production Stage ----------
    FROM nginx:alpine
    COPY --from=build /app/build /usr/share/nginx/html
    
    # Expose default nginx port
    EXPOSE 80
    
    # Run nginx
    CMD ["nginx", "-g", "daemon off;"]
    