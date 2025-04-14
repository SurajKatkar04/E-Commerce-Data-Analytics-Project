USE project3;
-------------------------------------------------------------------------------------------------------------
#1. KPI 
#Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics

SELECT 
CASE when dayofweek(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) IN (1,7) 
THEN 'Weekend' else 'weekday' end as daytype,
count(distinct o.order_id) as TotalOrders,
round(sum(p.payment_value)) as TotalPayments,
round(avg(p.payment_value)) as AveragePayment
From	
olist_orders_dataset o
left join	
olist_order_payments_dataset p on o.order_id = p.order_id
group by
daytype;

----------------------------------------------------------------------------------------------------------------
#2.KPI
#Number of Orders with review score 5 and payment type as credit card.

select
count(Distinct p.order_id) as TotalOrders
from
olist_order_payments_dataset p
left join
olist_order_reviews_dataset r
on p.order_id = r.order_id
where
r.review_score = 5
and p.payment_type = 'credit_card';

-------------------------------------------------------------------------------------------------------------------

#3.KPI
#Average number of days taken for order_delivered_customer_date for pet_shop

SELECT 
i.product_category_name,
round(avg(datediff(o.order_delivered_customer_date, o.order_purchase_timestamp)), 0) as Avg_delivery_days
from olist_orders_dataset o
inner join ( SELECT product_id, order_id, product_category_name
 from olist_products_dataset
inner join olist_order_items_dataset using (product_id)) as i
on o.order_id = i.order_id
where i.product_category_name= 'pet_shop'
and o.order_delivered_customer_date is not null
and o.order_purchase_timestamp is not null	
group by i.product_category_name;

------------------------------------------------------------------------------------------------------
#4.KPI
#Average price and payment values from customers of sao paulo city

select
customer_city,
round(AVG(i.Price)) as average_price,
round(AVG(p.payment_value)) as average_payment
from olist_customers_dataset c
left join
olist_orders_dataset o on c.customer_id = o.customer_id
left join 
olist_order_items_dataset i on o.order_id = i.order_id
left join
olist_order_payments_dataset p on o.order_id = p.order_id
where c.customer_city = "sao paulo";

----------------------------------------------------------------------------------------------------------------
#5.KPI
#Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores.

SELECT ShippingDaysRange, round(AVG(review_score),1) AS AvgReview
FROM (SELECT CASE
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'), 
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 0 AND 10 THEN '0-10'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'), 
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 11 AND 20 THEN '11-20'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'), 
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 21 AND 30 THEN '21-30'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'), 
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 31 AND 40 THEN '31-40'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'), 
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 41 AND 50 THEN '41-50'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'), 
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 51 AND 100 THEN '51-100'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'),
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 101 AND 150 THEN '101-150'
WHEN DATEDIFF(STR_TO_DATE(o.order_delivered_customer_date, '%Y-%m-%d'),
STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d')) BETWEEN 151 AND 200 THEN '151-200'
ELSE 'Above 200'
END AS ShippingDaysRange, review_score
FROM olist_orders_dataset o
LEFT JOIN olist_order_reviews_dataset r 
ON o.order_id = r.order_id
WHERE o.order_delivered_customer_date IS NOT NULL
AND o.order_purchase_timestamp IS NOT NULL
) AS Subquery
GROUP BY ShippingDaysRange
ORDER BY AvgReview desc;

