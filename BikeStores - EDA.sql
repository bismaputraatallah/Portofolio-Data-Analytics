SELECT 
	ord.order_id,
    ord.store_id,
    CONCAT(sc.first_name, ' ', sc.last_name) AS costumer_name,
    CONCAT(stf.first_name, ' ', stf.last_name) AS sales_representative,
    ord.order_date,
    sc.city,
    sc.state,
	prp.product_name,
	pca.category_name,
	pbr.brand_name,
    
    SUM(oit.quantity) AS quantity,
CAST(SUM(oit.quantity * oit.list_price) AS DECIMAL(18,2)) AS gross_revenue_per_customers,
CAST(SUM(oit.quantity * oit.list_price * (1 - oit.discount)) AS DECIMAL(18,2)) AS revenue_per_customers
    
FROM orders ord
JOIN sales_costumers sc
ON ord.order_id = sc.id
JOIN order_items oit
ON ord.order_id = oit.order_id
JOIN production_products prp
ON oit.product_id = prp.product_id
JOIN production_categories pca
ON prp.category_id = pca.category_id
JOIN production_brands pbr
ON prp.brand_id = pbr.brand_id
JOIN staffs stf
ON ord.staff_id = stf.staff_id

GROUP BY 			ord.order_id,
    ord.store_id,
    CONCAT(sc.first_name, ' ', sc.last_name),
    CONCAT(stf.first_name, ' ', stf.last_name),
    order_date,
    sc.city,
    sc.state,
	prp.product_name,
	pca.category_name,
	pbr.brand_name;