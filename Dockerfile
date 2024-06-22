# Use a base image with OPA pre-installed
FROM openpolicyagent/opa:latest

# Set the working directory
WORKDIR /app

# Copy the OPA policy files to the container
COPY policy.rego /app/policy.rego

# Expose the OPA server port
EXPOSE 8181

# Set the command to start the OPA server
CMD ["run", "--server", "--addr", ":8181", "policy.rego"]