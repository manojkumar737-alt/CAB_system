# Use a minimal Python image
FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Copy all files into the container
COPY . /app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Open port 80 for web traffic
EXPOSE 80

# Environment variable (optional)
ENV PROJECT_NAME=CabConnect

# Start the application
CMD ["python", "app.py"]
