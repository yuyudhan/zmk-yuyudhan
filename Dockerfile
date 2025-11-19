FROM zmkfirmware/zmk-build-arm:stable

WORKDIR /workspace

# Copy the config files
COPY config/ config/
COPY build.yaml .

# Initialize west workspace
RUN west init -l config/

# Update west dependencies
RUN west update

# Set default command to show help
CMD ["west", "build", "--help"]
