# Unison MCP Server Configuration

This document describes the maximal MCP server configuration for the carbon-pipeline Unison project.

## MCP Server Setup

The Unison MCP server is configured in `.mcp.json`:

```json
{
  "mcpServers": {
    "unison": {
      "command": "ucm",
      "args": ["mcp"],
      "transport": "stdio",
      "description": "Unison Codebase Manager MCP server for AI-assisted Unison development"
    }
  }
}
```

## Project Configuration

**Project Name**: `carbon-pipeline`
**Branch**: `main`
**Installed Libraries**:
- `base` (8,725 terms, 191 types) - Unison standard library
- `unison_json_1_3_5` (8,184 terms, 189 types) - JSON parsing and decoding

## Working MCP Tools

### Project Management
- `mcp__unison__get-current-project-context` - Get active project and branch
- `mcp__unison__list-local-projects` - List all projects in codebase
- `mcp__unison__list-project-branches` - List branches in a project

### Library Management
- `mcp__unison__lib-install` - Install libraries from Unison Share
- `mcp__unison__list-project-libraries` - List installed libraries
- `mcp__unison__list-library-definitions` - List definitions in a library

### Code Exploration
- `mcp__unison__list-project-definitions` - List all project definitions
- `mcp__unison__view-definitions` - View source code of definitions
- `mcp__unison__search-definitions-by-name` - Search for definitions by name
- `mcp__unison__search-by-type` - Search for definitions by type signature

### Development Workflow
- `mcp__unison__typecheck-code` - Typecheck Unison code
- `mcp__unison__run` - Execute a main function
- `mcp__unison__run-tests` - Run pure tests
- `mcp__unison__docs` - Fetch documentation for definitions

### Code Organization
- `mcp__unison__list-definition-dependencies` - List dependencies of a definition
- `mcp__unison__list-definition-dependents` - List dependents of a definition
- `mcp__unison__rename-definition` - Rename a definition (final segment only)
- `mcp__unison__move-definition` - Move a definition to a new path
- `mcp__unison__move-to` - Move multiple definitions into a namespace
- `mcp__unison__delete-definitions` - Delete one or more definitions
- `mcp__unison__delete-namespace` - Delete an entire namespace

### Integration Tools
- `mcp__unison__diff-update` - Preview changes before updating (read-only)
- `mcp__unison__share-project-search` - Search Unison Share for projects
- `mcp__unison__share-project-readme` - Fetch README from Unison Share

### Known Issues
- `mcp__unison__update-definitions` - Has parameter parsing issue with JSON objects

## MCP Resources

The MCP server provides the following resources:

- `file://unison-guide` - Complete Unison programming language guide

Access via: `ReadMcpResourceTool` with server="unison"

## Recommended Workflow

### 1. Explore the Codebase
```
mcp__unison__list-project-definitions -> See all definitions
mcp__unison__view-definitions -> View source code
mcp__unison__search-definitions-by-name -> Find specific functions
```

### 2. Typecheck Code
```
mcp__unison__typecheck-code -> Validate syntax and types
```

### 3. Run and Test
```
mcp__unison__run -> Execute IO functions
mcp__unison__run-tests -> Run test suite
```

### 4. Query Documentation
```
mcp__unison__docs -> Read function documentation
ReadMcpResourceTool(file://unison-guide) -> Access language guide
```

### 5. Manage Dependencies
```
mcp__unison__share-project-search -> Find libraries
mcp__unison__lib-install -> Install from Unison Share
```

## Example: Complete MCP Workflow

```javascript
// 1. Check current context
await mcp__unison__get-current-project-context()
// => {projectName: "carbon-pipeline", branchName: "main"}

// 2. Search for a function
await mcp__unison__search-definitions-by-name({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  query: "carbonIntensity"
})

// 3. View its source
await mcp__unison__view-definitions({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  names: ["getCarbonIntensity"]
})

// 4. Check its dependencies
await mcp__unison__list-definition-dependencies({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  definitionName: "getCarbonIntensity"
})

// 5. Run tests
await mcp__unison__run-tests({
  projectContext: {projectName: "carbon-pipeline", branchName: "main"},
  subnamespace: null
})
```

## Benefits of MCP Integration

1. **No Manual UCM Commands**: All operations through typed MCP tools
2. **Type-Safe**: Parameters validated by MCP schema
3. **AI-Assisted**: Claude Code can explore and modify Unison code intelligently
4. **Documentation Access**: Built-in Unison guide via MCP resources
5. **Share Integration**: Search and install libraries from Unison Share
6. **Testing Integration**: Run tests directly from MCP

## Future Enhancements

- Fix `update-definitions` parameter parsing
- Add streaming output for long-running operations
- Add code formatting tools
- Add refactoring tools (extract function, inline, etc.)
