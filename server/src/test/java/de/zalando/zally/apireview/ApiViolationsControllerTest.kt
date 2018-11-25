package de.zalando.zally.apireview

import de.zalando.zally.configuration.JacksonObjectMapperConfiguration
import de.zalando.zally.dto.ApiDefinitionRequest
import org.hamcrest.Matchers.containsString
import org.intellij.lang.annotations.Language
import org.junit.Test
import org.junit.runner.RunWith
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.content
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

@RunWith(SpringRunner::class)
@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureMockMvc
@Suppress("UnsafeCallOnNullableType")
class ApiViolationsControllerTest {

    @Autowired
    private val mvc: MockMvc? = null

    @Test
    @Throws(Exception::class)
    fun violationsResponseReferencesFullGuidelinesUrl() {
        mvc!!.perform(
            post("/api-violations")
                .contentType("application/json")
                .content("{\"api_definition_string\":\"\"}")
        )
            .andExpect(status().isOk)
            .andExpect(content().string(containsString("https://zalando.github.io/restful-api-guidelines")))
    }

    @Test
    fun `getExistingViolationResponse with no previous apis responds NotFound`() {
        mvc!!.perform(
            get("/api-violations/00000000-0000-0000-0000-000000000000")
                .accept("application/json")
        )
            .andExpect(status().isNotFound)
    }

    @Test
    fun `getExistingViolationResponse with existing responds NotFound`() {

        val location = mvc!!.perform(
            post("/api-violations")
                .contentType("application/json")
                .content("{\"api_definition_string\":\"\"}")
        )
            .andExpect(status().isOk)
            .andReturn().response.getHeaderValue("Location")!!

        mvc.perform(
            get(location.toString())
                .accept("application/json")
        )
            .andExpect(status().isOk)
            .andExpect(content().string(containsString("https://zalando.github.io/restful-api-guidelines")))
    }

    /**
     * This test runs all rules against an API specification with recursive references. It prevents check developers
     * from StackOverflow exceptions during the check execution.
     *
     * General advice: Don't use `hashCode` or `toString` methods on the OpenAPI elements since they don't support
     * recursion. Keep in mind that these methods can be called implicitly (e.g. when putting objects in a Set).
     */
    @Test
    fun `all rules must be able to cope with recursive api specifications`() {
        val objectMapper = JacksonObjectMapperConfiguration().createObjectMapper()
        val request = objectMapper.writeValueAsString(ApiDefinitionRequest(apiDefinitionString = recursiveSpec))
        mvc!!.perform(
            post("/api-violations")
                .contentType("application/json")
                .content(request)
        )
            .andExpect(status().isOk)
    }

    /**
     * This test runs all rules against an empty OpenAPI object. It checks for possible NPE in the check implementation
     * when traversing the OpenAPI object tree. By having this test in place we don't have to write such a test for each
     * rule.
     */
    @Test
    fun `all rules must be able to cope with empty (minimal) api specifications`() {
        val objectMapper = JacksonObjectMapperConfiguration().createObjectMapper()
        val request = objectMapper.writeValueAsString(ApiDefinitionRequest(apiDefinitionString = "openapi: 3.0.1"))
        mvc!!.perform(
            post("/api-violations")
                .contentType("application/json")
                .content(request)
        )
            .andExpect(status().isOk)
    }

    @Language("YAML")
    private val recursiveSpec = """
      openapi: 3.0.1
      paths:
        /products/{product_id}:
          get:
            responses:
              200:
                content:
                  application/json:
                    schema:
                      ${'$'}ref: "#/components/schemas/FacetGetResponse"
      components:
        schemas:
          FacetGetResponse:
            allOf:
              - ${'$'}ref: "#/components/schemas/ProductResource"
          ProductResource:
            allOf:
              - type: object
                properties:
                  children:
                    type: array
                    items:
                      ${'$'}ref: "#/components/schemas/ProductResource"
        """.trimIndent()
}
