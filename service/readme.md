# README

## Pre-Demo 
* make sure to run the following `.sql` file before starting the program.

```shell
cat dogs.sql | PGPASSWORD=secret psql -U myuser -h localhost mydatabase
```

## Setup 
* christian and i wanted to revisit the theme of the famed petclinic. why? well, who doesn't love a good pet ? 
* I have a pet. he's a dog named Peanut. He is terrible. a tiny tyrant. a furry fascist.  The absolute worst. He bites. He growls. He leaves little duckies on the floor like little land mines. If you dare tread anywhere near those duckies on HIS floor, you might lose a foot! 
* He reminds me of this dog, a "neurotic, man hating, animal hating, children hating dogs that look like gremlins": https://www.facebook.com/tyfanee.fortuna/posts/10219752628710467
(search for "child" - she mentions it twice and both are funny!)
* if he's so terrible, you might ask, why do I keep him? 
* well, it's because I'm not very smart. My partner and daughter both speak 5 languages. I only speak 3.5. If this dog wasn't around, I'd be the stupidest guy in the house!
* and, he _is_ cute! (Open picture)

## Demo 

### start.spring.io 
* Java 21, OpenAI, GraalVM, Web, Data JDBC, PgVector, Docker Compose 
* mention the Docker Compose / Service Connectors work
* make sure that people know that we've got a ton of different LLMs, Models, etc., on the Initializr. 

## Initializr 
* disable Docker Compose 
* expose port in `compose.yml`
* specify SQL DB connectivity in `application.properties`


## Define a Single ChatClient `@Bean`

```java
    
    @Bean
    ChatClient chatClient() {
        return builder.build();
    }
```


## Chat Client: Tell Me A Story About Barcelona in the Style of Dr. Seuss
```java

@Bean
ApplicationRunner runner(ChatClient ai) {
    return args -> {
        var user = """
                Dear Singularity,
                                
                tell me a story about dogs in the beautiful city of Barcelona, Spain, and do so in the style of
                famed children's author, Dr. Seuss. 
                                
                Cordially, 
                Josh
                """;
        var content = cc.prompt().user(user).call().content();
        System.out.println("response: " + content);
    };
}
```
* have you seen that documentary, Terminator? It taught me that it _always_ pays to be polite. They will remember. BE POLITE.

## Bringing our Data to the LLM 
* the problem here is that our LLM doesn't know about our data. How do we connect them? Let's suppose we've got
* introduce the domain. create the `Dog` entity and its repository 

```shell 
interface DogRepository extends ListCrudRepository<Dog, Integer> {
    Optional<Dog> findByName(String name);
}

record Dog(@Id Integer id, String name, LocalDate dob, String description) {
}
```

* we want to build an assistant that will help connect potential pet adopters to their new dogs. Ask it: "I am looking for a child-hating dog." with no system prompt. It'll give us a bad answer.
* then add the system prompt in `pet-adoption-system-prompt.md`. Ask again. It'll give us an in-persona response. 
* but we want to make it aware of our data. RAG-to-the-future! 
* ` .defaultAdvisors(new QuestionAnswerAdvisor(vectorStore, SearchRequest.defaults())) `
* the problem here is of course that it doesn't know about our `VectorStore`. What's a `VectorStore`? It's a way to find similar results. We need to load our data from our SQL Db and write it into the `VectorStore`
* the following code adds each dog and their name into the `VectorStore`. It works fine. We also add some metadata. 
```shell 
var tts = new TokenTextSplitter();
dogRepository.findAll().forEach(dog -> {
    var doc = new Document("name:" + dog.name() + ", description: " + dog.description(), Map.of("dogId", dog.id()));
    var docs = tts.split(doc);
    vectorStore.add(docs);
});
```
* Run this once. 
* **DISABLE** the VectorStore initialization _and_ delete this ingest code. we don't want to load the data into the `VectorStore`. 
* Now we cna find the data with free-form natural language search. Let's teach our `ChatClient` about it. 
* Add a new `QuestionAnswerAdvisor` to the `ChatClient`. 
* this isn't PHP! I want a RAG pipeline so I added this and I got one! What did YOU do today? 

## Functions
* it looks like we found our doggo! I'd like to take him home, wouldn't you Christian? 
* what's the next step? We need to gie our AI Assistant the ability to integrate with our existing backend pickup scheduling system. And we can do this with the use of portable functions! 
* The idea is that the AI can reason and then invoke helper functions to satisfy a request. This is useful when you want to give it executive agency and when you want to connect it to fresh, lively, up to date information that it woudln't have known about.
* Let's take a look

```java

  
@Description("helps potential pet adopters determine when they can collect their new dogs")
@Bean(PET_PICKUP_FUNCTION_NAME)
Function<PetPickupRequest, PetPickupResponse> determinePickupForPetAdoption( ) {
    return petPickupRequest -> {
        System.out.println("got a request for [" + petPickupRequest + "]");
        return new PetPickupResponse(Instant.now() + "");
    };
}


record PetPickupRequest(String dogName) {
}

record PetPickupResponse(String when) {
}


```
 * make sure to specify WHEN as a String!!
 * we'll also have to make the sytem aware of our functions. change the `chatClient`
 