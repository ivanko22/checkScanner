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

# Build the React app.
RUN npm run build

# Install `serve` globally.
RUN npm install -g serve

# Expose the port the app runs on.
EXPOSE 8080

# Run the web service on container startup.
CMD ["npm", "start"]