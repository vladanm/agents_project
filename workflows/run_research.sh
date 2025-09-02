#!/bin/bash

# Deep Research Workflow Runner
# Executes research using Claude Code CLI with subagents

# Configuration
PROJECT_DIR="/Users/vladanm/projects/agents_project"
OUTPUT_DIR="$PROJECT_DIR/research_outputs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Parse command line arguments for verbose flag
VERBOSE_MODE=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE_MODE="--debug --verbose"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS] <research_topic>"
            echo ""
            echo "Options:"
            echo "  -v, --verbose    Enable debug and verbose output from Claude CLI"
            echo "  -h, --help       Show this help message"
            echo ""
            echo "Example:"
            echo "  $0 \"Compare mem0 vs MCP server-memory\""
            echo "  $0 --verbose \"Deep analysis of AI memory systems\""
            exit 0
            ;;
        -*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            TOPIC="$*"
            break
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if claude CLI is available
check_claude() {
    if ! command -v claude &> /dev/null; then
        print_error "Claude CLI not found. Please install Claude Code CLI first."
        exit 1
    fi
    print_success "Claude CLI found"
}

# Create research session directory
create_session_dir() {
    local topic_slug=$(echo "$1" | tr ' ' '_' | tr '[:upper:]' '[:lower:]' | head -c 50)
    SESSION_DIR="$OUTPUT_DIR/${TIMESTAMP}_${topic_slug}"
    mkdir -p "$SESSION_DIR"
    mkdir -p "$SESSION_DIR/data"
    mkdir -p "$SESSION_DIR/notes"
    print_success "Created session directory: $SESSION_DIR"
}

# Initialize research plan
init_research_plan() {
    local topic="$1"
    
    print_header "Phase 1: Research Planning"
    
    # Create research plan using Plan Mode
    claude --strict-mcp-config --mcp-config ./.mcp.json $VERBOSE_MODE --permission-mode plan -p "Create a comprehensive research plan for: $topic

Please:
1. Define specific research questions
2. Identify required subagents (source-hunter, data-extractor, synthesizer, verifier)
3. List needed data sources and tools
4. Create phased execution strategy
5. Set success criteria and deliverables
6. Think deeply about potential challenges and edge cases

Output a structured plan that can guide the research process." > "$SESSION_DIR/research_plan.md"
    
    print_success "Research plan created"
    echo -e "${YELLOW}Review the plan at: $SESSION_DIR/research_plan.md${NC}"
}

# Execute source hunting
run_source_hunter() {
    print_header "Phase 2: Source Discovery"
    
    claude --strict-mcp-config --mcp-config ./.mcp.json $VERBOSE_MODE -p "/use source-hunter

Based on the research plan, find comprehensive sources for: $1

Requirements:
- Find diverse, authoritative sources
- Include primary sources where possible
- Cover different perspectives
- Note source credibility
- Provide direct links

Start with broad searches then narrow based on relevance.
Think about what sources would best answer our research questions." > "$SESSION_DIR/sources.md"
    
    print_success "Source discovery complete"
}

# Extract data
run_data_extraction() {
    print_header "Phase 3: Data Extraction"
    
    claude --strict-mcp-config --mcp-config ./.mcp.json $VERBOSE_MODE -p "/use data-extractor

Extract relevant data from the identified sources for: $1

Focus on:
- Quantitative data
- Key statistics
- Structured information
- Temporal data
- Comparative metrics

Document all queries and extraction methods.
Save raw data for verification." > "$SESSION_DIR/data/extracted_data.md"
    
    print_success "Data extraction complete"
}

# Synthesize findings
run_synthesis() {
    print_header "Phase 4: Synthesis"
    
    claude --strict-mcp-config --mcp-config ./.mcp.json $VERBOSE_MODE -p "/use synthesizer

Synthesize all findings for: $1

Input files:
@file:$SESSION_DIR/sources.md
@file:$SESSION_DIR/data/extracted_data.md

Create comprehensive synthesis:
- Answer all research questions
- Identify patterns and insights
- Reconcile conflicting information
- Note confidence levels
- Highlight key findings
- Document gaps

Think deeply about implications and connections." > "$SESSION_DIR/synthesis.md"
    
    print_success "Synthesis complete"
}

# Verify and finalize
run_verification() {
    print_header "Phase 5: Verification"
    
    claude --strict-mcp-config --mcp-config ./.mcp.json $VERBOSE_MODE -p "/use verifier

Verify all claims in the synthesis for: $1

Input file:
@file:$SESSION_DIR/synthesis.md

Tasks:
- Check every factual claim
- Attach proper citations
- Assess confidence levels
- Flag unsupported assertions
- Suggest corrections

Output both verified report and verification notes." > "$SESSION_DIR/verification.md"
    
    print_success "Verification complete"
}

# Generate final report
generate_final_report() {
    print_header "Phase 6: Final Report Generation"
    
    claude --strict-mcp-config --mcp-config ./.mcp.json $VERBOSE_MODE -p "/use lead-researcher

Generate the final research report for: $1

Input files:
@file:$SESSION_DIR/synthesis.md
@file:$SESSION_DIR/verification.md
@file:$SESSION_DIR/sources.md

Create professional research report with:
1. Executive Summary
2. Introduction & Context
3. Methodology
4. Key Findings (with citations)
5. Detailed Analysis
6. Implications & Insights
7. Recommendations
8. Limitations & Future Research
9. References

Ensure all claims are properly cited and confidence levels are clear." > "$SESSION_DIR/final_report.md"
    
    print_success "Final report generated"
}

# Main execution
main() {
    print_header "Deep Research System"
    
    # Check prerequisites
    check_claude
    
    # Show verbose mode status
    if [ -n "$VERBOSE_MODE" ]; then
        print_warning "Verbose mode enabled: Claude CLI will show debug output"
    fi
    
    # Get research topic if not provided via arguments
    if [ -z "$TOPIC" ]; then
        echo -e "${YELLOW}Enter your research topic:${NC}"
        read -r TOPIC
    fi
    
    if [ -z "$TOPIC" ]; then
        print_error "No research topic provided"
        exit 1
    fi
    
    echo -e "${GREEN}Research Topic: $TOPIC${NC}"
    
    # Create session directory
    create_session_dir "$TOPIC"
    
    # Run research phases
    init_research_plan "$TOPIC"
    
    echo -e "${YELLOW}Review the research plan before continuing...${NC}"
    echo "Press Enter to continue with source discovery, or Ctrl+C to stop"
    read -r
    
    run_source_hunter "$TOPIC"
    run_data_extraction "$TOPIC"
    run_synthesis "$TOPIC"
    run_verification "$TOPIC"
    generate_final_report "$TOPIC"
    
    # Summary
    print_header "Research Complete!"
    echo -e "${GREEN}Research outputs saved to:${NC}"
    echo "$SESSION_DIR"
    echo ""
    echo "Files generated:"
    echo "  - research_plan.md"
    echo "  - sources.md"
    echo "  - data/extracted_data.md"
    echo "  - synthesis.md"
    echo "  - verification.md"
    echo "  - final_report.md"
    echo ""
    echo -e "${BLUE}View final report:${NC}"
    echo "cat $SESSION_DIR/final_report.md"
}

# Run main function with all arguments
main "$@"
