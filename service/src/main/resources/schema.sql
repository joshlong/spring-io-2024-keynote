create table if not exists dog (
    id serial primary key ,
    name text not null ,
    description text not null  ,
    dob date not null
) ;
