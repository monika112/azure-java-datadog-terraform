package com.example.observability.model;
import jakarta.validation.constraints.NotBlank;
public record QrCodeRequest(@NotBlank String clinicId) {}
