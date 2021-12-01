-------------------- Dimension Vendor --------------------

DROP TABLE dim_vendor;

CREATE TABLE dim_vendor
(
    sk_vendor_id                 NUMBER(10)
        CONSTRAINT dim_vendor_pk
            PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    name                         VARCHAR(255),
    plant_name                   VARCHAR(255),
    vendor_code                  VARCHAR(255),
    vendor_incoterms             VARCHAR(255),
    vendor_incoterms_description VARCHAR(255),
    vendor_payment_term          VARCHAR(255),
    vendor_city                  VARCHAR(255),
    vendor_state                 VARCHAR(255),
    vendor_zip_code              VARCHAR(255),
    vendor_country               VARCHAR(255),
    is_distributor               VARCHAR(255)
);


INSERT INTO dim_vendor ( name
                       , plant_name
                       , vendor_code
                       , vendor_incoterms
                       , vendor_incoterms_description
                       , vendor_payment_term
                       , vendor_city
                       , vendor_state
                       , vendor_zip_code
                       , vendor_country
                       , is_distributor)
SELECT DISTINCT UPPER(ma.vendor_name) AS name
              , ma.plant_name
              , ma.vendor_code
              , ma.vendor_incoterms
              , ma.vendor_incoterms_description
              , ma.vendor_payment_t
              , mph.vendor_city
              , NULL                     vendor_state
              , mph.vendor_zip_code
              , mph.vendor_country
              , NULL                  AS is_distributor
FROM customer_data.molex.materials ma
         INNER JOIN customer_data.molex.material_sources ms
                    ON UPPER(ma.vendor_name) = UPPER(ms.vendor_name)
         INNER JOIN customer_data.molex.material_purchase_history mph
                    ON UPPER(ma.vendor_name) = UPPER(mph.vendor_name)
                        AND ma.material = mph.material
ORDER BY 1;

