# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Salesforce DX (SFDX) practice project focused on Apex development. It targets API version 64.0 and is connected to a Developer Edition org. There are no Lightning Web Components — the codebase is purely Apex.

## Common Commands

### Salesforce CLI (sf)
```bash
# Deploy all metadata to the org
sf project deploy start

# Run all Apex tests in the org
sf apex run test --synchronous

# Run a specific test class
sf apex run test --class-names CalculatorTests --synchronous

# Open the connected org
sf org open

# Execute anonymous Apex
sf apex run --file scripts/apex/hello.apex

# Run a SOQL query
sf data query --file scripts/soql/account.soql
```

### Code Quality
```bash
# Format all code (Apex, HTML, JS, JSON, YAML)
npm run prettier

# Verify formatting without changes
npm run prettier:verify

# Lint Aura/LWC JavaScript
npm run lint

# Run LWC Jest unit tests (none currently in this project)
npm test
npm run test:unit:coverage
```

Pre-commit hooks (Husky + lint-staged) automatically run prettier and ESLint on staged files before each commit.

## Architecture

All Apex lives in `force-app/main/default/classes/`. The project demonstrates several patterns:

### Production Classes
- **AccountController** — SOQL queries using `WITH SECURITY_ENFORCED` for FLS enforcement
- **AccountHandler** — DML operations with try-catch exception handling
- **AccountWrapper** — Data wrapper class used by `OpportunityDiscount` for discount calculation
- **Calculator** — Arithmetic logic with a custom inner exception class (`Calculator.CalculatorException`)
- **ContactAndLeadSearch** / **ContactSearch** — Multi-object SOQL search patterns
- **ExternalSearch** — HTTP callout pattern with custom exception (`ExternalSearch.ExternalSearchException`)
- **OpportunityDiscount** — Discount logic; accepts an `AccountWrapper` via constructor (dependency injection)
- **LoremIpsum** — Lorem ipsum text generation utility

### Test Infrastructure
- **TestFactory** — Shared factory for creating test SObject records
- **HTTPMockFactory** / **HTTPMockFactoryException** — Factory for HTTP mock routing
- **HTTPSuccessMock** / **HTTPExceptionMock** — Concrete `HttpCalloutMock` implementations
- **AccountWrapperMock** — Mock for `AccountWrapper` used in `OpportunityDiscountTests`

### Key Patterns
- **HTTP mocking**: All classes that make callouts use `Test.setMock(HttpCalloutMock.class, ...)` in tests. Mocks are in dedicated mock classes, not inline.
- **Custom exceptions**: Defined as inner classes (e.g., `Calculator.CalculatorException`) and thrown on invalid input.
- **Dependency injection**: `OpportunityDiscount` receives its `AccountWrapper` dependency via constructor, making it testable without DML.
- **SOQL security**: Use `WITH SECURITY_ENFORCED` on SOQL queries that run in user context.

## Configuration
- `sfdx-project.json` — SFDX project definition, API version, package directories
- `config/project-scratch-def.json` — Scratch org definition (Developer edition)
- `.prettierrc` — Includes `prettier-plugin-apex` and `@prettier/plugin-xml`
- `eslint.config.js` — ESLint rules for Aura and LWC (flat config format)
