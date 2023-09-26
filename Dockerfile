# Use the specified Python version based on Debian Buster
FROM python:3.9-buster

# Set environment variables
ENV PYTHONUNBUFFERED 1

# Set the timezone to Helsinki
ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Update package repositories and install necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl unzip firefox-esr libgtk-3-0 libdbus-glib-1-2 xvfb

# Download and install geckodriver for aarch64
RUN wget -q https://github.com/mozilla/geckodriver/releases/download/v0.33.0/geckodriver-v0.33.0-linux-aarch64.tar.gz && \
    tar -xvzf geckodriver-v0.33.0-linux-aarch64.tar.gz && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin/

# Create a directory for logs
RUN mkdir /logs

# Install the necessary Python libraries
RUN pip install robotframework robotframework-seleniumlibrary

# Copy your scripts into the container
COPY . /robot/
WORKDIR /robot

# Command to run your Robot Framework script
CMD ["robot", "lunch.robot"]

