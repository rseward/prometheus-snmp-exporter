# Change the base image to match Go version 1.22.9
# Step 1: Use the official Golang image as the base
FROM golang:1.22.9

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the Go module files and download dependencies
COPY snmp_exporter-20250119.tar.gz ./
COPY run.sh ./

RUN tar -xzf snmp_exporter-20250119.tar.gz ; \
    ls -la ; \
    chmod +x run.sh


# Step 6: Command to run the application
CMD ["./run.sh"]
