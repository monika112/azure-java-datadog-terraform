package com.example.observability.model;
import java.time.Instant;
public record ApiResponse(String status,String message,Instant timestamp){
 public static ApiResponse success(String m){return new ApiResponse("success",m,Instant.now());}
 public static ApiResponse failure(String m){return new ApiResponse("failure",m,Instant.now());}
}
