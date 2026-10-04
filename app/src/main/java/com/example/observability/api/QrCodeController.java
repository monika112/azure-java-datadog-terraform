package com.example.observability.api;
import com.example.observability.logging.*; import com.example.observability.model.*; import jakarta.validation.Valid; import org.springframework.http.ResponseEntity; import org.springframework.web.bind.annotation.*; import java.util.Map;
@RestController @RequestMapping("/api/qr-code") public class QrCodeController { private final BusinessEventLogger e; public QrCodeController(BusinessEventLogger e){this.e=e;}
 @PostMapping public ResponseEntity<ApiResponse> create(@Valid @RequestBody QrCodeRequest r){Map<String,String>a=Map.of(LogFields.CLINIC_ID,r.clinicId());e.requested("qr_code.requested",a);e.success("qr_code.generated",a);return ResponseEntity.ok(ApiResponse.success("QR code generated"));}
}
