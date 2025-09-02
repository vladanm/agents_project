#!/bin/bash

# Deep Research Workflow Runner - Enhanced Version
# Executes research using Claude Code CLI with subagents and intermediate persistence

# Configuration
PROJECT_DIR="/Users/vladanm/projects/agents_project"
OUTPUT_DIR="$PROJECT_DIR/research_outputs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

print_info() {
    echo -e "${CYAN}ℹ $1${NC}"
}

# Check if claude CLI is available
check_claude() {
    if ! command -v claude &> /dev/null; then
        print_error "Claude CLI not found. Please install Claude Code CLI first."
        exit 1
    fi
    print_success "Claude CLI found"
}

# Create research session directory with subdirectories
create_session_dir() {
    local topic_slug=$(echo "$1" | tr ' ' '_' | tr '[:upper:]' '[:lower:]' | head -c 50)
    SESSION_DIR="$OUTPUT_DIR/${TIMESTAMP}_${topic_slug}"
    
    # Create main directory and subdirectories
    mkdir -p "$SESSION_DIR"/{planning,discovery,analysis,strategy,implementation,final}
    mkdir -p "$SESSION_DIR"/data
    mkdir -p "$SESSION_DIR"/notes
    
    print_success "Created session directory: $SESSION_DIR"
    
    # Create session metadata
    cat > "$SESSION_DIR/session_info.md" << EOF
# Research Session Information

- **Topic**: $1
- **Started**: $(date)
- **Session ID**: ${TIMESTAMP}_${topic_slug}
- **Researcher**: $(whoami)

## Directory Structure
- \`planning/\` - Research plans and agent assignments
- \`discovery/\` - Source collection and data extraction
- \`analysis/\` - Synthesis and risk assessment
- \`strategy/\` - Strategic recommendations
- \`implementation/\` - Code examples and guides
- \`final/\` - Final reports and summaries
EOF
    
    print_info "Session metadata created"
}

# Initialize research plan
init_research_plan() {
    local topic="$1"
    
    print_header "Phase 1: Research Planning"
    
    # Create research plan using Plan Mode with intermediate save
    claude --permission-mode plan -p "Create a comprehensive research plan for: $topic

Please:
1. Define specific research questions
2. Identify required subagents (source-hunter, data-extractor, synthesizer, verifier, risk-analyst, strategist, implementation-specialist)
3. List needed data sources and tools
4. Create phased execution strategy
5. Set success criteria and deliverables
6. Think deeply about potential challenges and edge cases
7. Plan for intermediate persistence at each phase

Output a structured plan that can guide the research process.
Save key decisions and rationale." > "$SESSION_DIR/planning/research_plan.md"
    
    print_success "Research plan created"
    print_info "Plan saved to: $SESSION_DIR/planning/research_plan.md"
    
    # Create agent assignment document
    cat > "$SESSION_DIR/planning/agent_assignments.md" << EOF
# Agent Assignments for Research

## Topic: $topic

### Phase 1: Discovery
- **source-hunter**: Find comprehensive sources
- **data-extractor**: Extract structured data

### Phase 2: Analysis  
- **synthesizer**: Create coherent synthesis
- **verifier**: Validate claims and citations
- **risk-analyst**: Assess risks and uncertainties

### Phase 3: Strategy
- **strategist**: Develop recommendations
- **implementation-specialist**: Provide code examples

### Phase 4: Finalization
- **lead-researcher**: Final report compilation
- **verifier**: Final validation pass
EOF
    
    print_success "Agent assignments documented"
}

# Execute source hunting
run_source_hunter() {
    print_header "Phase 2: Source Discovery"
    
    claude -p "/use source-hunter

Based on the research plan, find comprehensive sources for: $1

Requirements:
- Find diverse, authoritative sources
- Include primary sources where possible
- Cover different perspectives
- Note source credibility
- Provide direct links
- Save intermediate findings

Start with broad searches then narrow based on relevance.
Think about what sources would best answer our research questions.

Output file: $SESSION_DIR/discovery/sources.md" > "$SESSION_DIR/discovery/sources.md"
    
    print_success "Source discovery complete"
    print_info "Sources saved to: $SESSION_DIR/discovery/sources.md"
}

# Extract data
run_data_extraction() {
    print_header "Phase 2b: Data Extraction"
    
    claude -p "/use data-extractor

Extract relevant data from the identified sources for: $1

Input: @file:$SESSION_DIR/discovery/sources.md

Focus on:
- Quantitative data
- Key statistics  
- Structured information
- Temporal data
- Comparative metrics

Document all queries and extraction methods.
Save raw data for verification.

Output to: $SESSION_DIR/discovery/extracted_data.md" > "$SESSION_DIR/discovery/extracted_data.md"
    
    print_success "Data extraction complete"
    print_info "Data saved to: $SESSION_DIR/discovery/extracted_data.md"
}

# Run risk analysis
run_risk_analysis() {
    print_header "Phase 3a: Risk Assessment"
    
    claude -p "/use risk-analyst

Analyze risks for: $1

Input files:
@file:$SESSION_DIR/discovery/sources.md
@file:$SESSION_DIR/discovery/extracted_data.md

Assess:
- Technical risks
- Business risks
- Strategic risks
- Implementation challenges
- Mitigation strategies

Provide risk matrix and mitigation roadmap.

Output to: $SESSION_DIR/analysis/risk_assessment.md" > "$SESSION_DIR/analysis/risk_assessment.md"
    
    print_success "Risk analysis complete"
    print_info "Risk assessment saved to: $SESSION_DIR/analysis/risk_assessment.md"
}

# Synthesize findings
run_synthesis() {
    print_header "Phase 3b: Synthesis"
    
    claude -p "/use synthesizer

Synthesize all findings for: $1

Input files:
@file:$SESSION_DIR/discovery/sources.md
@file:$SESSION_DIR/discovery/extracted_data.md
@file:$SESSION_DIR/analysis/risk_assessment.md

Create comprehensive synthesis:
- Answer all research questions
- Identify patterns and insights
- Reconcile conflicting information
- Note confidence levels
- Highlight key findings
- Document gaps

Think deeply about implications and connections.

Output to: $SESSION_DIR/analysis/synthesis.md" > "$SESSION_DIR/analysis/synthesis.md"
    
    print_success "Synthesis complete"
    print_info "Synthesis saved to: $SESSION_DIR/analysis/synthesis.md"
}

# Verify and finalize
run_verification() {
    print_header "Phase 3c: Verification"
    
    claude -p "/use verifier

Verify all claims in the synthesis for: $1

Input file:
@file:$SESSION_DIR/analysis/synthesis.md

Tasks:
- Check every factual claim
- Attach proper citations
- Assess confidence levels
- Flag unsupported assertions
- Suggest corrections

Output both verified report and verification notes.

Verified report to: $SESSION_DIR/analysis/verified_synthesis.md
Notes to: $SESSION_DIR/analysis/verification_notes.md" > "$SESSION_DIR/analysis/verified_synthesis.md"
    
    print_success "Verification complete"
    print_info "Verified synthesis saved"
}

# Generate strategic recommendations
run_strategy() {
    print_header "Phase 4a: Strategic Recommendations"
    
    claude -p "/use strategist

Develop strategic recommendations for: $1

Input files:
@file:$SESSION_DIR/analysis/verified_synthesis.md
@file:$SESSION_DIR/analysis/risk_assessment.md

Create:
- Strategic options analysis
- Primary recommendation with rationale
- Implementation roadmap
- Context-specific variations
- Decision framework
- Success metrics

Output to: $SESSION_DIR/strategy/recommendations.md" > "$SESSION_DIR/strategy/recommendations.md"
    
    print_success "Strategic recommendations complete"
    print_info "Strategy saved to: $SESSION_DIR/strategy/recommendations.md"
}

# Generate implementation guide
run_implementation() {
    print_header "Phase 4b: Implementation Guide"
    
    claude -p "/use implementation-specialist

Create implementation guide for: $1

Input files:
@file:$SESSION_DIR/strategy/recommendations.md
@file:$SESSION_DIR/analysis/verified_synthesis.md

Provide:
- Working code examples
- Architecture patterns
- Deployment strategies
- Configuration templates
- Testing approaches
- Performance optimization

Output to: $SESSION_DIR/implementation/guide.md" > "$SESSION_DIR/implementation/guide.md"
    
    print_success "Implementation guide complete"
    print_info "Guide saved to: $SESSION_DIR/implementation/guide.md"
}

# Generate final report
generate_final_report() {
    print_header "Phase 5: Final Report Generation"
    
    claude -p "/use lead-researcher

Generate the final research report for: $1

Input files:
@file:$SESSION_DIR/analysis/verified_synthesis.md
@file:$SESSION_DIR/analysis/risk_assessment.md
@file:$SESSION_DIR/strategy/recommendations.md
@file:$SESSION_DIR/implementation/guide.md
@file:$SESSION_DIR/discovery/sources.md

Create professional research report with:
1. Executive Summary
2. Introduction & Context
3. Methodology
4. Key Findings (with citations)
5. Detailed Analysis
6. Risk Assessment
7. Strategic Recommendations
8. Implementation Roadmap
9. Implications & Insights
10. Limitations & Future Research
11. References

Ensure all claims are properly cited and confidence levels are clear.

Output to: $SESSION_DIR/final/comprehensive_report.md" > "$SESSION_DIR/final/comprehensive_report.md"
    
    print_success "Final report generated"
    print_info "Report saved to: $SESSION_DIR/final/comprehensive_report.md"
    
    # Generate executive summary
    claude -p "Create a 1-2 page executive summary of this research:
    
@file:$SESSION_DIR/final/comprehensive_report.md

Focus on:
- Key findings (3-5 bullets)
- Primary recommendation
- Critical risks
- Implementation timeline
- Success metrics

Make it scannable for executives.

Output to: $SESSION_DIR/final/executive_summary.md" > "$SESSION_DIR/final/executive_summary.md"
    
    print_success "Executive summary generated"
}

# Generate progress report
generate_progress_report() {
    cat > "$SESSION_DIR/progress_report.md" << EOF
# Research Progress Report

## Session: ${TIMESTAMP}_${TOPIC}

### Completed Phases
$(ls -la "$SESSION_DIR"/*/*.md 2>/dev/null | wc -l) files generated

### Files Generated
$(find "$SESSION_DIR" -name "*.md" -type f -exec basename {} \; | sort)

### Directory Sizes
$(du -sh "$SESSION_DIR"/* | sort -h)

### Timeline
- Started: $(head -n 10 "$SESSION_DIR/session_info.md" | grep Started | cut -d: -f2-)
- Current: $(date)

### Next Steps
Review the following key documents:
1. Executive Summary: final/executive_summary.md
2. Full Report: final/comprehensive_report.md
3. Implementation Guide: implementation/guide.md
4. Risk Assessment: analysis/risk_assessment.md
EOF
    
    print_info "Progress report updated"
}

# Main execution
main() {
    print_header "Deep Research System - Enhanced Version"
    
    # Check prerequisites
    check_claude
    
    # Get research topic
    if [ $# -eq 0 ]; then
        echo -e "${YELLOW}Enter your research topic:${NC}"
        read -r TOPIC
    else
        TOPIC="$*"
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
    echo -e "${CYAN}Plan location: $SESSION_DIR/planning/research_plan.md${NC}"
    echo "Press Enter to continue with source discovery, or Ctrl+C to stop"
    read -r
    
    # Discovery Phase
    run_source_hunter "$TOPIC"
    run_data_extraction "$TOPIC"
    
    # Analysis Phase
    run_risk_analysis "$TOPIC"
    run_synthesis "$TOPIC"
    run_verification "$TOPIC"
    
    # Strategy Phase
    run_strategy "$TOPIC"
    run_implementation "$TOPIC"
    
    # Final Phase
    generate_final_report "$TOPIC"
    
    # Generate progress report
    generate_progress_report
    
    # Summary
    print_header "Research Complete!"
    echo -e "${GREEN}Research outputs saved to:${NC}"
    echo "$SESSION_DIR"
    echo ""
    echo -e "${CYAN}Key Documents:${NC}"
    echo "  📊 Executive Summary: final/executive_summary.md"
    echo "  📚 Full Report: final/comprehensive_report.md"
    echo "  🚀 Implementation: implementation/guide.md"
    echo "  ⚠️  Risk Assessment: analysis/risk_assessment.md"
    echo "  🎯 Strategy: strategy/recommendations.md"
    echo ""
    echo -e "${BLUE}Quick Access Commands:${NC}"
    echo "View executive summary:"
    echo "  cat $SESSION_DIR/final/executive_summary.md"
    echo ""
    echo "View full report:"
    echo "  cat $SESSION_DIR/final/comprehensive_report.md"
    echo ""
    echo "Open in VS Code:"
    echo "  code $SESSION_DIR"
}

# Run main function with all arguments
main "$@"
