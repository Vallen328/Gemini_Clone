# Stage 1: Build the application
FROM node:18 AS build
WORKDIR /app

# Copy package.json and package-lock.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Set up Nginx to serve the built application
FROM nginx:alpine

# Copy the build files from the build stage to the Nginx web server
COPY --from=build /app/dist /usr/share/nginx/html

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 for the Nginx server
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
