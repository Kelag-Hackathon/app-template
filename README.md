# Hackathon App Template

This repository provides a starter template for two Blazor .NET apps—**Survey-App** and **Reporting-App**—plus minimal infrastructure code and a Docker Compose file to run a local SQL database. 

## Repository Setup

app-template (Solution)
├── .github
│ └── workflows # CI/CD workflows (GitHub Actions)
├── dev
│ └── docker-compose.yml # Starts a local Azure SQL Edge container
├── Infrastructure
│ └── main.bicep # Bicep script: Container Apps Environment + Key Vault
├── src
│ ├── Survey-App # Blazor app “Survey”
│ │ ├── Database # EF Core code-first (Entities, Migrations)
│ │ ├── DatabaseContext.cs # DbContext definition
│ │ ├── Program.cs # App startup, DI, auto-migrations
│ │ └── Survey-App.csproj # Project file (references EF Core, Blazor, etc.)
│ │
│ └── Reporting-App # Blazor app “Reporting”
│ ├── Program.cs # App startup, DI
│ └── Reporting-App.csproj # Project file (Blazor, XUnit, etc.)
│
└── tests
├── Survey-Tests # XUnit tests for Survey-App
│ └── Survey-Tests.csproj
└── Reporting-Tests # XUnit tests for Reporting-App
└── Reporting-Tests.csproj


## Database Setup

### SQL Server with Docker

This project includes a Docker Compose file to set up a local SQL Server instance:

1. **Start the SQL Server container**:

   ```bash
   docker-compose up -d
   ```

2. **Stop the SQL Server container**:
   ```bash
   docker-compose down
   ```


### Database Migrations

This project uses Entity Framework Core for database access. To create and apply migrations:

1. **Create a new migration**:

   ```bash
   dotnet ef migrations add <migration-name> \
     --project src/Survey-App \
     --startup-project src/Survey-App \
     --output-dir Database/Migrations
   ```

2. **Apply migrations to database**:

   ```bash
   dotnet ef database update --project src/Survey-App --startup-project src/Survey-App
   ```

3. **Remove last migration**:

   ```bash
   dotnet ef migrations remove --project src/Survey-App --startup-project src/Survey-App
   ```

4. **Drop the database**:
   ```bash
   dotnet ef database drop --project src/Survey-App --startup-project src/Survey-App
   ```


### Building the Solution

```bash
dotnet build
```


### Running with Debugger (Visual Studio)

To launch **both** Blazor projects under the debugger in Visual Studio:

1. Open the solution (`.sln`) in Visual Studio.
2. In the toolbar, locate the **Run** button (green ▶) and click the small **▼** drop-down arrow next to it.
3. Select **“Configure Startup Projects…”** from the menu.
4. In the dialog that appears:
   - Choose **“Multiple startup projects”**.
   - For each project (Survey-App and Reporting-App), set **Action** to either:
     - **Start** (launch under debugger), or
     - **Start Without Debugging** (launch without attaching the debugger).
5. Click **OK** to save.
6. Press **F5** (or click the Run ▶ button) to launch both apps simultaneously. Each app will open in its own browser tab with the debugger attached as configured.