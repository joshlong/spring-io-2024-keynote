package com.example.service;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.QuestionAnswerAdvisor;
import org.springframework.ai.document.Document;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.VectorStore;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Description;
import org.springframework.core.io.Resource;
import org.springframework.data.annotation.Id;
import org.springframework.data.repository.ListCrudRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

// having it act as an assistant to choose a dog matching criteria is good?
// we could also have it decide to book a reservation for us if our dog is sickly?

@SpringBootApplication
public class ServiceApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServiceApplication.class, args);
    }


    @Bean
    ChatClient chatClient(ChatClient.Builder builder,
                          VectorStore vectorStore,
                          @Value("classpath:/pet-adoption-system-prompt.md") Resource systemInstructions) {
        return builder
                // <1> don't have a system prompt
                .defaultFunctions(PET_PICKUP_FUNCTION_NAME)
                .defaultSystem(systemInstructions) // <2> give it a system prompt but there's no data so it should reply in a disappointed way
                .defaultAdvisors(new QuestionAnswerAdvisor(vectorStore, SearchRequest.defaults())) // <3> now we teach it about our data
                .build();
    }


    static final String PET_PICKUP_FUNCTION_NAME = "determinePickupForPetAdoption";

    @Description("helps potential pet adopters determine when they can collect their new dogs")
    @Bean(PET_PICKUP_FUNCTION_NAME)
    Function<PetPickupRequest, PetPickupResponse> determinePickupForPetAdoption(DogRepository dogRepository) {
        return petPickupRequest -> {
            System.out.println("got a request for [" + petPickupRequest + "]");
            var dogByName = dogRepository.findByName(petPickupRequest.dogName());
            return dogByName
                    .map(dog -> new PetPickupResponse(Instant.now().toString()))
                    .orElse(new PetPickupResponse("no dog for you!"));

        };
    }

    private static void chatClient101(ChatClient cc) {
        var user = """
                Dear Singularity,
                                
                tell me a story about dogs in the beautiful city of Barcelona, Spain, and do so in the style of
                famed children's author, Dr. Seuss. 
                                
                Cordially, 
                Josh
                """;
        var content = cc.prompt().user(user).call().content();
        System.out.println("response: " + content);
    }

    private static void chatClientRag(ChatClient cc) {
        var content = cc.prompt()
//                .user("i am looking for a child hating dog") // <3>
                .user("i am looking for a child hating dog") // <4>
                .call()
                .content();
        System.out.println("content: " + content);
    }

    private static void vectorStoreIngest(DogRepository dogRepository, VectorStore vectorStore) {
        var tts = new TokenTextSplitter();
        dogRepository.findAll().forEach(dog -> {
            var doc = new Document("name:" + dog.name() + ", description: " + dog.description(),
                    Map.of("clinic", (Math.random() > .5 ? "barcelona" : "madrid"), "dogId", dog.id()));
            var docs = tts.split(doc);
            vectorStore.add(docs);
        });
        System.out.println("all done.");
    }

    private static void similaritySearch(VectorStore vectorStore) {
        var documents = vectorStore
                .similaritySearch(SearchRequest.query("a child hating dog")
                        .withFilterExpression(" clinic == 'madrid'   "));
        for (var d : documents)
            System.out.println(d.toString());
    }

    @Bean
    ApplicationRunner runner(
            VectorStore vectorStore, @Value("classpath:/dogs.txt") Resource dogs,
            ChatClient ai) {
        return args -> {
            // todo make sure we set the openai model to be spring.ai.openai.chat.options.model=gpt-4o

//            chatClient1(ai);

//            chatClientRag(ai);
//            similaritySearch(vectorStore);

            chatClientFunctions(ai);

            //vectorStoreIngest(dogRepository, vectorStore);
            //similaritySearch(vectorStore);


        };
    }

    private static void chatClientFunctions(ChatClient cc) {
        // Balkan
        System.out.println(cc.prompt().user("when can I pick up my new dog ?").call().content());
//        System.out.println(cc.prompt().user("when can I pick up my new dog Prancer ?").call().content());
//        System.out.println(cc.prompt().user("when can I pick up my new dog").call().content());
    }

}




record PetPickupRequest(String dogName) {
}

record PetPickupResponse(String when) {
}

interface DogRepository extends ListCrudRepository<Dog, Integer> {

    Optional<Dog> findByName(String name);
}

record Dog(@Id Integer id, String name, LocalDate dob, String description) {
}