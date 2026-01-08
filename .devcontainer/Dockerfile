# Use Chainguard Node.js development image (includes Node.js, npm, shell, and apk)
FROM cgr.dev/chainguard/node:latest-dev

# Install additional dependencies
RUN apk update && apk add --no-cache \
    curl \
    tar \
    git \
    ca-certificates

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

# Expose ports for UCM, Unison UI, and MCP Server
EXPOSE 5757 8080 5858

# Default command
CMD ["/bin/bash"]
