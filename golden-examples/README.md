# Golden Code Examples (`golden-examples/`)

AI coding tools (Copilot, Codex, Antigravity, Cursor, Claude) produce dramatically more consistent code when pointed at a **100-line canonical example** rather than abstract prose rules alone.

## How Developers Contribute Here
Whenever you write a clean, textbook implementation in a microservice or frontend repo, contribute a sanitized reference copy into the appropriate subfolder below:

```text
golden-examples/
├── node-typescript/       # e.g., canonical Controller + Service + Prisma Repo + Supertest
├── python-fastapi/        # e.g., canonical FastAPI Router + Pydantic v2 + SQLAlchemy 2.0 + Pytest
├── angular-web/           # e.g., canonical Standalone Component + Signals + OnPush + MSW Test
└── mobile/                # e.g., canonical Screen + Domain UseCase + Generated SDK Repository
```

Once merged here, add a 1-line pointer in `AGENTS.md` (e.g., *"Follow the pattern in `golden-examples/angular-web/`"*) so every developer's AI tool uses your pattern as its template.
