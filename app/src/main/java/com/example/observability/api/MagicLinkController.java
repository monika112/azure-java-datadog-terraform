package com.example.observability.api;
import com.example.observability.logging.*; import com.example.observability.model.*; import jakarta.validation.Valid; import org.springframework.http.ResponseEntity; import org.springframework.web.bind.annotation.*; import java.util.Map;
@RestController @RequestMapping("/api/magic-link") public class MagicLinkController { private final BusinessEventLogger e; public MagicLinkController(BusinessEventLogger e){this.e=e;}
 @PostMapping public ResponseEntity<ApiResponse> create(@Valid @RequestBody MagicLinkRequest r){Map<String,String>a=Map.of(LogFields.CLINIC_ID,r.clinicId());e.requested("magic_link.requested",a);e.success("magic_link.sent",a);return ResponseEntity.ok(ApiResponse.success("Magic link request accepted"));}
}
