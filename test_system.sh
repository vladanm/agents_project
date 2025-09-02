#!/bin/bash

# Test script for new agents in version 2.0

echo "Testing Enhanced Deep Research System v2.0"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Test function
test_agent() {
    local agent_name=$1
    local agent_file=".claude/agents/${agent_name}.md"
    
    if [ -f "$agent_file" ]; then
        echo -e "${GREEN}✓${NC} Agent '$agent_name' found"
        # Check if file has content
        if [ -s "$agent_file" ]; then
            lines=$(wc -l < "$agent_file")
            echo "  └─ Configuration: $lines lines"
        else
            echo -e "  └─ ${RED}Warning: Configuration file is empty${NC}"
        fi
    else
        echo -e "${RED}✗${NC} Agent '$agent_name' NOT found"
        return 1
    fi
}

# Test all agents
echo "Checking agents..."
echo ""

agents=(
    "lead-researcher"
    "source-hunter"
    "data-extractor"
    "synthesizer"
    "verifier"
    "risk-analyst"          # New in v2.0
    "strategist"            # New in v2.0
    "implementation-specialist"  # New in v2.0
)

failed=0
for agent in "${agents[@]}"; do
    if ! test_agent "$agent"; then
        ((failed++))
    fi
done

echo ""
echo "Checking workflow scripts..."
echo ""

# Check workflow scripts
if [ -x "workflows/run_research.sh" ]; then
    echo -e "${GREEN}✓${NC} Basic workflow script is executable"
else
    echo -e "${RED}✗${NC} Basic workflow script not found or not executable"
    ((failed++))
fi

if [ -x "workflows/run_research_enhanced.sh" ]; then
    echo -e "${GREEN}✓${NC} Enhanced workflow script is executable"
else
    echo -e "${RED}✗${NC} Enhanced workflow script not found or not executable"
    ((failed++))
fi

echo ""
echo "Checking documentation..."
echo ""

# Check documentation
docs=(
    "README.md"
    "IMPROVEMENTS.md"
    "COMPARISON_RESULTS.md"
    "examples.md"
    "templates/research_template.md"
)

for doc in "${docs[@]}"; do
    if [ -f "$doc" ]; then
        echo -e "${GREEN}✓${NC} $doc exists"
    else
        echo -e "${RED}✗${NC} $doc missing"
        ((failed++))
    fi
done

echo ""
echo "Checking Claude CLI..."
echo ""

# Check Claude CLI
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✓${NC} Claude CLI is installed"
    claude --version 2>/dev/null || echo "  └─ Version check not available"
else
    echo -e "${RED}✗${NC} Claude CLI not found"
    echo "  └─ Install from: https://docs.anthropic.com/en/docs/claude-code"
    ((failed++))
fi

echo ""
echo "=========================================="
if [ $failed -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC} System v2.0 is ready for use."
    echo ""
    echo "Quick start commands:"
    echo "  Basic research:    ./workflows/run_research.sh \"Your topic\""
    echo "  Enhanced research: ./workflows/run_research_enhanced.sh \"Your topic\""
    echo "  Interactive:       claude --permission-mode plan"
else
    echo -e "${RED}$failed tests failed.${NC} Please check the issues above."
fi
echo ""

# Show system stats
echo "System Statistics:"
echo "=================="
total_agents=$(ls -1 .claude/agents/*.md 2>/dev/null | wc -l)
echo "Total agents configured: $total_agents"

if [ -d "research_outputs" ]; then
    sessions=$(ls -1d research_outputs/*/ 2>/dev/null | wc -l)
    echo "Research sessions completed: $sessions"
fi

total_lines=$(find . -name "*.md" -type f -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}')
echo "Total documentation lines: $total_lines"

echo ""
echo "Version 2.0 Features:"
echo "- Intermediate persistence ✓"
echo "- Risk analysis ✓"
echo "- Strategic planning ✓"
echo "- Implementation guides ✓"
echo "- Checkpoint recovery ✓"
echo "- 7+ specialized agents ✓"
