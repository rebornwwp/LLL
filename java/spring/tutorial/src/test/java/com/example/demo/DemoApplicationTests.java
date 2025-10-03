package com.example.demo;

import static org.hamcrest.Matchers.equalTo;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.demo.web.HelloController;
import com.example.demo.web.UserController;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockServletContext;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultHandlers;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
public class DemoApplicationTests {

	private MockMvc mvc;

	@Before
	public void setUp() throws Exception {
		mvc = MockMvcBuilders.standaloneSetup(new HelloController(), new UserController()).build();
	}

	@Test
	public void getHello() throws Exception {
		mvc.perform(MockMvcRequestBuilders.get("/hello").accept(MediaType.APPLICATION_JSON)).andExpect(status().isOk())
				.andExpect(content().string(equalTo("hello world")));
	}

	@Test
	public void testUserController() throws Exception {
		RequestBuilder request = null;
		request = get("/users/");
		mvc.perform(request).andExpect(status().isOk()).andExpect(content().string(equalTo("[]")));

		request = post("/users/").param("id", "1").param("name", "大师").param("age", "20");
		mvc.perform(request).andDo(MockMvcResultHandlers.print()).andExpect(content().string(equalTo("success")));

		request = get("/users/");
		mvc.perform(request).andExpect(content().string(equalTo("[{\"id\":1,\"name\":\"大师\",\"age\":20}]")));

		request = put("/users/1").param("name", "dashi").param("age", "30");
		mvc.perform(request).andExpect(content().string(equalTo("{\"id\":1,\"name\":\"dashi\",\"age\":30}")));

		request = delete("/users/1");
		mvc.perform(request).andExpect(content().string(equalTo("success")));

		request = get("/users/");
		mvc.perform(request).andExpect(status().isOk()).andExpect(content().string(equalTo("[]")));
	}

}
