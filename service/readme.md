# README

## pre-Demo 
* make sure to run 
```java
@Profile("prancer")
@Configuration
class Init {

    @Bean
    ApplicationRunner applicationRunner(DogRepository dogRepository, @Value("classpath:/dogs.txt") Resource dogs) {
        return args -> preIngest(dogRepository, dogs);
    }

    private static LocalDate dateString(String date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        LocalDate localDate = LocalDate.parse(date, formatter);
        return localDate.atStartOfDay().atZone(ZoneId.systemDefault()).toLocalDate();
    }

    private static void preIngest(DogRepository dogRepository, Resource dogs) throws Exception {
        var lines = dogs.getContentAsString(Charset.defaultCharset()).split(System.lineSeparator());
        for (var l : lines) {
            var line = l.split(";");
            dogRepository.save(new Dog(null, line[0], dateString(line[1]),
                    line[2]));
        }
    }
}
```

this will load all the data in the `dogs.txt` file into the SQL database we'll be using.

