# Diagram Patterns and Templates

This document provides advanced patterns, templates, and best practices for creating effective Mermaid diagrams. It serves as a comprehensive reference for the create-diagrams agent complex, offering proven patterns for common scenarios and advanced techniques for complex visualizations.

## Overview

Building upon the foundational patterns in `creating-diagrams.md`, this guide provides specialized templates, advanced styling techniques, and pattern libraries for creating professional-quality diagrams that effectively communicate complex systems and processes.

## Architecture Diagram Patterns

### Microservices Architecture

#### Basic Microservices Pattern
```mermaid
flowchart TB
    Client([Client App])
    Gateway[API Gateway]
    
    Client --> Gateway
    
    Gateway --> UserService[User Service]
    Gateway --> ProductService[Product Service]
    Gateway --> OrderService[Order Service]
    Gateway --> PaymentService[Payment Service]
    
    UserService --> UserDB[(User Database)]
    ProductService --> ProductDB[(Product Database)]
    OrderService --> OrderDB[(Order Database)]
    PaymentService --> PaymentDB[(Payment Database)]
    
    OrderService -.-> MessageQueue[Message Queue]
    PaymentService -.-> MessageQueue
    NotificationService[Notification Service] -.-> MessageQueue
```

#### Advanced Microservices with Infrastructure
```mermaid
flowchart TB
    subgraph "External"
        Client([Client Apps])
        ThirdParty[Third Party APIs]
    end
    
    subgraph "Edge Layer"
        CDN[CDN]
        LoadBalancer[Load Balancer]
        APIGateway[API Gateway]
    end
    
    subgraph "Service Mesh"
        UserService[User Service]
        ProductService[Product Service]
        OrderService[Order Service]
        PaymentService[Payment Service]
        NotificationService[Notification Service]
    end
    
    subgraph "Data Layer"
        UserDB[(User DB)]
        ProductDB[(Product DB)]
        OrderDB[(Order DB)]
        PaymentDB[(Payment DB)]
        Cache[(Redis Cache)]
    end
    
    subgraph "Infrastructure"
        MessageQueue[Message Queue]
        EventBus[Event Bus]
        ServiceRegistry[Service Registry]
        ConfigServer[Config Server]
    end
    
    Client --> CDN
    CDN --> LoadBalancer
    LoadBalancer --> APIGateway
    
    APIGateway --> UserService
    APIGateway --> ProductService
    APIGateway --> OrderService
    APIGateway --> PaymentService
    
    UserService --> UserDB
    ProductService --> ProductDB
    OrderService --> OrderDB
    PaymentService --> PaymentDB
    
    UserService -.-> Cache
    ProductService -.-> Cache
    
    OrderService --> MessageQueue
    PaymentService --> MessageQueue
    NotificationService --> MessageQueue
    
    PaymentService --> ThirdParty
    NotificationService --> ThirdParty
```

### Authentication and Authorization Patterns

#### OAuth 2.0 Flow
```mermaid
sequenceDiagram
    participant User
    participant Client as Client App
    participant AuthServer as Auth Server
    participant ResourceServer as Resource Server
    
    User->>Client: Request access to resource
    Client->>AuthServer: Redirect to authorization endpoint
    AuthServer->>User: Show login form
    User->>AuthServer: Enter credentials
    AuthServer->>Client: Redirect with authorization code
    Client->>AuthServer: Exchange code for access token
    AuthServer->>Client: Return access token
    Client->>ResourceServer: Request resource with token
    ResourceServer->>AuthServer: Validate token
    AuthServer->>ResourceServer: Token validation response
    ResourceServer->>Client: Return requested resource
    Client->>User: Display resource
```

#### JWT Authentication Pattern
```mermaid
sequenceDiagram
    participant Client
    participant API as API Gateway
    participant Auth as Auth Service
    participant Service as Business Service
    participant DB as Database
    
    Client->>API: Login request
    API->>Auth: Validate credentials
    Auth->>DB: Check user credentials
    DB->>Auth: User data
    Auth->>Auth: Generate JWT token
    Auth->>API: Return JWT token
    API->>Client: Return token
    
    Note over Client,Service: Subsequent requests
    
    Client->>API: Request with JWT
    API->>API: Validate JWT signature
    API->>Service: Forward request with user context
    Service->>DB: Query data
    DB->>Service: Return data
    Service->>API: Return response
    API->>Client: Return response
```

## Data Model Patterns

### Domain-Driven Design Entities

#### E-commerce Domain Model
```mermaid
classDiagram
    class User {
        -UUID id
        +String email
        +String username
        +String passwordHash
        +Profile profile
        +Date createdAt
        +Date lastLoginAt
        +authenticate(password) Boolean
        +updateProfile(data) Profile
        +changePassword(old, new) Boolean
    }
    
    class Profile {
        -UUID id
        +String firstName
        +String lastName
        +String phone
        +Address billingAddress
        +Address shippingAddress
        +updateContactInfo(info) void
        +addAddress(address) void
    }
    
    class Order {
        -UUID id
        +String orderNumber
        +OrderStatus status
        +Money totalAmount
        +Date orderedAt
        +Date shippedAt
        +Date deliveredAt
        +addItem(product, quantity) OrderItem
        +removeItem(productId) void
        +calculateTotal() Money
        +updateStatus(status) void
    }
    
    class OrderItem {
        -UUID id
        +Integer quantity
        +Money unitPrice
        +Money totalPrice
        +updateQuantity(quantity) void
        +calculateTotal() Money
    }
    
    class Product {
        -UUID id
        +String name
        +String description
        +String sku
        +Money price
        +Integer stockQuantity
        +ProductStatus status
        +updatePrice(price) void
        +updateStock(quantity) void
        +isAvailable() Boolean
    }
    
    class Category {
        -UUID id
        +String name
        +String description
        +String slug
        +Category parent
        +addProduct(product) void
        +removeProduct(product) void
    }
    
    User ||--|| Profile : has
    User ||--o{ Order : places
    Order ||--o{ OrderItem : contains
    OrderItem }o--|| Product : references
    Product }o--|| Category : belongs to
    Category ||--o{ Category : parent-child
    
    class OrderStatus {
        <<enumeration>>
        PENDING
        CONFIRMED
        SHIPPED
        DELIVERED
        CANCELLED
    }
    
    class ProductStatus {
        <<enumeration>>
        ACTIVE
        INACTIVE
        DISCONTINUED
    }
```

#### Aggregate Patterns
```mermaid
classDiagram
    class UserAggregate {
        <<aggregate>>
        -User user
        -Profile profile
        -List~Address~ addresses
        +updateProfile(data) void
        +addAddress(address) void
        +changePassword(old, new) Boolean
    }
    
    class OrderAggregate {
        <<aggregate>>
        -Order order
        -List~OrderItem~ items
        -PaymentInfo payment
        -ShippingInfo shipping
        +addItem(product, quantity) void
        +removeItem(productId) void
        +processPayment(paymentData) void
        +ship(trackingNumber) void
    }
    
    class ProductAggregate {
        <<aggregate>>
        -Product product
        -Inventory inventory
        -List~Review~ reviews
        +updateInventory(quantity) void
        +addReview(review) void
        +updatePricing(price) void
    }
    
    UserAggregate --> OrderAggregate : creates
    OrderAggregate --> ProductAggregate : references
```

## Process Flow Patterns

### CI/CD Pipeline Pattern
```mermaid
flowchart LR
    subgraph "Development"
        Dev[Developer]
        IDE[IDE/Editor]
        LocalTests[Local Tests]
    end
    
    subgraph "Version Control"
        GitRepo[Git Repository]
        PullRequest[Pull Request]
        CodeReview[Code Review]
    end
    
    subgraph "CI Pipeline"
        Trigger[Trigger Build]
        Checkout[Checkout Code]
        Build[Build Application]
        UnitTests[Unit Tests]
        Integration[Integration Tests]
        Security[Security Scan]
        Quality[Quality Gates]
    end
    
    subgraph "CD Pipeline"
        Artifact[Build Artifact]
        Deploy[Deploy to Staging]
        E2ETests[E2E Tests]
        Approval[Manual Approval]
        Production[Deploy to Production]
        Monitor[Monitor & Validate]
    end
    
    Dev --> IDE
    IDE --> LocalTests
    LocalTests --> GitRepo
    GitRepo --> PullRequest
    PullRequest --> CodeReview
    CodeReview --> Trigger
    
    Trigger --> Checkout
    Checkout --> Build
    Build --> UnitTests
    UnitTests --> Integration
    Integration --> Security
    Security --> Quality
    
    Quality --> Artifact
    Artifact --> Deploy
    Deploy --> E2ETests
    E2ETests --> Approval
    Approval --> Production
    Production --> Monitor
    
    Monitor -.-> Dev
```

### Event-Driven Architecture Pattern
```mermaid
flowchart TD
    subgraph "Event Sources"
        UserService[User Service]
        OrderService[Order Service]
        PaymentService[Payment Service]
        InventoryService[Inventory Service]
    end
    
    subgraph "Event Infrastructure"
        EventBus[Event Bus]
        EventStore[(Event Store)]
        DeadLetter[Dead Letter Queue]
    end
    
    subgraph "Event Consumers"
        EmailService[Email Service]
        NotificationService[Notification Service]
        ReportingService[Reporting Service]
        AuditService[Audit Service]
    end
    
    subgraph "External Systems"
        Analytics[Analytics Platform]
        CRM[CRM System]
        Warehouse[Warehouse System]
    end
    
    UserService --> EventBus
    OrderService --> EventBus
    PaymentService --> EventBus
    InventoryService --> EventBus
    
    EventBus --> EventStore
    EventBus --> EmailService
    EventBus --> NotificationService
    EventBus --> ReportingService
    EventBus --> AuditService
    
    EventBus -.-> DeadLetter
    
    NotificationService --> Analytics
    ReportingService --> CRM
    InventoryService --> Warehouse
```

## Advanced Styling Patterns

### Color-Coded System Components
```mermaid
flowchart TB
    classDef frontend fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef backend fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef database fill:#e8f5e8,stroke:#1b5e20,stroke-width:2px
    classDef external fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef queue fill:#fce4ec,stroke:#880e4f,stroke-width:2px
    
    Web[Web App]:::frontend
    Mobile[Mobile App]:::frontend
    API[API Gateway]:::backend
    Auth[Auth Service]:::backend
    Users[User Service]:::backend
    Orders[Order Service]:::backend
    
    DB1[(User DB)]:::database
    DB2[(Order DB)]:::database
    Cache[(Redis)]:::database
    
    Payment[Payment Gateway]:::external
    Email[Email Service]:::external
    
    Queue[Message Queue]:::queue
    
    Web --> API
    Mobile --> API
    API --> Auth
    API --> Users
    API --> Orders
    Users --> DB1
    Orders --> DB2
    Auth --> Cache
    Orders --> Payment
    Orders --> Queue
    Queue --> Email
```

### Status and Flow Indicators
```mermaid
flowchart TD
    classDef success fill:#c8e6c9,stroke:#2e7d32,stroke-width:2px
    classDef warning fill:#fff3c4,stroke:#f57f17,stroke-width:2px
    classDef error fill:#ffcdd2,stroke:#c62828,stroke-width:2px
    classDef processing fill:#e1bee7,stroke:#8e24aa,stroke-width:2px
    
    Start([Start]):::success
    
    Validate{Validate Input}:::processing
    Process[Process Request]:::processing
    
    Success[Success Response]:::success
    Warning[Warning Response]:::warning
    Error[Error Response]:::error
    
    Retry{Retry?}:::warning
    
    Start --> Validate
    Validate -->|Valid| Process
    Validate -->|Invalid| Error
    Process -->|Success| Success
    Process -->|Warning| Warning
    Process -->|Error| Retry
    Retry -->|Yes| Validate
    Retry -->|No| Error
```

## Complex Interaction Patterns

### Saga Pattern for Distributed Transactions
```mermaid
sequenceDiagram
    participant Order as Order Service
    participant Payment as Payment Service
    participant Inventory as Inventory Service
    participant Shipping as Shipping Service
    participant Saga as Saga Orchestrator
    
    Order->>Saga: Start order process
    Saga->>Order: Create order
    Order->>Saga: Order created
    
    Saga->>Payment: Reserve payment
    Payment->>Saga: Payment reserved
    
    Saga->>Inventory: Reserve items
    Inventory->>Saga: Items reserved
    
    Saga->>Shipping: Schedule shipping
    Shipping->>Saga: Shipping scheduled
    
    Note over Saga: All steps successful
    
    Saga->>Payment: Confirm payment
    Payment->>Saga: Payment confirmed
    
    Saga->>Inventory: Confirm reservation
    Inventory->>Saga: Reservation confirmed
    
    Saga->>Shipping: Confirm shipping
    Shipping->>Saga: Shipping confirmed
    
    Saga->>Order: Complete order
    Order->>Saga: Order completed
    
    alt Failure scenario
        Saga->>Shipping: Cancel shipping
        Saga->>Inventory: Cancel reservation
        Saga->>Payment: Cancel payment
        Saga->>Order: Cancel order
    end
```

### CQRS Pattern
```mermaid
flowchart TB
    subgraph "Command Side"
        CommandAPI[Command API]
        CommandHandlers[Command Handlers]
        WriteModel[(Write Model)]
        EventStore[(Event Store)]
    end
    
    subgraph "Query Side"
        QueryAPI[Query API]
        QueryHandlers[Query Handlers]
        ReadModel[(Read Model)]
        Projections[Projections]
    end
    
    subgraph "Event Processing"
        EventBus[Event Bus]
        EventProcessors[Event Processors]
    end
    
    Client[Client Application]
    
    Client -->|Commands| CommandAPI
    Client -->|Queries| QueryAPI
    
    CommandAPI --> CommandHandlers
    CommandHandlers --> WriteModel
    CommandHandlers --> EventStore
    
    EventStore --> EventBus
    EventBus --> EventProcessors
    EventProcessors --> Projections
    Projections --> ReadModel
    
    QueryAPI --> QueryHandlers
    QueryHandlers --> ReadModel
```

## Documentation Integration Patterns

### Architecture Decision Record (ADR) Diagram
```mermaid
flowchart TD
    Problem[Problem Statement]
    Options[Solution Options]
    
    subgraph "Option Analysis"
        Option1[Option 1: Monolith]
        Option2[Option 2: Microservices]
        Option3[Option 3: Modular Monolith]
    end
    
    subgraph "Decision Criteria"
        Scalability[Scalability Requirements]
        Complexity[Development Complexity]
        Performance[Performance Requirements]
        Timeline[Development Timeline]
    end
    
    Decision[Decision: Modular Monolith]
    
    subgraph "Implementation"
        Phase1[Phase 1: Core Modules]
        Phase2[Phase 2: Service Boundaries]
        Phase3[Phase 3: Microservices Migration]
    end
    
    Problem --> Options
    Options --> Option1
    Options --> Option2
    Options --> Option3
    
    Option1 --> Scalability
    Option2 --> Complexity
    Option3 --> Performance
    Option3 --> Timeline
    
    Scalability --> Decision
    Complexity --> Decision
    Performance --> Decision
    Timeline --> Decision
    
    Decision --> Phase1
    Phase1 --> Phase2
    Phase2 --> Phase3
```

### System Context Diagram
```mermaid
flowchart TB
    subgraph "Organization Boundary"
        subgraph "System Boundary"
            Core[Core Application]
            API[API Layer]
            Database[(Database)]
        end
        
        Admin[Admin Panel]
        Reports[Reporting System]
    end
    
    subgraph "External Systems"
        PaymentGateway[Payment Gateway]
        EmailService[Email Service]
        Analytics[Analytics Platform]
        CDN[Content Delivery Network]
    end
    
    subgraph "Users"
        Customers[Customers]
        Administrators[Administrators]
        Support[Support Team]
    end
    
    Customers --> Core
    Administrators --> Admin
    Support --> Reports
    
    Core --> API
    API --> Database
    
    Core --> PaymentGateway
    Core --> EmailService
    Core --> Analytics
    API --> CDN
    
    Admin --> Core
    Reports --> Database
```

## Template Usage Guidelines

### Choosing the Right Pattern

1. **For System Architecture**:
   - Use microservices patterns for distributed systems
   - Use layered patterns for traditional applications
   - Use event-driven patterns for decoupled systems

2. **For Data Models**:
   - Use domain-driven design for complex business logic
   - Use simple entity relationships for CRUD applications
   - Use aggregate patterns for bounded contexts

3. **For Process Flows**:
   - Use flowcharts for business processes
   - Use sequence diagrams for system interactions
   - Use state diagrams for status workflows

### Customization Guidelines

1. **Adapt to Context**:
   - Modify entity names to match your domain
   - Adjust relationships based on business rules
   - Customize styling to match organization standards

2. **Maintain Consistency**:
   - Use consistent naming conventions
   - Apply uniform styling across diagrams
   - Follow established arrow and connection patterns

3. **Keep It Simple**:
   - Start with basic patterns and add complexity gradually
   - Focus on key relationships and flows
   - Use subgraphs to group related components

## Integration with Documentation

### Markdown Integration Best Practices

```markdown
## System Architecture

The following diagram illustrates our microservices architecture:

```mermaid
[diagram code here]
```

### Component Responsibilities

- **API Gateway**: Routes requests and handles authentication
- **User Service**: Manages user data and authentication
- **Order Service**: Processes orders and manages order lifecycle
```

### Dynamic Documentation

For documentation that needs to stay current with code:

1. **Reference Patterns**: Link to this pattern library
2. **Version Control**: Track diagram changes with code changes
3. **Automated Updates**: Consider tooling for automatic diagram updates
4. **Review Process**: Include diagrams in code review processes

## Conclusion

These patterns provide a foundation for creating professional, consistent diagrams that effectively communicate system design and processes. Use them as starting points and adapt them to your specific needs while maintaining clarity and consistency across your documentation.

Remember to:
- Choose patterns appropriate to your audience and purpose
- Maintain consistency in styling and terminology
- Keep diagrams focused and avoid unnecessary complexity
- Update diagrams as systems evolve
- Use these patterns as building blocks for more complex visualizations