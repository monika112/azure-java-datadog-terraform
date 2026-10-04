package com.example.observability.api;
import com.example.observability.model.ApiResponse; import org.springframework.http.ResponseEntity; import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/health") public class HealthController {
 @GetMapping("/live") public ResponseEntity<ApiResponse> live(){return ResponseEntity.ok(ApiResponse.success("Application process is alive"));}
 @GetMapping("/ready") public ResponseEntity<ApiResponse> ready(){return ResponseEntity.ok(ApiResponse.success("Application is ready"));}
}
