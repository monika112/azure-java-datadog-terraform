package com.example.observability.model;
import jakarta.validation.constraints.NotBlank;
public record EligibilityRequest(@NotBlank String clinicId) {}
