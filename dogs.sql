--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dog; Type: TABLE; Schema: public; Owner: myuser
--

CREATE TABLE public.dog (
    id integer NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    dob date NOT NULL
);


ALTER TABLE public.dog OWNER TO myuser;

--
-- Name: dog_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.dog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dog_id_seq OWNER TO myuser;

--
-- Name: dog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.dog_id_seq OWNED BY public.dog.id;


--
-- Name: dog id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dog ALTER COLUMN id SET DEFAULT nextval('public.dog_id_seq'::regclass);


--
-- Data for Name: dog; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.dog (id, name, description, dob) FROM stdin;
1	Tiffany	A golden Poodle known for being calm.	2020-01-07
2	Frank	A brown Poodle known for being loyal.	2014-04-07
3	Keith	A golden Poodle known for being calm.	2013-10-30
4	Hannah	A brindle Poodle known for being calm.	2021-09-19
5	Alicia	A spotted Poodle known for being affectionate.	2021-07-31
6	Kathleen	A grey Poodle known for being affectionate.	2013-08-02
7	Kimberly	A grey Poodle known for being protective.	2019-02-22
8	Matthew	A white Poodle known for being affectionate.	2020-04-07
9	Carol	A tan Poodle known for being protective.	2010-07-01
10	James	A black Poodle known for being loyal.	2016-09-29
11	John	A tan Golden Retriever known for being friendly.	2017-12-31
12	Brooke	A spotted Golden Retriever known for being energetic.	2022-05-20
13	Kristin	A grey Golden Retriever known for being friendly.	2009-02-24
14	Adam	A golden Golden Retriever known for being energetic.	2010-05-01
15	Tami	A black Golden Retriever known for being curious.	2012-04-30
16	Benjamin	A golden Golden Retriever known for being curious.	2016-12-22
17	Elizabeth	A black Golden Retriever known for being curious.	2018-10-23
18	Mark	A white Golden Retriever known for being protective.	2017-04-12
19	Joshua	A brindle Golden Retriever known for being affectionate.	2013-02-20
20	Brandon	A brown Golden Retriever known for being protective.	2015-03-16
21	Lisa	A brindle Pomeranian known for being calm.	2022-04-16
22	Jessica	A brindle Golden Retriever known for being curious.	2017-02-09
23	John	A spotted Chihuahua known for being playful.	2018-08-11
24	Amanda	A grey Chihuahua known for being playful.	2015-03-12
25	Kimberly	A tan Golden Retriever known for being playful.	2011-11-04
26	Jerry	A spotted German Shepherd known for being affectionate.	2016-02-15
27	Jeremy	A golden Beagle known for being calm.	2010-08-29
28	Jessica	A brindle Rottweiler known for being protective.	2020-03-08
29	Brittany	A tan Chihuahua known for being affectionate.	2020-12-04
30	Stephanie	A grey Beagle known for being curious.	2012-03-26
31	Melissa	A spotted Poodle known for being protective.	2021-12-21
32	Paula	A tan Chihuahua known for being playful.	2015-05-03
33	Jennifer	A golden Dachshund known for being playful.	2011-05-25
34	Edward	A grey Dachshund known for being affectionate.	2017-10-18
35	Bobby	A golden German Shepherd known for being affectionate.	2018-05-07
36	Daniel	A grey German Shepherd known for being calm.	2020-12-01
37	Benjamin	A black Boxer known for being protective.	2017-08-05
38	Tracy	A brown German Shepherd known for being protective.	2011-11-10
39	Karen	A golden Siberian Husky known for being energetic.	2009-03-23
40	Debra	A grey Dachshund known for being energetic.	2015-11-29
41	Timothy	A brindle Poodle known for being loyal.	2019-03-16
42	Jade	A black Shih Tzu known for being affectionate.	2015-03-22
43	Brandon	A grey Siberian Husky known for being curious.	2009-11-04
44	Kimberly	A tan Bulldog known for being friendly.	2022-09-20
45	Prancer	A demonic, neurotic, man hating, animal hating, children hating dogs that look like gremlins.	2008-12-19
46	Leslie	A black Bulldog known for being curious.	2008-12-10
47	Shawn	A white Chihuahua known for being calm.	2012-01-23
48	Andre	A white Pomeranian known for being energetic.	2008-12-07
49	Mary	A grey Great Dane known for being affectionate.	2022-08-10
50	Melissa	A white Boxer known for being calm.	2018-05-13
51	Jacqueline	A golden Shih Tzu known for being playful.	2009-11-22
52	Christopher	A white Dachshund known for being affectionate.	2010-07-12
53	John	A tan Yorkshire Terrier known for being loyal.	2023-01-05
54	Derrick	A spotted German Shepherd known for being protective.	2018-04-08
55	Scott	A grey Boxer known for being affectionate.	2008-12-23
56	Stephanie	A tan Rottweiler known for being curious.	2023-02-05
57	Larry	A golden Pomeranian known for being curious.	2020-04-09
58	Tina	A brindle Yorkshire Terrier known for being affectionate.	2021-04-28
59	Nicole	A spotted Bulldog known for being loyal.	2009-02-23
60	Ana	A golden Siberian Husky known for being calm.	2022-10-24
61	Nicole	A white Great Dane known for being protective.	2014-05-07
62	Rebecca	A brindle Golden Retriever known for being playful.	2012-08-16
63	Maureen	A grey Shih Tzu known for being protective.	2016-01-05
64	Zachary	A white Boxer known for being curious.	2022-01-14
65	Lauren	A white Great Dane known for being protective.	2021-11-07
66	Kayla	A white Doberman known for being protective.	2017-02-15
67	Steven	A tan Boxer known for being affectionate.	2011-12-22
68	Elizabeth	A tan Siberian Husky known for being energetic.	2015-08-22
69	Cynthia	A grey Doberman known for being playful.	2008-12-31
70	Nicole	A grey Siberian Husky known for being protective.	2020-06-06
71	Stacey	A golden Chihuahua known for being curious.	2014-03-22
72	Jill	A white Chihuahua known for being loyal.	2012-04-07
73	Carlos	A brindle Dachshund known for being energetic.	2021-12-07
74	Austin	A brindle Rottweiler known for being loyal.	2022-03-28
75	Audrey	A spotted Boxer known for being protective.	2019-11-18
76	Nina	A spotted Great Dane known for being calm.	2016-04-07
77	Brittany	A tan Siberian Husky known for being friendly.	2022-01-26
78	Courtney	A spotted German Shepherd known for being playful.	2017-01-10
79	Jennifer	A spotted Shih Tzu known for being energetic.	2023-03-09
80	Kenneth	A golden Pomeranian known for being protective.	2022-04-18
81	Trevor	A tan Dachshund known for being curious.	2020-04-27
82	William	A grey Poodle known for being curious.	2014-11-30
83	Dawn	A black Bulldog known for being friendly.	2020-01-17
84	Gregory	A black Yorkshire Terrier known for being energetic.	2009-12-19
85	Charles	A grey Rottweiler known for being playful.	2014-02-05
86	Julia	A grey Bulldog known for being protective.	2022-12-11
87	Kristy	A tan Dachshund known for being playful.	2022-03-22
88	Charles	A brown Doberman known for being friendly.	2009-06-03
89	Andrew	A black Bulldog known for being curious.	2021-08-26
90	Ethan	A grey Dachshund known for being friendly.	2013-05-13
91	Steven	A brindle Great Dane known for being calm.	2011-11-15
92	Amanda	A white Pomeranian known for being calm.	2018-04-06
93	William	A white German Shepherd known for being friendly.	2017-03-19
94	Lindsay	A brown Poodle known for being curious.	2015-05-07
95	Kathryn	A grey Great Dane known for being loyal.	2020-11-03
96	Alicia	A golden German Shepherd known for being friendly.	2012-11-15
97	Richard	A brown Chihuahua known for being protective.	2019-01-28
98	William	A brindle Pomeranian known for being protective.	2018-06-04
99	Donna	A grey Doberman known for being affectionate.	2010-08-26
100	Kayla	A golden Pomeranian known for being loyal.	2022-08-24
101	Lisa	A spotted German Shepherd known for being loyal.	2020-07-30
\.


--
-- Name: dog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.dog_id_seq', 101, true);


--
-- Name: dog dog_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.dog
    ADD CONSTRAINT dog_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

