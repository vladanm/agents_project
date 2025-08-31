# Deep Research Agentic System

A minimal, Claude Code CLI-based multi-agent system for comprehensive research using subagents, MCP tools, and structured workflows.

## Quick Start

### 1. Initialize the System

```bash
cd /Users/vladanm/projects/agents_project

# Start in Plan Mode (recommended for research planning)
claude --permission-mode plan

# Or start with a specific research topic
claude -p "Research [YOUR TOPIC]: create comprehensive research plan with phases, identify required agents and tools"
```

### 2. Research Workflow

The system follows this pattern:

1. **Planning Phase** (Plan Mode)
   - Define research scope and questions
   - Identify required subagents
   - Plan tool usage and sources
   - Set verification criteria

2. **Execution Phase**
   - Deploy specialized subagents
   - Gather sources (source-hunter)
   - Extract data (data-extractor)
   - Synthesize findings (synthesizer)
   - Verify claims (verifier)

3. **Output Phase**
   - Comprehensive research report
   - Cited sources
   - Confidence assessments
   - Identified gaps

## Available Subagents

The system includes specialized agents in `.claude/agents/`:

- **lead-researcher**: Orchestrates the entire research process
- **source-hunter**: Finds and evaluates sources
- **data-extractor**: Pulls structured data from databases/APIs
- **synthesizer**: Combines findings into insights
- **verifier**: Validates claims and attaches citations

## Usage Examples

### Simple Research Query

```bash
claude -p "Research the current state of quantum computing: 
- Find latest breakthroughs
- Identify key players
- Assess commercial viability
- Think deeply about implications"
```

### Interactive Research Session

```bash
# Start interactive session
claude --permission-mode plan

# In the session:
"I need comprehensive research on sustainable energy storage solutions.
Start by creating a research plan, then execute with appropriate subagents.
Focus on: technology comparison, cost analysis, scalability, and environmental impact."
```

### Using Specific Agents

```bash
# View available agents
/agents

# Use specific agent
/use source-hunter
"Find primary sources on CRISPR gene editing developments in 2024"

# Chain agents
/use data-extractor
"Extract clinical trial data from the sources found"
```

## MCP Tool Integration

Add tools as needed for your research domain:

```bash
# Add web search capability
claude mcp add web-search --scope project

# Add database access
claude mcp add postgres --scope project --env DB_URL=$DATABASE_URL

# Add API access
claude mcp add http api-service https://api.example.com --scope project

# List configured tools
claude mcp list
```

## Research Commands Cheat Sheet

```bash
# Planning
claude --permission-mode plan          # Start in plan mode
claude -p "Plan research on..."       # One-shot planning

# Execution
claude --continue                      # Resume previous session
claude --continue --print "..."       # Continue with instruction

# Agents
/agents                                # View all agents
/use [agent-name]                     # Use specific agent

# Context
@file:path/to/document.md             # Attach file context
@server:resource                      # Attach MCP resource

# Tools
/mcp                                   # Manage MCP tools
claude mcp list                        # List tools
claude mcp add [tool]                  # Add new tool
```

## Extended Thinking

For complex analysis, use thinking cues:

- `"think"` - Basic reasoning
- `"think deeply"` - More thorough analysis  
- `"keep thinking"` - Extended reasoning
- `"think more about edge cases"` - Specific focus

Example:
```
"Think deeply about the implications of this research.
Keep thinking about potential contradictions and biases."
```

## Output Structure

Research outputs are saved in `research_outputs/` with this structure:

```
research_outputs/
  YYYY-MM-DD_topic/
    report.md           # Main research report
    sources.md          # Annotated bibliography
    data/              # Extracted datasets
    notes/             # Working notes
    verification.md    # Fact-checking report
```

## Configuration

### Project Settings (`.claude/settings.json`)

- Default Plan Mode for safety
- Project metadata
- Permission settings

### Adding Custom Agents

Create new agents in `.claude/agents/[agent-name].md`:

```markdown
---
name: your-agent
description: What this agent does
---

Agent instructions and behavior...
```

## Best Practices

1. **Always start with planning** - Use Plan Mode to think through approach
2. **Scale effort to complexity** - Simple queries need fewer agents
3. **Verify critical claims** - Use verifier for important research
4. **Document sources** - Maintain citation trail
5. **Use extended thinking** - For complex analysis points
6. **Iterate when needed** - Research is often non-linear

## Troubleshooting

- **Agents not found**: Check `.claude/agents/` directory
- **Tools not working**: Run `claude mcp list` and check configuration
- **Session lost**: Use `claude --continue` to resume
- **Memory limit**: Break research into phases

## Token Management

Research can be token-intensive. Guidelines:

- Simple research: ~10K tokens
- Medium research: ~50K tokens  
- Deep research: ~200K+ tokens
- Multi-agent: 4-15x single agent cost

Monitor usage and break large research into phases if needed.

## Support

This system follows patterns from Anthropic's production research systems. For more details:

- Extended thinking: See Anthropic's documentation
- Subagents: Check Claude Code docs
- MCP tools: Refer to MCP documentation

Remember: Quality research takes time. Let the agents think deeply when needed.
