FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /src

# Must match the actual folder “src/Reporting-App”
COPY ["Reporting-App.csproj", "./"]
RUN dotnet restore "Reporting-App/Reporting-App.csproj"

COPY . .
WORKDIR "/src/Reporting-App"
RUN dotnet publish "Reporting-App.csproj" \
    --configuration Release \
    --output /app/out

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build-env /app/out ./
ENTRYPOINT ["dotnet", "Reporting-App.dll"]
