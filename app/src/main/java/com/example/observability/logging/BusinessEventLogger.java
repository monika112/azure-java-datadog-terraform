package com.example.observability.logging;
import org.slf4j.*; import org.springframework.stereotype.Component; import java.util.*;
@Component
public class BusinessEventLogger {
 private static final Logger log=LoggerFactory.getLogger(BusinessEventLogger.class);
 public void success(String n,Map<String,String>a){emit(n,"success",a);} public void failure(String n,Map<String,String>a){emit(n,"failure",a);} public void requested(String n,Map<String,String>a){emit(n,"requested",a);}
 private void emit(String n,String s,Map<String,String>a){Map<String,String> old=MDC.getCopyOfContextMap(); try{MDC.put(LogFields.EVENT_NAME,n);MDC.put(LogFields.EVENT_CATEGORY,"business");MDC.put(LogFields.EVENT_STATUS,s);MDC.put(LogFields.EVENT_VERSION,"1"); if(a!=null)a.forEach((k,v)->{if(v!=null&&!v.isBlank())MDC.put(k,v);}); log.info("business_event");}finally{MDC.clear();if(old!=null)MDC.setContextMap(old);}}
}
