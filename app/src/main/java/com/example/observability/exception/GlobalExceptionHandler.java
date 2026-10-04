package com.example.observability.exception;
import com.example.observability.logging.LogFields; import org.slf4j.*; import org.springframework.http.*; import org.springframework.web.bind.MethodArgumentNotValidException; import org.springframework.web.bind.annotation.*; import java.time.Instant;
@RestControllerAdvice public class GlobalExceptionHandler { private static final Logger log=LoggerFactory.getLogger(GlobalExceptionHandler.class);
 @ExceptionHandler(MethodArgumentNotValidException.class) public ResponseEntity<ErrorResponse> validation(MethodArgumentNotValidException ex){MDC.put(LogFields.ERROR_TYPE,ex.getClass().getSimpleName());log.warn("request_validation_failed");return ResponseEntity.badRequest().body(new ErrorResponse("failure","VALIDATION_ERROR","Request validation failed",Instant.now()));}
 @ExceptionHandler(Exception.class) public ResponseEntity<ErrorResponse> unexpected(Exception ex){MDC.put(LogFields.ERROR_TYPE,ex.getClass().getSimpleName());log.error("unhandled_application_exception",ex);return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse("error","INTERNAL_ERROR","An unexpected error occurred",Instant.now()));}
}
