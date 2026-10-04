package com.example.observability.config;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;
@Configuration
@EnableConfigurationProperties(ObservabilityProperties.class)
public class ApplicationConfig {}
