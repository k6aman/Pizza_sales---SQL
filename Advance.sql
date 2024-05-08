-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT PIZZA_TYPES.CATEGORY, ROUND(SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) / (SELECT ROUND(SUM(order_details.QUANTITY * PIZZAS.PRICE),2) AS TOTAL_REVENUE
FROM ORDER_DETAILS
LEFT JOIN PIZZAS
ON order_details.PIZZA_ID = PIZZAS.PIZZA_ID)*100,2) AS REVENUE
FROM PIZZA_TYPES
LEFT JOIN PIZZAS
ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
LEFT JOIN ORDER_DETAILS
ON PIZZAS.PIZZA_ID = ORDER_DETAILS.PIZZA_ID
GROUP BY PIZZA_TYPES.CATEGORY
ORDER BY REVENUE DESC;

-- Analyze the cumulative revenue generated over time.
SELECT ORDER_DATE, SUM(REVENUE) OVER(ORDER BY ORDER_DATE) AS CUMULATIVE_REVENUE
FROM  
(SELECT ORDERS.ORDER_DATE, SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM ORDER_DETAILS 
LEFT JOIN PIZZAS
ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
LEFT JOIN ORDERS
ON ORDERS.ORDER_ID = ORDER_DETAILS.ORDER_ID
GROUP BY ORDERS.ORDER_DATE) AS SALES;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT NAME, REVENUE 
FROM
(SELECT CATEGORY, NAME, REVENUE,
RANK() OVER(PARTITION BY CATEGORY ORDER BY REVENUE DESC) AS RN
FROM
(SELECT PIZZA_TYPES.CATEGORY, PIZZA_TYPES.NAME, SUM(ORDER_DETAILS.QUANTITY * PIZZAS.PRICE) AS REVENUE
FROM PIZZA_TYPES
LEFT JOIN PIZZAS
ON PIZZA_TYPES.PIZZA_TYPE_ID = PIZZAS.PIZZA_TYPE_ID
LEFT JOIN ORDER_DETAILS
ON ORDER_DETAILS.PIZZA_ID = PIZZAS.PIZZA_ID
GROUP BY PIZZA_TYPES.CATEGORY, PIZZA_TYPES.NAME) AS A) AS B
WHERE RN <=3 ;



