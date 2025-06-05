FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build-env
WORKDIR /src

COPY ["Survey-App/Survey-App.csproj", "Survey-App/"]
RUN dotnet restore "Survey-App/Survey-App.csproj"

COPY . .
WORKDIR "/src/Survey-App"
RUN dotnet publish "Survey-App.csproj" \
    --configuration Release \
    --output /app/out

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build-env /app/out ./

ENTRYPOINT ["dotnet", "Survey-App.dll"]
