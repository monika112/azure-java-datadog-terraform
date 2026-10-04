package com.example.observability;
import org.junit.jupiter.api.Test; import org.springframework.beans.factory.annotation.Autowired; import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc; import org.springframework.boot.test.context.SpringBootTest; import org.springframework.test.web.servlet.MockMvc; import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get; import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
@SpringBootTest @AutoConfigureMockMvc class ApiIntegrationTests { @Autowired MockMvc mvc;
 @Test void success()throws Exception{mvc.perform(get("/api/demo/success").header("X-Correlation-ID","test-123")).andExpect(status().isOk()).andExpect(header().string("X-Correlation-ID","test-123"));}
 @Test void failure()throws Exception{mvc.perform(get("/api/demo/failure")).andExpect(status().isBadRequest());}
 @Test void exception()throws Exception{mvc.perform(get("/api/demo/exception")).andExpect(status().isInternalServerError());}
}
