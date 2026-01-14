# Spring Microservice Project

This project is a Spring Boot microservice that implements a user and order management system. It utilizes Spring Data JPA for database interactions and demonstrates many-to-one and one-to-many relationships between entities.

## Project Structure

```
spring-microservice
├── src
│   ├── main
│   │   ├── java
│   │   │   └── com
│   │   │       └── example
│   │   │           └── microservice
│   │   │               ├── MicroserviceApplication.java
│   │   │               ├── config
│   │   │               │   ├── DatabaseConfig.java
│   │   │               │   └── SwaggerConfig.java
│   │   │               ├── controller
│   │   │               │   ├── UserController.java
│   │   │               │   └── OrderController.java
│   │   │               ├── service
│   │   │               │   ├── UserService.java
│   │   │               │   └── OrderService.java
│   │   │               ├── repository
│   │   │               │   ├── UserRepository.java
│   │   │               │   └── OrderRepository.java
│   │   │               ├── model
│   │   │               │   ├── User.java
│   │   │               │   ├── Order.java
│   │   │               │   └── Item.java
│   │   │               ├── dto
│   │   │               │   ├── UserDto.java
│   │   │               │   └── OrderDto.java
│   │   │               └── exception
│   │   │                   └── GlobalExceptionHandler.java
│   │   └── resources
│   │       ├── application.yml
│   │       └── db
│   │           └── migration
│   │               └── V1__init.sql
│   └── test
│       └── java
│           └── com
│               └── example
│                   └── microservice
│                       ├── UserServiceTest.java
│                       └── OrderServiceTest.java
├── Dockerfile
├── docker-compose.yml
├── pom.xml
└── README.md
```

## Features

- **User Management**: Create, retrieve, update, and delete users.
- **Order Management**: Create, retrieve, update, and delete orders associated with users.
- **Database Integration**: Uses Spring Data JPA for database operations.
- **API Documentation**: Swagger is configured for API documentation.
- **Exception Handling**: Global exception handling for better error management.

## Getting Started

### Prerequisites

- Java 11 or higher
- Maven
- Docker (optional)

If you prefer Gradle, this project also includes a Gradle build file. Use Gradle 7+ or the Gradle wrapper.

### Setup

1. Clone the repository:
   ```
   git clone <repository-url>
   cd spring-microservice
   ```

2. Build the project with Maven:
   ```
   mvn clean install
   ```

   Or with Gradle:
   ```
   gradle clean build
   # or, if you have the Gradle wrapper:
   ./gradlew clean build    # on Unix
   gradlew.bat clean build  # on Windows PowerShell
   ```

3. Run the application:
   ```
   # Maven
   mvn spring-boot:run

   # or Gradle
   gradle bootRun
   # or with wrapper on Windows PowerShell:
   gradlew.bat bootRun
   ```

### API Endpoints

- **User Endpoints**
  - `POST /users`: Create a new user
  - `GET /users`: Retrieve all users
  - `GET /users/{id}`: Retrieve a user by ID
  - `PUT /users/{id}`: Update a user
  - `DELETE /users/{id}`: Delete a user

- **Order Endpoints**
  - `POST /orders`: Create a new order
  - `GET /orders`: Retrieve all orders
  - `GET /orders/{id}`: Retrieve an order by ID
  - `PUT /orders/{id}`: Update an order
  - `DELETE /orders/{id}`: Delete an order

### Running with Docker

To run the application using Docker, use the following command:
```
docker-compose up
```

## Using PostgreSQL

This project is configured to use Flyway for database migrations. To switch from MySQL/H2 to PostgreSQL, do the following:

1. Start a local PostgreSQL instance (example using Docker):

```powershell
docker run --name micro-postgres -e POSTGRES_DB=microservice_db -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:15
```

2. Update `src/main/resources/application.yml` (or create `application-postgres.yml`) with the PostgreSQL connection settings. Example (uncomment the block included in `application.yml`):

```yaml
spring:
   datasource:
      url: jdbc:postgresql://localhost:5432/microservice_db
      username: postgres
      password: postgres
      driver-class-name: org.postgresql.Driver
   jpa:
      hibernate:
         ddl-auto: none
      properties:
         hibernate:
            dialect: org.hibernate.dialect.PostgreSQLDialect
spring:
   flyway:
      enabled: true
      baseline-on-migrate: true
      locations: classpath:db/migration
```

3. Add the PostgreSQL JDBC driver to your build if using Gradle (already present in Maven example). For Gradle add:

```groovy
runtimeOnly 'org.postgresql:postgresql:42.6.0'
```

In this repository the Gradle build currently uses H2 for runtime. If you switch to Postgres, replace the H2 runtime dependency with the Postgres driver or add both.

4. Flyway will automatically apply migrations from `src/main/resources/db/migration` on application startup. We added a sample migration `V2__create_products_table.sql` which creates a `products` table.

5. Start the application (Gradle example):

```powershell
gradlew.bat bootRun
# or
gradle bootRun
```

6. Verify the new table in psql or a DB client:

```powershell
# Connect interactively (example using psql client)
psql -h localhost -p 5432 -U postgres -d microservice_db
\dt
SELECT * FROM products;
```

Notes:
- Flyway migration files must follow the naming pattern `V{version}__{description}.sql` and are applied in order.
- If you already have data in the DB and want to adopt Flyway, `baseline-on-migrate: true` helps to baseline an existing schema.

## License

This project is licensed under the MIT License. See the LICENSE file for details.