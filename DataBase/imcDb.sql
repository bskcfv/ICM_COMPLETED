--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: f_imc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_imc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Reglas de Validacion
IF NEW.CC <= 0 THEN
RAISE EXCEPTION 'CC Debe ser Mayor de 0';
END IF;
IF NEW.PESO <= 0 THEN
RAISE EXCEPTION 'El Peso debe Ser mayor de 0.';
END IF;
IF NEW.ESTATURA <= 0 THEN
RAISE EXCEPTION 'La Estatura debe ser mayor de 0.';
END IF;
IF NEW.EDAD NOT BETWEEN 1 AND 100 THEN
RAISE EXCEPTION 'Digite una Edad Valida';
END IF;

-- Calcular IMC Y actualizar el IMC
NEW.IMC := NEW.PESO / POWER((NEW.ESTATURA/100),2);
-- Determinar CLASIFICACION
IF NEW.IMC < 18.49 THEN 
NEW.CLASIFICACION := 'PESO BAJO';
ELSIF NEW.IMC BETWEEN 18.50 AND 24.99 THEN
NEW.CLASIFICACION := 'PESO NORMAL';
ELSIF NEW.IMC BETWEEN 25 AND 29.99 THEN
NEW.CLASIFICACION := 'SOBREPESO';
ELSIF NEW.IMC BETWEEN 30 AND 34.99 THEN
NEW.CLASIFICACION := 'OBESIDAD LEVE';
ELSIF NEW.IMC BETWEEN 35 AND 39.99 THEN
NEW.CLASIFICACION := 'OBESIDAD MEDIA';
ELSIF NEW.IMC > 40 THEN
NEW.CLASIFICACION := 'OBESIDAD MORBIDA';
END IF;

RETURN NEW; 
END; 
$$;


ALTER FUNCTION public.f_imc() OWNER TO postgres;

--
-- Name: f_imc_client(integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_imc_client(v_cc integer, v_peso numeric, v_estatura numeric) RETURNS TABLE(nombre text, imc numeric, clasificacion text)
    LANGUAGE plpgsql
    AS $$
BEGIN
-- Update Usuario 
UPDATE USERS
SET PESO = v_peso, ESTATURA = v_estatura
WHERE CC = v_cc;
-- Retornar Query Con Info Necesaria
RETURN QUERY
SELECT U.NOMBRE AS NOMBRE,
U.IMC AS IMC,
U.CLASIFICACION AS CLASIFICACION
FROM USERS AS U
WHERE U.CC = v_cc;
END;
$$;


ALTER FUNCTION public.f_imc_client(v_cc integer, v_peso numeric, v_estatura numeric) OWNER TO postgres;

--
-- Name: f_ims(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_ims() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
v_imc DECIMAL(5,2);
BEGIN
-- Reglas de Validacion
IF NEW.PESO <= 0 THEN
RAISE EXCEPTION 'El Peso debe Ser mayor de 0.';
END IF;
IF NEW.ESTATURA <= 0 THEN
RAISE EXCEPTION 'La Estatura debe ser mayor de 0.';
END IF;
-- Calcular IMS
v_imc := NEW.PESO / POWER(NEW.ESTATURA,2);
-- Actualizar IMS del User
NEW.IMC := v_imc;
RETURN NEW; 
END; 
$$;


ALTER FUNCTION public.f_ims() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    cc integer NOT NULL,
    nombre text,
    apellido text,
    edad integer,
    peso numeric(5,2),
    estatura numeric(5,2),
    genero text DEFAULT 'Genero No Especificado'::text,
    imc numeric(5,2),
    clasificacion text,
    CONSTRAINT chk_edad CHECK (((edad >= 0) AND (edad <= 100))),
    CONSTRAINT chk_genero CHECK ((genero = ANY (ARRAY['Genero No Especificado'::text, 'Masculino'::text, 'Femenino'::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (cc, nombre, apellido, edad, peso, estatura, genero, imc, clasificacion) FROM stdin;
\.


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (cc);


--
-- Name: users trigger_ims; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_ims BEFORE INSERT OR UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.f_imc();


--
-- PostgreSQL database dump complete
--

