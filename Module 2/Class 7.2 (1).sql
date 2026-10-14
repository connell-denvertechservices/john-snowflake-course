-- Activity Part 1
select rfm_segment,
    count(c_custkey)
from customer_rfm
group by rfm_segment
order by rfm_segment;


-- Activity Part 2: RFM Analysis with CASE and CTEs
select c_custkey,
    rfm_segment,
    case
        when rfm_segment > 255 then 'Low Risk'
        when rfm_segment <= 255 then 'High Risk'
    end as churn_risk
from customer_rfm
order by rfm_segment
limit 10;

with cte as (
    select c_custkey,
        rfm_segment,
        case
            when rfm_segment > 255 then 'Low Risk'
            when rfm_segment <= 255 then 'High Risk'
        end as churn_risk
    from customer_rfm
)
select churn_risk,
    count(c_custkey)
from cte
group by churn_risk;


-- Activity Part 1: SQL Challenge
select *
from customer_rfm sample (1);

select c_custkey,
    rfm_segment,
    case
        when rfm_segment between 100 and 199 then 'Segment 1'
        when rfm_segment between 200 and 299 then 'Segment 2'
        when rfm_segment between 300 and 399 then 'Segment 3'
        when rfm_segment between 400 and 499 then 'Segment 4'
        when rfm_segment between 500 and 599 then 'Segment 5'
        else 'Other'
    end as condensed_segment
from customer_rfm sample (1);

select c_custkey,
    rfm_segment,
    case
        when rfm_segment in (111, 125, 123) then 'Segment 1'
        when rfm_segment between 200 and 299 then 'Segment 2'
        when rfm_segment between 300 and 399 then 'Segment 3'
        when rfm_segment between 400 and 499 then 'Segment 4'
        when rfm_segment between 500 and 599 then 'Segment 5'
        else 'Other'
    end as condensed_segment
from customer_rfm sample (1);
