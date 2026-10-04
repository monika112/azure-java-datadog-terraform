package com.example.observability.config;
import org.springframework.boot.context.properties.ConfigurationProperties;
@ConfigurationProperties(prefix="app.observability")
public record ObservabilityProperties(String service,String environment,String version) {}
