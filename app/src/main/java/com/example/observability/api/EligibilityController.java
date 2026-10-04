package com.example.observability.api;
import com.example.observability.logging.*; import com.example.observability.model.*; import jakarta.validation.Valid; import org.springframework.http.ResponseEntity; import org.springframework.web.bind.annotation.*; import java.util.Map;
@RestController @RequestMapping("/api/eligibility") public class EligibilityController { private final BusinessEventLogger e; public EligibilityController(BusinessEventLogger e){this.e=e;}
 @GetMapping("/{clinicId}") public ResponseEntity<ApiResponse> get(@PathVariable String clinicId){Map<String,String>a=Map.of(LogFields.CLINIC_ID,clinicId);e.requested("eligibility.requested",a);e.success("eligibility.success",a);return ResponseEntity.ok(ApiResponse.success("Clinic is eligible"));}
 @PostMapping public ResponseEntity<ApiResponse> post(@Valid @RequestBody EligibilityRequest r){Map<String,String>a=Map.of(LogFields.CLINIC_ID,r.clinicId());e.requested("eligibility.requested",a);e.success("eligibility.success",a);return ResponseEntity.ok(ApiResponse.success("Eligibility request completed"));}
}
