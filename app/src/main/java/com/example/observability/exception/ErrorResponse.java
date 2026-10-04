package com.example.observability.exception; import java.time.Instant; public record ErrorResponse(String status,String code,String message,Instant timestamp){}
