package com.example.observability.service;
import org.springframework.stereotype.Service;
@Service public class DemoBusinessService {
 public boolean authenticate(String u,String p){return u!=null&&p!=null&&p.equals("demo-password");}
 public void simulateSlowOperation(){try{Thread.sleep(1500);}catch(InterruptedException e){Thread.currentThread().interrupt();throw new IllegalStateException("Slow operation interrupted",e);}}
 public void throwDemoException(){throw new IllegalStateException("Intentional demo exception for observability training");}
}
