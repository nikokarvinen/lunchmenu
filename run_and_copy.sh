#!/bin/bash

# Step 1: Run the container and store its ID
CONTAINER_ID=$(docker run -d lunch_robot)

# Step 2: Wait for the container to complete its execution and discard its output
docker wait "$CONTAINER_ID" > /dev/null

# Step 3: Copy the desired file from the container to the local machine
docker cp "$CONTAINER_ID":/robot/lunchmenu.txt .

# Step 4 (Optional): Remove the container if you don't need it anymore
docker rm "$CONTAINER_ID" > /dev/null

# Step 5: Display the content of the file
cat lunchmenu.txt

# Step 6: Delete the file
rm lunchmenu.txt