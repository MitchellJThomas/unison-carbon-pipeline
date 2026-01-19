# Use Chainguard Node.js development image (includes Node.js, npm, shell, and apk)
FROM cgr.dev/chainguard/node:latest-dev

# Switch to root for package installations
USER root

# Install additional dependencies
RUN apk update && apk add --no-cache \
    curl \
    git \
    ca-certificates \
    libarchive-tools \
    openssh-client

# Download and install Unison UCM
ARG UNISON_VERSION=latest
RUN mkdir -p /opt/unison && \
    curl -L https://github.com/unisonweb/unison/releases/${UNISON_VERSION}/download/ucm-linux-x64.tar.gz \
    | tar -xz -C /opt/unison && \
    ln -s /opt/unison/ucm /usr/local/bin/ucm

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

# Install beads (bd CLI) using the official install script
RUN curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

# Set up workspace directory
WORKDIR /workspace

# Create .unison directory for codebase
RUN mkdir -p /root/.unison

# Create directory for Claude Code data
RUN mkdir -p /root/.claude

# Copy MCP server startup script
COPY start-mcp-server.sh /usr/local/bin/start-mcp-server
RUN chmod +x /usr/local/bin/start-mcp-server

# Copy bootstrap script for initializing the Unison project
COPY bootstrap-unison-project.sh /usr/local/bin/bootstrap-unison-project
RUN chmod +x /usr/local/bin/bootstrap-unison-project

# Expose ports for UCM, Unison UI, and MCP Server
EXPOSE 5757 8080 5858

# Override the Node.js entrypoint to use shell
ENTRYPOINT ["/bin/sh", "-c"]

# Default command
CMD ["/bin/bash"]
