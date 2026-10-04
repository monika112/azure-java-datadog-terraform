package com.example.observability.model;
import jakarta.validation.constraints.NotBlank;
public record MagicLinkRequest(@NotBlank String clinicId) {}
