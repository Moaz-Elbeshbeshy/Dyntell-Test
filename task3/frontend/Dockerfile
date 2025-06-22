# Use Node.js official image
FROM node:22-slim

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy the frontend folder to app/
COPY . .

# Expose the port your frontend runs on
EXPOSE 3000

# Start the app
CMD ["npm", "start"]