SELECT DISTINCT 
    (SELECT
         COUNT(product_id) 
     FROM    
         PRODUCTS 
     WHERE
         cost < 100) AS products_with_cost_less_100, 
    (SELECT
         COUNT(product_id) 
     FROM
         PRODUCTS
     WHERE
         cost BETWEEN 100 AND 200) AS products_with_cost_between_100_and_200,
    (SELECT
         COUNT(product_id) 
     FROM 
         PRODUCTS 
     WHERE cost > 200) AS products_with_cost_more_200
FROM
    PRODUCTS

