package com.example.observability.api;
import com.example.observability.model.ApiResponse; import com.example.observability.service.DemoBusinessService; import org.springframework.http.ResponseEntity; import org.springframework.web.bind.annotation.*;
@RestController @RequestMapping("/api/demo") public class DemoController { private final DemoBusinessService s; public DemoController(DemoBusinessService s){this.s=s;}
 @GetMapping("/success") public ResponseEntity<ApiResponse> success(){return ResponseEntity.ok(ApiResponse.success("Demo request succeeded"));}
 @GetMapping("/failure") public ResponseEntity<ApiResponse> failure(){return ResponseEntity.badRequest().body(ApiResponse.failure("Intentional demo client failure"));}
 @GetMapping("/slow") public ResponseEntity<ApiResponse> slow(){s.simulateSlowOperation();return ResponseEntity.ok(ApiResponse.success("Intentional slow request completed"));}
 @GetMapping("/exception") public ResponseEntity<ApiResponse> exception(){s.throwDemoException();return ResponseEntity.ok(ApiResponse.success("unreachable"));}
}
