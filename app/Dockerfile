# FROM maven:3.9-eclipse-temurin-21 AS build
# WORKDIR /workspace
# COPY pom.xml .
# RUN mvn -B -q dependency:go-offline
# COPY src ./src
# RUN mvn -B clean package -DskipTests
# FROM eclipse-temurin:21-jre
# RUN useradd --system --uid 10001 appuser
# WORKDIR /app
# COPY --from=build /workspace/target/eligibility-api-0.0.1-SNAPSHOT.jar app.jar
# USER 10001
# EXPOSE 8080
# ENV JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75.0"
# ENTRYPOINT ["java","-jar","/app/app.jar"]


FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY pom.xml .
RUN mvn -B -q dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests


FROM datadog/serverless-init:1 AS datadog


FROM eclipse-temurin:21-jre

RUN useradd --system --uid 10001 appuser



WORKDIR /app

COPY --from=build \
  /workspace/target/eligibility-api-0.0.1-SNAPSHOT.jar \
  /app/app.jar

COPY --from=datadog \
  /datadog-init \
  /app/datadog-init

# Download or copy the Java tracing agent.
COPY dd-java-agent.jar /app/dd-java-agent.jar

RUN chmod +x /app/datadog-init

USER 10001

EXPOSE 8080

ENV JAVA_TOOL_OPTIONS="-javaagent:/app/dd-java-agent.jar -XX:MaxRAMPercentage=75.0"

ENTRYPOINT ["/app/datadog-init"]

CMD ["java","-jar","/app/app.jar"]