# Document Project Architecture Command

You are generating brownfield project architecture documentation. Your job is to investigate the existing codebase and create comprehensive architecture documentation.

## Instructions

Follow this workflow strictly:

### 1. Acknowledge and Gather Context

When this command is invoked, respond with:

```
I'll help you document your project's architecture. Let me investigate the codebase to understand its structure and patterns.
```

Then immediately begin investigation (do not wait for user input unless project type cannot be detected).

### 2. Detect Project Type

Auto-detect the project type by checking for indicator files:

**Flutter Project:**
- `pubspec.yaml` with `flutter:` section
- `lib/` directory with Dart files
- Flutter dependencies in pubspec.yaml

**Dart Package:**
- `pubspec.yaml` without `flutter:` section
- `lib/` directory with Dart files
- Dart-only dependencies

**Node.js/JavaScript:**
- `package.json` present
- `node_modules/` directory
- JavaScript/TypeScript files

**Python:**
- `requirements.txt`, `setup.py`, or `pyproject.toml`
- Python files (`.py`)

**Other:**
- Ask user to specify project type

### 3. Investigate Codebase

Use the Task tool with `subagent_type=Explore` to gather comprehensive context:

**For All Projects:**
- Overall directory structure
- Main entry points
- Configuration files
- Build/deployment setup
- Testing structure
- Documentation that already exists

**For Flutter/Dart Projects:**
- Widget tree structure
- State management approach (Provider, Bloc, Riverpod, GetX, etc.)
- Navigation patterns (Navigator 1.0, 2.0, go_router, etc.)
- Key screens/pages
- Shared widgets and components
- Data models and services
- API integration patterns
- Local storage approach
- Third-party packages and their purposes
- Platform-specific code (iOS/Android/Web/Desktop)

**For Other Project Types:**
- Framework and libraries used
- Architecture patterns (MVC, MVVM, Clean Architecture, etc.)
- Data flow and state management
- API/backend integration
- Database schema (if applicable)
- Authentication/authorization approach

### 4. Build Architecture Documentation

Generate comprehensive documentation using the embedded template below, populated with investigation findings.

Select the appropriate template based on project type:

#### Flutter/Dart App Template

```markdown
# {{PROJECT_NAME}} - Architecture Documentation

> **Generated:** {{DATE}}
> **Type:** Flutter Application
> **Last Updated:** {{DATE}}

---

## Table of Contents

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [Architecture Patterns](#architecture-patterns)
4. [State Management](#state-management)
5. [Navigation](#navigation)
6. [Data Layer](#data-layer)
7. [Key Components](#key-components)
8. [Third-Party Packages](#third-party-packages)
9. [Platform-Specific Code](#platform-specific-code)
10. [Build & Deployment](#build--deployment)
11. [Testing Strategy](#testing-strategy)
12. [Known Issues & Technical Debt](#known-issues--technical-debt)

---

## Overview

**Project Name:** {{PROJECT_NAME}}
**Description:** {{PROJECT_DESCRIPTION}}
**Target Platforms:** {{PLATFORMS}}
**Flutter Version:** {{FLUTTER_VERSION}}
**Dart Version:** {{DART_VERSION}}

### Purpose
{{PROJECT_PURPOSE}}

### Key Features
{{KEY_FEATURES}}

---

## Project Structure

```
{{DIRECTORY_TREE}}
```

### Directory Breakdown

**`lib/`** - Main application code
{{LIB_STRUCTURE}}

**`test/`** - Unit and widget tests
{{TEST_STRUCTURE}}

**`assets/`** - Images, fonts, and other static resources
{{ASSETS_STRUCTURE}}

**`platform/`** - Platform-specific code (iOS, Android, etc.)
{{PLATFORM_STRUCTURE}}

---

## Architecture Patterns

**Primary Pattern:** {{ARCHITECTURE_PATTERN}}

{{ARCHITECTURE_DESCRIPTION}}

### Design Principles
{{DESIGN_PRINCIPLES}}

### Code Organization
{{CODE_ORGANIZATION}}

---

## State Management

**Approach:** {{STATE_MANAGEMENT}}

{{STATE_MANAGEMENT_DETAILS}}

### State Flow
{{STATE_FLOW_DIAGRAM}}

### Key State Objects
{{STATE_OBJECTS}}

---

## Navigation

**Strategy:** {{NAVIGATION_STRATEGY}}

{{NAVIGATION_DETAILS}}

### Route Structure
{{ROUTES}}

### Deep Linking
{{DEEP_LINKING}}

---

## Data Layer

### Models
{{DATA_MODELS}}

### Services
{{SERVICES}}

### API Integration
{{API_INTEGRATION}}

### Local Storage
{{LOCAL_STORAGE}}

### Caching Strategy
{{CACHING}}

---

## Key Components

### Screens/Pages
{{SCREENS}}

### Shared Widgets
{{SHARED_WIDGETS}}

### Custom Components
{{CUSTOM_COMPONENTS}}

---

## Third-Party Packages

### Core Dependencies
{{CORE_PACKAGES}}

### Development Dependencies
{{DEV_PACKAGES}}

### Package Justification
{{PACKAGE_RATIONALE}}

---

## Platform-Specific Code

### iOS
{{IOS_SPECIFIC}}

### Android
{{ANDROID_SPECIFIC}}

### Web
{{WEB_SPECIFIC}}

### Desktop (macOS/Windows/Linux)
{{DESKTOP_SPECIFIC}}

---

## Build & Deployment

### Build Configuration
{{BUILD_CONFIG}}

### Environment Setup
{{ENV_SETUP}}

### Deployment Process
{{DEPLOYMENT}}

### CI/CD
{{CICD}}

---

## Testing Strategy

### Unit Tests
{{UNIT_TESTS}}

### Widget Tests
{{WIDGET_TESTS}}

### Integration Tests
{{INTEGRATION_TESTS}}

### Test Coverage
{{COVERAGE}}

---

## Known Issues & Technical Debt

### Current Issues
{{KNOWN_ISSUES}}

### Technical Debt
{{TECH_DEBT}}

### Future Improvements
{{IMPROVEMENTS}}

---

**Document Version:** 1.0
**Last Reviewed:** {{DATE}}
**Maintained By:** {{MAINTAINER}}
```

#### Generic Project Template

```markdown
# {{PROJECT_NAME}} - Architecture Documentation

> **Generated:** {{DATE}}
> **Type:** {{PROJECT_TYPE}}
> **Last Updated:** {{DATE}}

---

## Table of Contents

1. [Overview](#overview)
2. [Project Structure](#project-structure)
3. [Architecture Patterns](#architecture-patterns)
4. [Technology Stack](#technology-stack)
5. [Data Layer](#data-layer)
6. [Key Components](#key-components)
7. [Dependencies](#dependencies)
8. [Build & Deployment](#build--deployment)
9. [Testing Strategy](#testing-strategy)
10. [Known Issues & Technical Debt](#known-issues--technical-debt)

---

## Overview

**Project Name:** {{PROJECT_NAME}}
**Description:** {{PROJECT_DESCRIPTION}}
**Type:** {{PROJECT_TYPE}}
**Version:** {{VERSION}}

### Purpose
{{PROJECT_PURPOSE}}

### Key Features
{{KEY_FEATURES}}

---

## Project Structure

```
{{DIRECTORY_TREE}}
```

### Directory Breakdown
{{DIRECTORY_DETAILS}}

---

## Architecture Patterns

**Primary Pattern:** {{ARCHITECTURE_PATTERN}}

{{ARCHITECTURE_DESCRIPTION}}

### Design Principles
{{DESIGN_PRINCIPLES}}

### Code Organization
{{CODE_ORGANIZATION}}

---

## Technology Stack

### Languages
{{LANGUAGES}}

### Frameworks
{{FRAMEWORKS}}

### Libraries
{{LIBRARIES}}

### Tools
{{TOOLS}}

---

## Data Layer

### Data Models
{{DATA_MODELS}}

### Services
{{SERVICES}}

### API Integration
{{API_INTEGRATION}}

### Data Storage
{{DATA_STORAGE}}

---

## Key Components

### Core Modules
{{CORE_MODULES}}

### Shared Components
{{SHARED_COMPONENTS}}

### Utilities
{{UTILITIES}}

---

## Dependencies

### Production Dependencies
{{PROD_DEPENDENCIES}}

### Development Dependencies
{{DEV_DEPENDENCIES}}

### Dependency Rationale
{{DEPENDENCY_RATIONALE}}

---

## Build & Deployment

### Build Process
{{BUILD_PROCESS}}

### Environment Configuration
{{ENV_CONFIG}}

### Deployment Strategy
{{DEPLOYMENT}}

### CI/CD Pipeline
{{CICD}}

---

## Testing Strategy

### Test Types
{{TEST_TYPES}}

### Test Coverage
{{COVERAGE}}

### Testing Tools
{{TEST_TOOLS}}

---

## Known Issues & Technical Debt

### Current Issues
{{KNOWN_ISSUES}}

### Technical Debt
{{TECH_DEBT}}

### Planned Improvements
{{IMPROVEMENTS}}

---

**Document Version:** 1.0
**Last Reviewed:** {{DATE}}
**Maintained By:** {{MAINTAINER}}
```

### 5. Populate Template

Replace all `{{PLACEHOLDERS}}` with findings from investigation:

- Use actual code examples where relevant
- Include file paths and line numbers for reference
- Link to related documentation
- Be specific and factual (not generic)
- Include diagrams in mermaid format when helpful
- Document **why** decisions were made, not just **what** exists

**Key placeholders to fill:**
- `{{PROJECT_NAME}}`: From pubspec.yaml, package.json, or directory name
- `{{DATE}}`: Current date
- `{{DIRECTORY_TREE}}`: Actual project structure (use `tree -L 3 -I 'node_modules|.git|build'` or similar)
- `{{STATE_MANAGEMENT}}`: Detected state management (e.g., "Provider with ChangeNotifier")
- `{{NAVIGATION_STRATEGY}}`: Detected navigation (e.g., "go_router with declarative routing")
- All other placeholders based on investigation findings

### 6. Choose Output Location

**Default paths by project type:**
- Flutter/Dart: `docs/architecture/overview.md`
- Other: `docs/architecture.md`

**If docs directory doesn't exist:**
- Ask user: "Should I create the `docs/` directory? (yes/no)"
- Wait for confirmation before creating

### 7. Preview & Confirm

Present a preview showing:

```
═══════════════════════════════════════
ARCHITECTURE DOCUMENTATION PREVIEW
═══════════════════════════════════════
Project: {{PROJECT_NAME}}
Type: {{PROJECT_TYPE}}
Output: {{OUTPUT_PATH}}

Document includes:
- {{SECTION_COUNT}} main sections
- {{FINDINGS_COUNT}} key findings
- {{COMPONENT_COUNT}} documented components

───────────────────────────────────────
SAMPLE SECTIONS:
───────────────────────────────────────
[Show first 50 lines of generated doc]
...
═══════════════════════════════════════
```

**Ask explicitly:** "Should I create this architecture document at `{{OUTPUT_PATH}}`?"

**STOP and wait for approval.** User can request:
- Changes to content or structure
- Different output path
- More investigation in specific areas
- Manual editing before creation

### 8. Create Documentation (Only After Approval)

**Only after explicit approval:**

1. Create directory structure if needed
2. Write documentation file using Write tool
3. Confirm creation with file path

### 9. Next Steps

After successful creation, display:

```
✅ Architecture Documentation Created

File: {{OUTPUT_PATH}}
Sections: {{SECTION_COUNT}}

Next steps:
- Review and refine the generated documentation
- Add diagrams or examples where needed
- Update README.md to link to this document: /index-docs
- Keep this document updated as architecture evolves

Suggested commands:
- /index-docs - Add this doc to README index
- /create-doc - Create additional supporting documentation
```

## Tool Preferences

- **Primary Investigation:** Use Task tool with `subagent_type=Explore` for codebase analysis
- **File Operations:** Use Read, Write, and Glob tools for file operations
- **Project Detection:** Use Glob to find indicator files (pubspec.yaml, package.json, etc.)

## What This Command Does vs Does NOT Do

✅ **This command DOES:**
- Auto-detect project type and structure
- Investigate existing codebase thoroughly
- Generate comprehensive architecture documentation
- Support Flutter/Dart and generic projects
- Create well-structured markdown documentation
- Ask for confirmation before creating files

❌ **This command does NOT:**
- Modify existing code
- Create project files (only documentation)
- Execute builds or tests
- Make architectural changes
- Commit changes to git (user decides)

## Special Considerations

### For Flutter Projects
- Document widget tree hierarchy
- Identify state management patterns (Provider, Bloc, Riverpod, GetX, etc.)
- Note navigation approach (Navigator 1.0/2.0, go_router, auto_route, etc.)
- Document platform-specific implementations
- Include pub.dev package references with versions

### For Brownfield Projects
- Document **current state**, not ideal state
- Note technical debt and known issues honestly
- Include rationale for existing patterns
- Document dependencies on legacy systems
- Highlight areas needing improvement

### Investigation Tips
- Look for README files and existing documentation first
- Check git history for architectural decisions (`git log --oneline --all`)
- Identify patterns by looking at multiple similar files
- Note inconsistencies (they indicate evolution or technical debt)
- Document **why** things are the way they are, not just **what** they are

## Usage Examples

**Example 1 - Flutter App:**
```
User: /doc-project
Assistant: I'll help you document your project's architecture. Let me investigate the codebase...

[Investigates codebase]

Found Flutter application with:
- Provider state management
- go_router navigation
- REST API integration via http package
- 15 screens, 23 shared widgets
- Hive for local storage

[Shows preview of generated documentation]

Should I create this architecture document at `docs/architecture/overview.md`?

User: yes
Assistant: ✅ Architecture Documentation Created
File: docs/architecture/overview.md
...
```

**Example 2 - Node.js API:**
```
User: /doc-project
Assistant: I'll help you document your project's architecture...

[Investigates codebase]

Found Node.js Express API with:
- MVC architecture pattern
- PostgreSQL database with Sequelize ORM
- JWT authentication
- RESTful endpoints

[Shows preview]

Should I create this architecture document at `docs/architecture.md`?
```

## Notes

- This command focuses on **documenting existing architecture**, not designing new architecture
- Generated docs should be **living documents** that evolve with the codebase
- Encourage users to review and refine the generated content
- Link to specific files and line numbers for easy navigation
- Use mermaid diagrams where helpful for visualizing structure

---

**Command Version:** 1.0
**Compatible with:** RAPID-AI Framework
**No BMAD dependencies**
