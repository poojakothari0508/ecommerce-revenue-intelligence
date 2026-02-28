--
-- PostgreSQL database dump
--

\restrict xDRW2mw1FAeNg1InjJdwhPsYko325kIAASQNFi8XGQoD7xV7t1t3OGteHiu788Z

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

-- Started on 2026-02-28 17:22:28

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 16389)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id character varying(32) NOT NULL,
    customer_unique_id character varying(32),
    customer_zip_code_prefix character varying(10),
    customer_city character varying(50),
    customer_state character varying(5)
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16457)
-- Name: marketing_campaigns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marketing_campaigns (
    campaign_id character varying(32) NOT NULL,
    channel character varying(32),
    name character varying(50),
    cost numeric(10,2)
);


ALTER TABLE public.marketing_campaigns OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16427)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_id character varying(32) NOT NULL,
    order_item_id integer NOT NULL,
    product_id character varying(32),
    seller_id character varying(32),
    shipping_limit_date timestamp without time zone,
    price numeric(10,2),
    freight_value numeric(10,2)
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16463)
-- Name: order_marketing_attribution; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_marketing_attribution (
    order_id character varying(32) NOT NULL,
    campaign_id character varying(32) NOT NULL
);


ALTER TABLE public.order_marketing_attribution OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16395)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id character varying(32) NOT NULL,
    customer_id character varying(32),
    order_status character varying(20),
    order_purchase_timestamp timestamp without time zone,
    order_approved_at timestamp without time zone,
    order_delivered_carrier_date timestamp without time zone,
    order_delivered_customer_date timestamp without time zone,
    order_estimated_delivery_date timestamp without time zone
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16449)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    order_id character varying(32),
    payment_sequential integer,
    payment_type character varying(20),
    payment_installments integer,
    payment_value numeric(10,2)
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16415)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id character varying(32) NOT NULL,
    product_category_name character varying(50),
    product_name_lenght double precision,
    product_description_lenght double precision,
    product_photos_qty double precision,
    product_weight_g double precision,
    product_length_cm double precision,
    product_height_cm double precision,
    product_width_cm double precision
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16421)
-- Name: sellers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sellers (
    seller_id character varying(32) NOT NULL,
    seller_zip_code_prefix character varying(10),
    seller_city character varying(50),
    seller_state character varying(5)
);


ALTER TABLE public.sellers OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16470)
-- Name: web_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.web_events (
    event_id character varying(32) NOT NULL,
    customer_id character varying(32),
    event_type character varying(20),
    event_timestamp timestamp without time zone,
    device character varying(20),
    session_id character varying(32)
);


ALTER TABLE public.web_events OWNER TO postgres;

--
-- TOC entry 4888 (class 2606 OID 16394)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4898 (class 2606 OID 16462)
-- Name: marketing_campaigns marketing_campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marketing_campaigns
    ADD CONSTRAINT marketing_campaigns_pkey PRIMARY KEY (campaign_id);


--
-- TOC entry 4896 (class 2606 OID 16433)
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_id, order_item_id);


--
-- TOC entry 4900 (class 2606 OID 16469)
-- Name: order_marketing_attribution order_marketing_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_marketing_attribution
    ADD CONSTRAINT order_marketing_attribution_pkey PRIMARY KEY (order_id, campaign_id);


--
-- TOC entry 4890 (class 2606 OID 16400)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4892 (class 2606 OID 16420)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4894 (class 2606 OID 16426)
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (seller_id);


--
-- TOC entry 4902 (class 2606 OID 16475)
-- Name: web_events web_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.web_events
    ADD CONSTRAINT web_events_pkey PRIMARY KEY (event_id);


--
-- TOC entry 4903 (class 2606 OID 16434)
-- Name: order_items fk_orderitems_orders; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_orderitems_orders FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- TOC entry 4904 (class 2606 OID 16439)
-- Name: order_items fk_orderitems_products; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_orderitems_products FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 4905 (class 2606 OID 16444)
-- Name: order_items fk_orderitems_sellers; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT fk_orderitems_sellers FOREIGN KEY (seller_id) REFERENCES public.sellers(seller_id);


--
-- TOC entry 4906 (class 2606 OID 16452)
-- Name: payments fk_payments_orders; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_orders FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


-- Completed on 2026-02-28 17:22:28

--
-- PostgreSQL database dump complete
--

\unrestrict xDRW2mw1FAeNg1InjJdwhPsYko325kIAASQNFi8XGQoD7xV7t1t3OGteHiu788Z

