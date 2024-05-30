package com.example.service;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.QuestionAnswerAdvisor;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Description;
import org.springframework.core.annotation.AliasFor;
import org.springframework.core.io.Resource;
import org.springframework.data.annotation.Id;
import org.springframework.data.repository.ListCrudRepository;
import org.springframework.stereotype.Component;

import java.lang.annotation.*;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.function.Function;

@SpringBootApplication
public class ServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServiceApplication.class, args);
    }


    @Target({ElementType.TYPE})
    @Retention(RetentionPolicy.RUNTIME)
    @Documented
    @Component
    @Description("")
    public @interface Tool {

        @AliasFor(annotation = Component.class, attribute = "value")
        String name() default "";

        @AliasFor(
                annotation = Description.class , attribute = "value"
        )
        String description();
    }


    @Tool(description = "this is a description of the this class")
    static class PetAdoptionFunction implements Function<PetAdoptionPickupRequest, PetAdoptionPickupResponse> {

        @Override
        public PetAdoptionPickupResponse apply(PetAdoptionPickupRequest petAdoptionPickupRequest) {
            return null;
        }
    }


    @Bean
    ApplicationRunner applicationRunner(
            ChatClient ai,
            DogRepository repository,
            VectorStore vectorStore
    ) {
        return args -> {

            repository.findAll().forEach(dog -> {
                var dogument = new Document("name: " + dog.name() + ", description: "
                        + dog.description(), Map.of("dogId", dog.id()));
                vectorStore.add(List.of(dogument));

            });

            var query = """
                    when can I pickup Prancer?
                    """;

            System.out.println(ai.prompt().user(query).call().content());


        };
    }

    @Bean
    @Description("schedule a pickup for dog adoptions")
    Function<PetAdoptionPickupRequest, PetAdoptionPickupResponse> schedulePetAdoptionPickup() {
        return petAdoptionPickupRequest -> {
            System.out.println("got a request [" + petAdoptionPickupRequest + "]");
            return new PetAdoptionPickupResponse(Instant.now() + "");
        };
    }

    ;


    @Bean
    ChatClient chatClient(ChatClient.Builder builder,
                          VectorStore vectorStore,
                          @Value("classpath:/system.md") Resource system) {
        return builder
                .defaultFunctions("schedulePetAdoptionPickup")
                .defaultSystem(system)
                .defaultAdvisors(new QuestionAnswerAdvisor(vectorStore, SearchRequest.defaults()))
                .build();
    }

}

interface DogRepository extends ListCrudRepository<Dog, Integer> {
}

record Dog(@Id Integer id, String name, String description) {
}

record PetAdoptionPickupRequest(String name) {
}

record PetAdoptionPickupResponse(String when) {
}

