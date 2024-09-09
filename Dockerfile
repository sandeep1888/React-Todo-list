# Step 1: Use the official Node.js image to create a build
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json (or yarn.lock) into the container
COPY package.json

# Install dependencies
RUN npm install

# Copy the rest of the application code into the container
COPY . .

# Build the React app for production
RUN npm run build

# Step 2: Use Nginx to serve the production build
FROM nginx:alpine

# Copy the build files from the previous step into Nginx's default public folder
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for the Nginx web server
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]
