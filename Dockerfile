# Use the official Node.js image.
FROM node:18

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install production dependencies.
RUN npm install

# Copy local code to the container image.
COPY . .

# Set environment variables
ENV REACT_APP_DROPBOX_ACCESS_TOKEN=${REACT_APP_DROPBOX_ACCESS_TOKEN}

# Install required tools
RUN apt-get update && apt-get install -y curl jq

# Install `serve` globally.
RUN npm install -g serve

# Make the start script executable
RUN chmod +x start.sh

# Build the React app.
RUN npm run build

# Expose the port the app runs on.
EXPOSE 8080

# Run the start script on container startup.
CMD ["./start.sh"]