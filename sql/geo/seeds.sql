-------------------- A View to Obtain Surrogate Keys from the Date Dimension --------------------

CREATE VIEW date_skeys AS
(
SELECT MIN(sk_date) sk_date, date, MAX(TO_DATE(datetime)) datetime
FROM dim_date
GROUP BY date
ORDER BY 1);


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


-------------------- Dimension Product --------------------


CREATE TABLE dim_product AS
SELECT DISTINCT ma.material             AS product_serial_number
              , ma.mfg_part_number      AS mfg_part_number
              , ma.material_description AS product_description
              , ma.material_group_id
              , ma.material_level_3
              , ma.material_level_2
              , ma.purchasing_org_id
              , mp.item_weight_mg       AS item_weight
              , mp.height_mm            AS item_hight
              , mp.part_type
              , date.sk_date            AS sk_date_part_intro_date
              , date_of_intro
              , mp.life_cycle_stage
              , mph.unit_of_measure
              , mp.functional_equivalent_alternates
              , mp.imported_mfr
              , mp.internal_pn
              , mp.generic
              , mp.avg_price
              , mp.fff_alternates
              , mp.conflict_mineral
              , mp.drc_declaration_level
              , mp.drc_status_source
              , mp.imported_description
              , mp.cage_code
              , mp.screening_levelreference_std
              , mp.alternates_active_mfrs
              , mp.conflict_mineral_source
              , mp.risk_environmental
              , mp.risk_supply_chain
              , mp.mfr_suggested_replacements
              , mp.active_mfrs
              , mp.drc_due_diligence_description
              , mp.matched_mfr_id
              , mp.availability_yteol
              , mp.drc_status
              , mp.part_status
              , mp.life_cycle_info_source
              , mp.part_category
              , mp.yteol
              , mp.peak_package_temperature_deg_c
              , mp.predicted_status_2_years
              , mp.imported_mfr_pn
              , mp.risk_lifecycle
              , mp.manufacturer_support_status
              , mp.ceyteol
              , mp.predicted_status_8_years
              , mp.drc_due_diligence_level
              , mp.hts_code
              , mp.total_inventory
              , mp.status_of_mfr_sources
              , mp.life_cycle_code
              , mp.drc_cf_declaration
              , mp.conflict_minerals_statement
FROM customer_data.molex.materials ma
         INNER JOIN customer_data.molex.material_sources ms
                    ON ma.material = ms.material
         INNER JOIN customer_data.molex.material_purchase_history mph
                    ON mph.material = ms.material
         LEFT JOIN "EXTERNAL_ELECTRICAL_COMPONENT_DATA"."IHS"."MOLEX_PARTS" mp
                   ON ma.material = mp.internal_pn
                       AND (mp.matched_pn = ma.mfg_part_number
                           OR ma.mfg_part_number = mp.imported_mfr_pn)
         LEFT JOIN apollo.public.date_skeys date
                   ON mp.date_of_intro = date.date
ORDER BY 1;

