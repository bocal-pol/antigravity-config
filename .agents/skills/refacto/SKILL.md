---
name: refacto
description: "Cross-stack refactoring skill — analyzes existing code (Backend .NET/Laravel, Frontend Angular/React, Mobile Flutter/RN, Integration) and migrates it toward the target architecture (DTOs, Services/Interfaces, Repositories, Validators, Mappers, Projections, State/BLoCs). Auto-invoke on: refactoring, migrate to DTOs, existing architecture, restructure, extract service, legacy code."
model: claude-sonnet-5
user-invocable: true
type: utility
priority: high
scope: cross
dependencies:
  - dto-architect
  - context7-mcp
conflicts: []
---

# Refacto — Migration toward the target architecture (multi-stack)

`[Activated: Refacto]`

Analysis of existing code and progressive migration toward the full target architecture:

**Backend**: DTOs → Services/Interfaces → Repositories/Interfaces → Validators → Mappers → Projections → EF Core Configuration / Migrations
**Frontend**: DTOs → API Service → Mappers → UI Models → Store (NGXS/Zustand)
**Mobile**: DTOs → Repository → Mappers → Domain Models → BLoC/Riverpod
**Integration**: OpenAPI/AsyncAPI Contract → Generated DTOs → ACL → Endpoints

> **Absolute rule**: migrate without breaking existing behavior — every step is independently testable. Never a full rewrite in one pass. The migration order is fixed (deep layers first).

## Phase 1 — Analysis (EnterPlanMode)

### Information gathering

Via `AskUserQuestion`, gather:

```
Architecture Refactor — Context
─────────────────────────────────
1. Detected / target stack:
   [ ] Backend — Laravel    [ ] Backend — .NET
   [ ] Frontend — Angular   [ ] Frontend — React
   [ ] Mobile — Flutter     [ ] Mobile — React Native
   [ ] Integration — MuleSoft / Kafka / REST
   [ ] Auto-detect from source files
2. Refactoring scope:
   [ ] A single file (e.g. UserController.php, user.service.ts)
   [ ] An entire domain (e.g. a Request/ folder, feature/auth)
   [ ] The whole layer (e.g. all controllers, all services)
3. Layers to migrate (check all that apply):
   BACKEND: [ ] DTOs [ ] Service+Interface [ ] Repository+Interface [ ] Validators [ ] Mappers [ ] Projections [ ] EF Core Config
   FRONTEND: [ ] DTOs [ ] API Service [ ] Mappers [ ] UI Models [ ] Store (NGXS/Zustand)
   MOBILE: [ ] DTOs [ ] Repository [ ] Mappers [ ] Domain Models [ ] BLoC/Riverpod
   INTEGRATION: [ ] OpenAPI/AsyncAPI Contract [ ] Generated DTOs [ ] ACL Mapper [ ] Endpoints
4. Constraints:
   [ ] Existing tests to preserve
   [ ] Public API frozen (don't change route signatures)
   [ ] Source code path to analyze
```

ExitPlanMode before analysis.

## Phase 2 — Discovery of existing code

### 2a — Detect the framework

```bash
# Laravel
ls composer.json && cat composer.json | grep '"laravel/framework"'

# .NET
ls *.csproj */*.csproj */*/*.csproj 2>/dev/null | head -5
```

### 2b — Map existing code

Read and identify in the source code:

| Element | Look for | Laravel Backend | .NET Backend | Angular Frontend | React Frontend | Flutter Mobile | RN Mobile |
|---------|-----------|---|---|---|---|---|---|
| DTOs | Exist? Scattered? | `app/DTOs/**` | `src/*/DTOs/**` | `src/{dtos,models}/` | `src/{dtos,models}/` | `lib/data/dtos/` | `src/{dtos,models}/` |
| Service | Missing interface? | `app/Services/*.php` | `src/*/Services/*.cs` | `src/core/services/` | `src/services/` | `lib/domain/` | `src/services/` |
| Repository | Missing interface? | `app/Repositories/*.php` | `src/*/Repositories/*.cs` | N/A | N/A | `lib/data/repositories/` | N/A |
| Raw models exposed | Model in raw JSON? | `return $model` | `return entity` | Direct in template? | Direct in JSX? | Direct in Widget? | Direct in JSX? |
| Validators | Inline in controller? | `Validator::make` in controller | `new FluentValidation()` | Reactive Forms / RxJS? | React Hook Form / custom? | Freezed guards? | TypeScript types? |
| Mappers | Scattered conversion? | `return $model->toArray()` | `new ResponseDto { }` | ad-hoc transformation | `useMemo` / `useMemo` | Manual mapping? | Manual mapping? |
| Store / State | Present? Used? | N/A | N/A | NGXS Selectors? | Zustand state? | Riverpod providers? | Redux store? |
| Config / Schema | Indexes/Constraints? | Migration without indexes | IEntityTypeConfiguration | N/A | N/A | N/A | N/A |

### 2c — Existing code audit report

Produce a summary table:

```
## Existing Code Audit — [Scope] — [Stack]

| File | Detected problem | Priority | Action | Stack |
|---------|-----------------|----------|--------|-------|
| UserController.php | Raw model returned | P0 | Extract ResponseDto + Resource | Laravel Backend |
| UserController.php | Inline Validator::make | P1 | Extract CreateUserRequestDto | Laravel Backend |
| UserComponent.ts | Template uses raw DTO | P0 | Map to UI Model | Angular Frontend |
| user.service.ts | No Zod validation | P1 | Validate ResponseDto | React Frontend |
| UserRepository | Missing interface | P1 | Create IUserRepository | Flutter Mobile |
| SolicitService.cs | Direct DbContext, no UnitOfWork | P1 | Migrate to UnitOfWork + Service | .NET Backend |
| endpoint.ts | Outdated generated DTOs | P2 | Regenerate from contract | Integration |
```

## Phase 3 — Migration by layer (fixed order)

### Mandatory migration order per stack

#### Backend (.NET / Laravel)
```
1. DTOs           ← define contracts first
2. Validators     ← validate the DTOs
3. Mappers        ← Entity ↔ DTO conversion
4. Projections    ← SQL-level for performance
5. Repositories   ← base Interface + specialized + Implementation
6. Services       ← Interface + Implementation (orchestration)
7. Controllers    ← wire up DTOs/Services
8. EF Config/.Migration ← constraints/indexes
```

#### Frontend (Angular / React)
```
1. DTOs           ← RequestDto / ResponseDto from the API contract
2. Mappers        ← ResponseDto → UI Model
3. API Service    ← HttpClient → validation (Zod) → Mapper → return UI Model
4. UI Models      ← frontend business models
5. Store (NGXS/Zustand) ← stores UI Models, never a raw DTO
6. Components     ← use the store's UI Models
```

#### Mobile (Flutter / React Native)
```
1. DTOs           ← RequestDto / ResponseDto from the API
2. Mappers        ← ResponseDto → Domain Model
3. Repository     ← RequestDto → API → ResponseDto → Domain Model
4. Domain Models  ← business models, Freezed (Flutter) / null-safety (RN)
5. BLoC/Riverpod  ← business logic, uses the Repository
6. UI Widgets/Components ← display the BLoC's Domain Models
```

#### Integration (MuleSoft / Kafka / REST)
```
1. Contract       ← OpenAPI / AsyncAPI / Avro (source of truth)
2. Generated DTOs ← via openapi-generator / avrogen
3. ACL Mappers    ← External DTO → Internal Model
4. Endpoints      ← RequestDto validation → Service → ResponseDto
5. Idempotency    ← dedup keys / Idempotency-Key header
```

> Migrate in this order because each layer depends on the previous ones.

### 3.1 — Migrate DTOs

**What to look for in the existing code**:
- Controllers with `$request->all()` / `Request $request` without a DTO → create `*RequestDto`
- Controllers returning a raw `$model` or `->toArray()` → create `*ResponseDto`
- `return response()->json($user)` / `return Ok(entity)` → raw model exposed

**Create**:
```
# Laravel
app/DTOs/Requests/Create<Entity>RequestDto.php
app/DTOs/Responses/<Entity>ResponseDto.php

# .NET
src/<Domain>/Application/DTOs/Requests/Create<Entity>RequestDto.cs
src/<Domain>/Application/DTOs/Responses/<Entity>ResponseDto.cs
```

Invoke the `dto-architect` skill for the full structure and examples.

### 3.2 — Migrate Validators

**What to look for**:
- `Validator::make($request->all(), [...])` inline in the controller → extract
- Missing validation → add it

**Create**:
```
# Laravel
app/DTOs/Requests/Create<Entity>RequestDto.php — static fromRequest() method + rules() + messages()

# .NET
src/<Domain>/Application/DTOs/Requests/Create<Entity>RequestDtoValidator.cs — AbstractValidator<T>
```

### 3.3 — Migrate Mappers

**What to look for**:
- Inline conversion: `new DemandeResponseDto { Id = entity.Id, ... }` scattered → centralize
- `$entity->toArray()` in controllers/services → extract into `<Entity>Mapper`

**Create**:
```
# Laravel
app/Mappers/<Entity>Mapper.php (static toResponseDto / fromRequestDto)

# .NET
src/<Domain>/Application/Mappers/<Entity>Mapper.cs (static class, Expression<Func<>> projections)
```

### 3.4 — Migrate Projections

**What to look for**:
- `$this->db->query()->get()` + foreach transformation → `.select([...])` SQL-level
- `.Where().ToList()` EF → `.Select(DemandeMapper.ToDtoProjection).ToListAsync()`

**Rules**:
- Minimal columns only (no `SELECT *`)
- `Expression<Func<TEntity, TDto>>` for EF Core (.NET)
- Explicit `.select([columns])` in the Query Builder (Laravel)

### 3.5 — Migrate Repositories

**What to look for**:
- `DB::table(...)` / `Model::where(...)` in the service or controller → extract
- Repository without an interface → create `I<Entity>Repository`

**Create in order**:
```
# Laravel
1. app/Repositories/Contracts/IRepository.php      ← if not already present
2. app/Repositories/Contracts/I<Entity>Repository.php
3. app/Repositories/<Entity>Repository.php
4. app/Providers/RepositoryServiceProvider.php (DI binding)

# .NET
1. src/Shared/Application/IBaseServiceRepository.cs ← if not already present
2. src/<Domain>/Application/I<Entity>Repository.cs
3. src/<Domain>/Infrastructure/Repositories/<Entity>Repository.cs
```

**DI update**:
```php
// Laravel — RepositoryServiceProvider
$this->app->bind(I<Entity>Repository::class, <Entity>Repository::class);
```
```csharp
// .NET — Program.cs or an extension
services.AddScoped<I<Entity>Repository, <Entity>Repository>();
```

### 3.6 — Migrate Services

**What to look for**:
- Business logic in the controller → extract into `<Entity>Service`
- Service without an interface → create `I<Entity>Service`
- Direct `DB::table(...)` in the service → delegate to the repository

**Create**:
```
# Laravel
app/Services/Contracts/I<Entity>Service.php
app/Services/<Entity>Service.php

# .NET
src/<Domain>/Application/Interfaces/I<Entity>Service.cs
src/<Domain>/Application/Services/<Entity>Service.cs [Injectable]
```

**Mandatory pattern**:
```php
// Laravel — Transaction wrapper
public function create(CreateEntityRequestDto $dto): EntityResponseDto
{
    return $this->db->transaction(function () use ($dto) {
        $model = $this->repository->create($dto->toArray());
        // Queue, Email, History if needed
        return EntityMapper::toResponseDto($model);
    });
}
```
```csharp
// .NET — SafeExecute + Result<T>
public Task<Result<EntityResponseDto>> Create(CreateEntityRequestDto dto) =>
    Result<EntityResponseDto>.SafeExecute(async () =>
    {
        var entity = EntityMapper.MapToDbEntity(dto);
        await _unitOfWork.EntityRepository.Create(entity).ThrowIfNotSuccess();
        return await GetEntity(entity.Id);
    });
```

### 3.7 — Migrate Controllers

**What to look for**:
- Controller with business logic → delegate to the service
- Controller returning a raw Model → return via a Mapper/Resource
- Controller without service injection → inject `I<Entity>Service`

**Target pattern**:
```php
// Laravel
class EntityController
{
    public function __construct(private I<Entity>Service $service) {}
    
    public function store(Create<Entity>RequestDto $dto)
    {
        $result = $this->service->create($dto);
        return response()->json($result, 201);
    }
}
```
```csharp
// .NET
[ApiController]
[Route("api/[controller]")]
public class EntityController
{
    public EntityController(I<Entity>Service service) { _service = service; }
    
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateEntityRequestDto dto)
    {
        var result = await _service.Create(dto);
        return result.IsSuccess ? CreatedAtAction(...) : BadRequest(result.GetError());
    }
}
```

### 3.8 — Migrate EF Core Configuration / Laravel Migrations

**What to look for (.NET)**:
- DbEntity without `IEntityTypeConfiguration<T>` → create `<Entity>Configuration.cs`
- Missing indexes on Status/CreatedDate/FK → add them
- Undefined MaxLength → add it

**What to look for (Laravel)**:
- Migration without indexes → add them
- Fields without `maxLength` or `enum` → add them
- Missing cascade delete → add it

**.NET migration verification**:
```bash
dotnet ef migrations add Add<Entity>Configuration --project src/Infrastructure
# Verify the SQL migration contains CREATE INDEX and constraints
```

### 3.9 — Migrate Frontend (Angular / React)

**What to look for**:
- Service calling the API without validation → add Zod `.parse()` (React) / type guard (Angular) at the boundary
- Components using the service's raw DTO → inject a UI Model from the store
- Empty or missing store → create NGXS Selectors / Zustand state
- `nullable` fields of the `ResponseDto` unhandled in the mapper → explicit UI default
- Missing `loading` / `error` / `empty` states → handle at the boundary (mapped HTTP errors, never the raw body)
- React: server state duplicated in Zustand while TanStack Query already manages the cache → separate them (TanStack = server, Zustand = UI)
- DTO type declared twice instead of `z.infer<typeof Schema>` → derive from the Zod schema

**Create**:
```
# Angular
src/app/core/dtos/              ← *RequestDto / *ResponseDto (from OpenAPI)
src/app/core/mappers/           ← ResponseDto → UI Model
src/app/core/services/          ← HttpClient → validation → Mapper
src/app/core/models/            ← UI Models (never exposed via the API)
src/app/state/ (NGXS)           ← Actions, State, Selectors

# React
src/dtos/                        ← *RequestDto / *ResponseDto
src/mappers/                     ← ResponseDto → UI Model
src/services/                    ← fetch → Zod validation → Mapper
src/models/                      ← UI Models
src/store/ (Zustand)            ← store holding UI Models
```

**API Service pattern**:
```typescript
// Angular / React — HttpClient → validation → mapper → UI Model
class UserService {
  getUser(id: string): Observable<User> {
    return this.http.get<UserResponseDto>(`/api/users/${id}`).pipe(
      map(dto => {
        const parsed = UserResponseDtoSchema.parse(dto);  // Zod validation
        return UserMapper.toModel(parsed);                 // DTO → UI Model
      })
    );
  }
  
  createUser(form: UserForm): Observable<User> {
    const dto = UserMapper.toRequestDto(form);
    return this.http.post<UserResponseDto>('/api/users', dto).pipe(
      map(response => {
        const parsed = UserResponseDtoSchema.parse(response);
        return UserMapper.toModel(parsed);
      })
    );
  }
}
```

> Full detail (input vs. response validation, nullability, NGXS/Zustand state, errors & loading, frontend tests) → the `dto-architect` skill, **"Frontend — Deep dive"** section.

### 3.10 — Migrate Mobile (Flutter / React Native)

**What to look for**:
- API calls directly from the BLoC → extract into a Repository
- Non-null-safe / non-Freezed models → add them
- No ResponseDto → Domain Model mapping → add it

**Create**:
```
# Flutter
lib/data/dtos/                   ← *RequestDto / *ResponseDto
lib/data/repositories/           ← Repository interface + implementation
lib/data/mappers/                ← ResponseDto → Domain Model
lib/domain/models/               ← Domain Models (Freezed)
lib/application/bloc/            ← BLoC orchestration

# React Native
src/dtos/                         ← *RequestDto / *ResponseDto
src/repositories/                ← Repository interface + implementation
src/mappers/                      ← ResponseDto → Domain Model
src/models/                       ← Domain Models (strict TypeScript)
src/redux/ or src/store/         ← Redux/Zustand
```

**Repository pattern**:
```dart
// Flutter — Repository orchestrates: input → RequestDto → API → ResponseDto → Model
abstract class IUserRepository {
  Future<User> createUser(CreateUserInput input);
  Future<User> getUser(String id);
}

class UserRepository implements IUserRepository {
  final _apiService = UserApiService();  // injected
  
  @override
  Future<User> createUser(CreateUserInput input) async {
    final dto = UserMapper.toCreateRequestDto(input);
    final response = await _apiService.create(dto);
    final parsed = UserResponseDtoSchema.parse(response);
    return UserMapper.toModel(parsed);
  }
}

// BLoC only uses the User model, never a raw DTO
class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository _repository;
  
  UserBloc(this._repository);
  
  on<CreateUserEvent>((event, emit) async {
    final user = await _repository.createUser(event.input);
    emit(UserCreatedState(user: user));  // UI Model only
  });
}
```

### 3.11 — Migrate Integration (Contract-first DTOs)

**What to look for**:
- Hand-written DTOs instead of generated ones → regenerate from the contract
- Endpoints without RequestDto validation at the boundary → add it
- Missing ACL Mapper (External DTO → Internal Model) → create it

**Create**:
```
contracts/v1/                    ← Source of truth (OpenAPI / AsyncAPI / Avro)
src/dtos/generated/              ← Generated DTOs (NOT hand-written)
src/mappers/                     ← ACL Mapper (External DTO → Internal)
src/endpoints/ (MuleSoft/Camel)  ← Validations + Service calls
```

**Endpoint pattern**:
```csharp
// MuleSoft Flow: RequestDto validation → Service (business model) → ResponseDto
[ApiController]
[Route("api/integration/[controller]")]
public class DemandeIntegrationController
{
    [HttpPost]
    public async Task<IActionResult> ReceiveDemande(
        [FromBody] CreateDemandeRequestDto contractDto)
    {
        // 1. Contract validation at the boundary
        var validator = new CreateDemandeRequestDtoValidator();
        var result = validator.Validate(contractDto);
        if (!result.IsValid) return BadRequest(result.Errors);
        
        // 2. Map to the internal model (ACL)
        var internalModel = DemandeAclMapper.FromContractDto(contractDto);
        
        // 3. Call the business service with business data (not the DTO)
        var serviceResult = await _service.CreateFromIntegration(internalModel);
        
        // 4. Return a ResponseDto conforming to the contract
        return Ok(DemandeAclMapper.ToResponseDto(serviceResult));
    }
}
```

## Phase 4 — Post-migration verification

### Checklist per layer

#### Backend (.NET / Laravel)
```
DTOs
[ ] Strict suffixes: *RequestDto / *ResponseDto
[ ] Immutable (readonly PHP / record C# / Freezed Dart)
[ ] No sensitive field (password, hash, token) in ResponseDto
[ ] Validation in RequestDto (fromRequest() or FluentValidation)

Services
[ ] Interface exists (I<Entity>Service)
[ ] Injected by interface (never the implementation)
[ ] Atomic transactions on multi-table create/update
[ ] Contextualized logging (user_id, id, never secrets)
[ ] Idempotence on assign/supervise

Repositories
[ ] Interface exists (I<Entity>Repository)
[ ] DI binding registered (ServiceProvider / Program.cs)
[ ] SQL-level projections (select / Expression<Func<>>)
[ ] Eager loading with .Include() / .with() (no N+1)

Controllers
[ ] Receives a validated RequestDto (never a raw Request)
[ ] Returns a ResponseDto via Mapper/Resource (never a raw Model)
[ ] Delegates to the Service (never directly to the Repository)
[ ] Auth middleware present on all routes

EF Core Config / Migrations
[ ] IEntityTypeConfiguration<T> registered in OnModelCreating
[ ] Indexes on Status, CreatedDate, FKs
[ ] MaxLength on all strings
[ ] Cascade delete on required one-to-one
```

#### Frontend (Angular / React)
```
DTOs
[ ] ResponseDto mapped from the API contract (OpenAPI)
[ ] RequestDto created for complex forms
[ ] No raw DTO used in the component
[ ] DTO type derived from Zod (`z.infer`); nullable fields handled in the mapper (UI default)

API Service
[ ] HttpClient → Zod validation / class-validator → Mapper → UI Model
[ ] Never an Observable<ResponseDto> — always Observable<Model>
[ ] Error handling + retry; loading / error / empty states; mapped HTTP errors (no raw body)

UI Models
[ ] Business models distinct from DTOs
[ ] Non-sensitive properties only
[ ] Strict TypeScript types

Store (NGXS / Zustand)
[ ] State holds UI Models, never a raw DTO
[ ] Server state (React) in TanStack Query, not duplicated in Zustand
[ ] Selectors return UI Models
[ ] Components inject the Store, never the Service

Components
[ ] Use the Store's UI Models
[ ] Reactive Forms with client-side validation
[ ] Never an ad-hoc DTO → UI transformation
```

#### Mobile (Flutter / React Native)
```
DTOs
[ ] ResponseDto generated from the API contract
[ ] RequestDto for complex uploads
[ ] null-safety + Freezed (Flutter)

Repository
[ ] Interface exists (IUserRepository)
[ ] Orchestrates: Input → RequestDto → API → ResponseDto → Domain Model
[ ] DI injection via constructor
[ ] Transactions/locks on the client side if offline sync

Domain Models
[ ] Freezed + null-safety (Flutter) / strict TypeScript (RN)
[ ] Never expose a raw ResponseDto
[ ] Computed properties if needed

BLoC / Riverpod
[ ] Uses the Repository, never the API directly
[ ] Emits Domain Models only
[ ] Consistent state management

UI Widgets / Components
[ ] Display the BLoC's Domain Models
[ ] Never an API → UI transformation
```

#### Integration (Contract-first)
```
Contract
[ ] Source of truth (OpenAPI / AsyncAPI / Avro)
[ ] Semantic versioning (v1/, v2/)
[ ] Never broken, a new version on any breaking change

Generated DTOs
[ ] Generated via openapi-generator / avrogen
[ ] NOT hand-written
[ ] Regenerated after a contract update

ACL Mapper
[ ] External DTO → Internal Model (never the reverse)
[ ] Normalizes naming divergences
[ ] Null-safety checks

Endpoints
[ ] RequestDto validation at the boundary
[ ] Calls the business Service with internal models
[ ] Returns a ResponseDto conforming to the contract
[ ] Idempotency-Key supported

Idempotency
[ ] Idempotency-Key header mandatory (RFC)
[ ] Redis / DB dedup during TTL
[ ] Same result if called twice
```

### Behavior verification

```bash
# Laravel — run existing tests
php artisan test

# .NET — run tests
dotnet test

# Check routes
php artisan route:list --path=api
```

## Phase 5 — Migration report

Generate `backend/YYYY-MM-DD_backend-refactor-<domain>.md`:

```markdown
# Backend Migration Report — [Domain] — YYYY-MM-DD

## Scope
| Info | Value |
|------|--------|
| Framework | Laravel / .NET |
| Domain | [e.g. Demande, User] |
| Modified files | N |
| Created files | N |

## Initial audit — Found problems
| File | Problem | Priority |
|---------|----------|----------|

## Migrations performed
| Layer | Created / Modified | Status |
|--------|---------------|--------|
| DTOs | app/DTOs/Requests/CreateUserRequestDto.php | ✅ |
| Service | app/Services/UserService.php | ✅ |
| Interface | app/Services/Contracts/IUserService.php | ✅ |
| Repository | app/Repositories/UserRepository.php | ✅ |
| Interface | app/Repositories/Contracts/IUserRepository.php | ✅ |
| DI Binding | RepositoryServiceProvider.php | ✅ |

## Tests
| Suite | Before | After |
|-------|-------|-------|
| Unit | X passed | X passed |
| Feature | X passed | X passed |

## Remaining points of attention
| Priority | Topic | Recommended action |
|----------|-------|-------------------|
```

## References

- Full target structure → the `dto-architect` skill
- Laravel conventions → the `laravel-developer` skill
- .NET conventions → the `dotnet-developer` skill
- Post-migration code review → the `code-reviewer` skill
