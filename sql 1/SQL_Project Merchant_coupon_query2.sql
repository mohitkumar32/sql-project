create database merchant_coupon;
use merchant_coupon;

-----   Q1.  Identify the most effective marketing campaigns: Analyze the data to determine which 
-----       marketing campaigns were the most effective in terms of driving sales, customer 
-----       engagement, and customer loyalty.
 SELECT c.campaign_type, 
 COUNT(t.redemption_status) AS total_redemptions, 
 SUM(ctd.selling_price * ctd.quantity) AS total_sales,
 COUNT(DISTINCT t.customer_id) AS unique_customers
FROM train t
JOIN campaign_data c ON t.campaign_id = c.campaign_id
JOIN customer_transaction_data ctd ON t.customer_id = ctd.customer_id
WHERE t.redemption_status = 1
GROUP BY c.campaign_type
ORDER BY total_sales DESC;


----- Q2. Segment customers based on behavior: Segment customers into different groups based on 
----- their behavior and preferences, such as high spenders, frequent shoppers, and dormant 
----- customers. This will help to tailor marketing strategies and promotions to different customer groups

SELECT customer_id, 
 SUM(selling_price * quantity) AS total_spent, 
 COUNT(DISTINCT date) AS shopping_days,
 COUNT(*) AS total_transactions
FROM customer_transaction_data
GROUP BY customer_id;


----- Q3. Optimize the coupon distribution strategy: Analyze the data to determine the most effective 
----- way to distribute coupons, such as through email, direct mail, or in-store promotions.

 SELECT 
  cd.campaign_type,
  COUNT(CASE WHEN t.redemption_status = 1 THEN 1 END) AS redeemed,
  COUNT(*) AS total,
  COUNT(CASE WHEN t.redemption_status = 1 THEN 1 END) * 1.0 / COUNT(*) AS redemption_rate
FROM train t
INNER JOIN campaign_data cd ON t.campaign_id = cd.campaign_id
GROUP BY cd.campaign_type
ORDER BY redemption_rate DESC;


----- Q4. Improve customer engagement: Analyze the data to identify opportunities to improve 
----- customer engagement, such as by offering personalized recommendations, providing 
----- product information, or enhancing the overall customer experience.

 SELECT cd.age_range, cd.income_bracket, 
 i.category, 
 SUM(ctd.quantity) AS total_quantity
FROM customer_transaction_data ctd
JOIN customer_demographics cd ON ctd.customer_id = cd.customer_id
JOIN item_data i ON ctd.item_id = i.item_id
GROUP BY cd.age_range, cd.income_bracket, i.category
ORDER BY total_quantity DESC;


----- Q5. Evaluate the impact of product mix on sales: Analyze the data to determine the impact of 
----- product mix on sales, such as the popularity of different product categories, the impact of 
----- product promotions, and the effectiveness of cross-selling strategies

SELECT i.category, 
 SUM(ctd.selling_price * ctd.quantity) AS total_sales,
 SUM(ctd.coupon_discount) AS total_coupon_discount,
 SUM(ctd.other_discount) AS total_other_discount
FROM customer_transaction_data ctd
JOIN item_data i ON ctd.item_id = i.item_id
GROUP BY i.category
ORDER BY total_sales DESC;


----- Q6. Analyze customer demographics: Analyze the data to understand the demographics of 
----- customers, such as age, gender, income, and location, and develop targeted marketing 
----- campaigns to reach specific customer segments.

 SELECT age_range, 
 COUNT(customer_id) AS total_customers,
 AVG(income_bracket) AS average_income,
 COUNT(CASE WHEN marital_status = 'Married' THEN 1 END) AS married_customers,
 COUNT(CASE WHEN rented = 1 THEN 1 END) AS renting_customers,
 AVG(family_size) AS average_family_size,
 AVG(no_of_children) AS average_children
FROM customer_demographics
GROUP BY age_range;


----- Q7. Monitor customer feedback: Regularly monitor customer feedback to identify areas where 
----- the business can improve and address customer concerns in a timely manner.

-- Derive the number of coupons distributed per campaign
WITH campaign_coupons AS (
  SELECT campaign_id, COUNT(*) AS coupon_count
  FROM train
  GROUP BY campaign_id
)

SELECT 
  cd.campaign_type,
  cc.campaign_id,
  COUNT(DISTINCT ct.customer_id) AS used_coupons
FROM campaign_data cd
INNER JOIN campaign_data cc ON cd.campaign_id = cc.campaign_id
LEFT JOIN train ct ON cd.campaign_id = ct.campaign_id
GROUP BY 
  cd.campaign_type,
  cc.campaign_id



----- Q8. Explore new marketing channels: Analyze the data to identify new marketing channels that 
----- have the potential to drive growth, such as social media, influencer marketing, or referral 
----- marketing.

SELECT 
  i.category,
  COUNT(*) AS total_returns
FROM customer_transaction_data ctd
INNER JOIN item_data i ON ctd.item_id = i.item_id
WHERE ctd.quantity < 0 -- Assuming negative quantity indicates return
GROUP BY i.category
ORDER BY total_returns DESC;


----- Q9. Measure the ROI of marketing campaigns: Regularly measure the return on investment (ROI) 
----- of marketing campaigns to determine their effectiveness and allocate resources accordingly.

SELECT 
  cd.campaign_type,
  COUNT(*) AS total_coupons,
  COUNT(DISTINCT ct.customer_id) AS used_coupons
FROM campaign_data cd
LEFT JOIN train ct ON cd.campaign_id = ct.campaign_id
GROUP BY 
  cd.campaign_type
 



----- Q10. Continuously monitor and analyze the data: Continuously monitor and analyze the data to 
----- identify new insights and opportunities to drive growth, and adjust the marketing strategy as 
----- needed to achieve the 100% growth goal.

SELECT 
  cd.age_range,
  cd.marital_status,
  cd.rented,
  cd.family_size,
  cd.no_of_children,
  cd.income_bracket,
  COUNT(*) AS customer_count
FROM customer_demographics cd
INNER JOIN train ct ON cd.customer_id = ct.customer_id  -- Corrected join condition
GROUP BY 
  cd.age_range,
  cd.marital_status,
  cd.rented,
  cd.family_size,
  cd.no_of_children,
  cd.income_bracket
ORDER BY customer_count DESC;





