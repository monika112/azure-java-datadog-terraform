package com.example.observability.logging;
import com.example.observability.config.ObservabilityProperties; import jakarta.servlet.*; import jakarta.servlet.http.*; import org.slf4j.*; import org.springframework.core.*; import org.springframework.core.annotation.Order; import org.springframework.stereotype.Component; import org.springframework.web.filter.OncePerRequestFilter; import java.io.IOException; import java.util.UUID; import java.util.concurrent.TimeUnit;
@Component @Order(Ordered.HIGHEST_PRECEDENCE)
public class RequestTelemetryFilter extends OncePerRequestFilter {
 public static final String CORRELATION_HEADER="X-Correlation-ID"; private static final Logger log=LoggerFactory.getLogger(RequestTelemetryFilter.class); private final ObservabilityProperties p;
 public RequestTelemetryFilter(ObservabilityProperties p){this.p=p;}
 @Override protected void doFilterInternal(HttpServletRequest req,HttpServletResponse res,FilterChain chain)throws ServletException,IOException{
  long start=System.nanoTime(); String requestId=UUID.randomUUID().toString(); String correlationId=resolve(req);
  try{MDC.put(LogFields.SERVICE,safe(p.service(),"eligibility-api"));MDC.put(LogFields.ENV,safe(p.environment(),"local"));MDC.put(LogFields.VERSION,safe(p.version(),"local"));MDC.put(LogFields.REQUEST_ID,requestId);MDC.put(LogFields.CORRELATION_ID,correlationId);MDC.put(LogFields.HTTP_METHOD,req.getMethod());MDC.put(LogFields.ENDPOINT,req.getRequestURI());res.setHeader(CORRELATION_HEADER,correlationId);chain.doFilter(req,res);}
  catch(Exception ex){MDC.put(LogFields.ERROR_TYPE,ex.getClass().getSimpleName());throw ex;}
  finally{long ms=TimeUnit.NANOSECONDS.toMillis(System.nanoTime()-start);int st=res.getStatus();MDC.put(LogFields.HTTP_STATUS_CODE,Integer.toString(st));MDC.put(LogFields.DURATION_MS,Long.toString(ms));MDC.put(LogFields.EVENT_CATEGORY,"technical");MDC.put(LogFields.EVENT_NAME,st>=400?"user.endpoint_access_failed":"user.endpoint_accessed");MDC.put(LogFields.EVENT_STATUS,st>=500?"error":st>=400?"failure":"success");MDC.put(LogFields.EVENT_VERSION,"1"); if(st>=500)log.error("http_request_completed");else if(st>=400)log.warn("http_request_completed");else log.info("http_request_completed");MDC.clear();}
 }
 private String resolve(HttpServletRequest req){String v=req.getHeader(CORRELATION_HEADER);return v==null||v.isBlank()||v.length()>128?UUID.randomUUID().toString():v;}
 private String safe(String v,String f){return v==null||v.isBlank()?f:v;}
}
