#!/bin/bash
# Quick Start Script for Deep Research System

echo "🔬 Deep Research Agentic System - Quick Start"
echo "============================================="
echo ""
echo "Setting up your research environment..."

# Navigate to project
cd /Users/vladanm/projects/agents_project

# Check Claude CLI
if command -v claude &> /dev/null; then
    echo "✓ Claude CLI found"
else
    echo "✗ Claude CLI not found"
    echo "Please install Claude Code CLI first:"
    echo "https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi

echo ""
echo "📚 Available Research Commands:"
echo "-------------------------------"
echo ""
echo "1. Start Interactive Research (Recommended):"
echo "   claude --permission-mode plan"
echo ""
echo "2. Run Automated Research Workflow:"
echo "   ./workflows/run_research.sh \"Your Research Topic\""
echo ""
echo "3. Quick Research:"
echo "   claude -p \"Research [TOPIC]: create comprehensive analysis\""
echo ""
echo "4. View Available Agents:"
echo "   claude"
echo "   /agents"
echo ""
echo "5. Use Specific Agent:"
echo "   claude"
echo "   /use source-hunter"
echo "   \"Find sources on [TOPIC]\""
echo ""
echo "📁 Project Structure:"
echo "--------------------"
echo "• .claude/agents/     - Specialized research agents"
echo "• templates/          - Research templates"
echo "• workflows/          - Automation scripts"
echo "• research_outputs/   - Generated reports"
echo "• examples.md         - Usage examples"
echo ""
echo "🚀 Quick Start Example:"
echo "----------------------"
echo "Try this command to start your first research:"
echo ""
echo "claude --permission-mode plan -p \"Research the impact of AI on software development: find current trends, productivity metrics, and future implications\""
echo ""
echo "📖 For more examples, see: examples.md"
echo "📝 For documentation, see: README.md"
echo ""
echo "Ready to start researching! 🎯"
