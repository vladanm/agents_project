# Example Research Sessions

## Example 1: Technology Research

```bash
cd /Users/vladanm/projects/agents_project

claude --permission-mode plan

# In Claude:
"I need comprehensive research on Large Language Model optimization techniques.

Focus areas:
1. Current state of the art (2024-2025)
2. Quantization methods and their trade-offs
3. Inference optimization strategies
4. Hardware acceleration approaches
5. Practical implementation considerations

Start with a research plan, then execute using appropriate subagents.
Think deeply about technical challenges and real-world applications."
```

## Example 2: Market Analysis

```bash
claude -p "Research the global electric vehicle battery market:

Key questions:
- Current market size and growth projections
- Major players and market share
- Technology trends (solid-state, lithium alternatives)
- Supply chain challenges
- Regulatory landscape by region

Use source-hunter for market reports and industry analysis.
Use data-extractor for financial data and statistics.
Create comprehensive synthesis with confidence levels."
```

## Example 3: Scientific Literature Review

```bash
# Start with planning
claude --permission-mode plan

"Create a literature review on CRISPR applications in agriculture.

Requirements:
- Cover last 5 years of research
- Include both successful applications and failures
- Regulatory considerations
- Ethical implications
- Commercial viability

/use source-hunter
Find peer-reviewed papers, preferably from high-impact journals.

/use synthesizer  
Create structured literature review with proper citations."
```

## Example 4: Competitive Analysis

```bash
# Use the automated workflow
./workflows/run_research.sh "Competitive analysis of cloud AI platforms (AWS, Google Cloud, Azure)"

# Or run interactively
claude

"/use lead-researcher

Conduct competitive analysis of major cloud AI platforms.

Structure:
1. Service offerings comparison
2. Pricing models
3. Performance benchmarks
4. Ease of integration
5. Customer satisfaction
6. Market positioning

Think deeply about differentiation strategies and future trends."
```

## Example 5: Technical Deep Dive

```bash
claude --permission-mode plan

"Research quantum computing error correction methods.

This is a complex technical topic, so:
- Start with foundational concepts
- Progress to current implementations
- Include mathematical foundations where necessary
- Compare different approaches (surface codes, color codes, etc.)
- Assess practical feasibility

Keep thinking about the theoretical vs practical gaps.
Use extended thinking for complex technical sections."
```

## Example 6: Business Strategy Research

```bash
claude

"Research successful digital transformation strategies in traditional retail.

/use source-hunter
Find case studies from major retailers who successfully transformed.
Look for both successes and failures.

/use data-extractor
Extract financial metrics showing transformation impact.

/use synthesizer
Create framework for successful transformation based on patterns.

/use verifier
Ensure all business metrics are accurate and properly sourced."
```

## Tips for Effective Research Sessions

### 1. Start with Clear Objectives
```bash
"Research [TOPIC] with focus on:
- [Specific question 1]
- [Specific question 2]
- [Key metrics needed]"
```

### 2. Use Extended Thinking for Complex Topics
```bash
"Think deeply about the implications of [finding].
Keep thinking about potential contradictions and edge cases."
```

### 3. Chain Agents Effectively
```bash
"/use source-hunter
Find primary sources on [topic]

/use data-extractor
Extract quantitative data from these sources:
@file:research_outputs/sources.md

/use synthesizer
Combine findings into coherent narrative"
```

### 4. Iterate When Needed
```bash
claude --continue

"The synthesis revealed gaps in [area].
/use source-hunter
Find additional sources specifically on [gap area]"
```

### 5. Request Specific Output Formats
```bash
"Format the research as:
1. Executive summary (3 bullets)
2. Key findings with confidence levels
3. Supporting evidence with citations
4. Gaps and future research needs"
```

## Monitoring Progress

Check agent activity:
```bash
/agents  # View available agents
```

Review intermediate outputs:
```bash
ls research_outputs/latest_session/
cat research_outputs/latest_session/sources.md
```

Resume interrupted research:
```bash
claude --continue
"Continue from the synthesis phase"
```

## Quality Assurance

Always verify critical research:
```bash
"/use verifier

Priority verification for:
- All quantitative claims
- Competitive comparisons
- Future projections
- Technical specifications

Flag any claims that cannot be verified"
```

## Saving and Sharing

Export research:
```bash
# Copy to shared location
cp -r research_outputs/latest_session /path/to/shared/research/

# Create PDF (requires pandoc)
pandoc research_outputs/latest_session/final_report.md -o research_report.pdf
```

Share with team:
```bash
"Create an executive briefing from this research:
@file:research_outputs/latest_session/final_report.md

Format for non-technical stakeholders.
Focus on business implications and actionable insights."
```
