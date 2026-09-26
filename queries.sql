-- Cohort Retention Analysis on Brazilian E-Commerce

-- Q1. Delivered Orders
-- Restrict analysis to delivered orders

WITH delivered_orders AS (
    SELECT
        o.order_id,
        o.customer_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)

SELECT *
FROM delivered_orders;


-- ============================================================
-- Q2. Cohort Assignment
-- First purchase month for each real customer
-- customer_unique_id is used because customer_id is order-level
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_first_purchase AS (
    SELECT
        customer_unique_id,
        MIN(order_purchase_timestamp) OVER (
            PARTITION BY customer_unique_id
        ) AS first_purchase_timestamp
    FROM delivered_orders
)

SELECT DISTINCT
    customer_unique_id,
    strftime(
        '%Y-%m',
        first_purchase_timestamp
    ) AS cohort_month
FROM customer_first_purchase
ORDER BY cohort_month, customer_unique_id;


-- ============================================================
-- Q3. Customer Activity
-- One row per customer per order
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)

SELECT
    customer_unique_id,
    order_id,
    strftime(
        '%Y-%m',
        order_purchase_timestamp
    ) AS order_month
FROM delivered_orders
ORDER BY customer_unique_id, order_month;


-- ============================================================
-- Q4. Period Index
-- Months elapsed between order month and cohort month
-- Period 0 = customer's cohort month
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
),

customer_activity AS (
    SELECT
        customer_unique_id,
        order_id,
        strftime(
            '%Y-%m',
            order_purchase_timestamp
        ) AS order_month
    FROM delivered_orders
)

SELECT
    a.customer_unique_id,
    a.order_id,
    c.cohort_month,
    a.order_month,

    (
        (
            CAST(substr(a.order_month, 1, 4) AS INTEGER)
            - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)
        ) * 12
        +
        (
            CAST(substr(a.order_month, 6, 2) AS INTEGER)
            - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)
        )
    ) AS period_number

FROM customer_activity AS a
JOIN customer_cohorts AS c
    ON a.customer_unique_id = c.customer_unique_id

ORDER BY
    c.cohort_month,
    a.customer_unique_id,
    a.order_month;


-- ============================================================
-- Q5. Retention Matrix
-- Cohort x Period -> Active customer count
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
),

customer_activity AS (
    SELECT
        customer_unique_id,
        order_id,
        strftime(
            '%Y-%m',
            order_purchase_timestamp
        ) AS order_month
    FROM delivered_orders
),

activity_with_period AS (
    SELECT
        a.customer_unique_id,
        c.cohort_month,

        (
            (
                CAST(substr(a.order_month, 1, 4) AS INTEGER)
                - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            (
                CAST(substr(a.order_month, 6, 2) AS INTEGER)
                - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)
            )
        ) AS period_number

    FROM customer_activity AS a
    JOIN customer_cohorts AS c
        ON a.customer_unique_id = c.customer_unique_id
)

SELECT
    cohort_month,

    COUNT(DISTINCT CASE
        WHEN period_number = 0
        THEN customer_unique_id
    END) AS period_0,

    COUNT(DISTINCT CASE
        WHEN period_number = 1
        THEN customer_unique_id
    END) AS period_1,

    COUNT(DISTINCT CASE
        WHEN period_number = 2
        THEN customer_unique_id
    END) AS period_2,

    COUNT(DISTINCT CASE
        WHEN period_number = 3
        THEN customer_unique_id
    END) AS period_3,

    COUNT(DISTINCT CASE
        WHEN period_number = 4
        THEN customer_unique_id
    END) AS period_4,

    COUNT(DISTINCT CASE
        WHEN period_number = 5
        THEN customer_unique_id
    END) AS period_5,

    COUNT(DISTINCT CASE
        WHEN period_number = 6
        THEN customer_unique_id
    END) AS period_6,

    COUNT(DISTINCT CASE
        WHEN period_number = 7
        THEN customer_unique_id
    END) AS period_7,

    COUNT(DISTINCT CASE
        WHEN period_number = 8
        THEN customer_unique_id
    END) AS period_8,

    COUNT(DISTINCT CASE
        WHEN period_number = 9
        THEN customer_unique_id
    END) AS period_9,

    COUNT(DISTINCT CASE
        WHEN period_number = 10
        THEN customer_unique_id
    END) AS period_10,

    COUNT(DISTINCT CASE
        WHEN period_number = 11
        THEN customer_unique_id
    END) AS period_11,

    COUNT(DISTINCT CASE
        WHEN period_number = 12
        THEN customer_unique_id
    END) AS period_12,

    COUNT(DISTINCT CASE
        WHEN period_number = 13
        THEN customer_unique_id
    END) AS period_13,

    COUNT(DISTINCT CASE
        WHEN period_number = 14
        THEN customer_unique_id
    END) AS period_14,

    COUNT(DISTINCT CASE
        WHEN period_number = 15
        THEN customer_unique_id
    END) AS period_15,

    COUNT(DISTINCT CASE
        WHEN period_number = 16
        THEN customer_unique_id
    END) AS period_16,

    COUNT(DISTINCT CASE
        WHEN period_number = 17
        THEN customer_unique_id
    END) AS period_17,

    COUNT(DISTINCT CASE
        WHEN period_number = 18
        THEN customer_unique_id
    END) AS period_18,

    COUNT(DISTINCT CASE
        WHEN period_number = 19
        THEN customer_unique_id
    END) AS period_19,

    COUNT(DISTINCT CASE
        WHEN period_number = 20
        THEN customer_unique_id
    END) AS period_20,

    COUNT(DISTINCT CASE
        WHEN period_number = 21
        THEN customer_unique_id
    END) AS period_21,

    COUNT(DISTINCT CASE
        WHEN period_number = 22
        THEN customer_unique_id
    END) AS period_22

FROM activity_with_period

GROUP BY cohort_month
ORDER BY cohort_month;


-- ============================================================
-- Q6. Cohort Sizes
-- Period 0 is the cohort size
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
)

SELECT
    cohort_month,
    COUNT(*) AS cohort_size
FROM customer_cohorts
GROUP BY cohort_month
ORDER BY cohort_month;


-- ============================================================
-- Q7. Retention Rate Matrix
-- Active customers / cohort size * 100
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
),

customer_activity AS (
    SELECT
        customer_unique_id,
        strftime(
            '%Y-%m',
            order_purchase_timestamp
        ) AS order_month
    FROM delivered_orders
),

activity_with_period AS (
    SELECT
        a.customer_unique_id,
        c.cohort_month,

        (
            (
                CAST(substr(a.order_month, 1, 4) AS INTEGER)
                - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            (
                CAST(substr(a.order_month, 6, 2) AS INTEGER)
                - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)
            )
        ) AS period_number

    FROM customer_activity AS a
    JOIN customer_cohorts AS c
        ON a.customer_unique_id = c.customer_unique_id
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_size
    FROM activity_with_period
    WHERE period_number = 0
    GROUP BY cohort_month
)

SELECT
    a.cohort_month,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 0 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_0,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 1 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_1,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 2 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_2,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 3 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_3,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 4 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_4,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 5 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_5,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 6 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_6,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 7 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_7,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 8 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_8,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 9 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_9,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 10 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_10,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 11 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_11,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 12 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_12,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 13 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_13,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 14 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_14,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 15 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_15,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 16 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_16,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 17 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_17,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 18 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_18,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 19 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_19,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 20 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_20,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 21 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_21,

    ROUND(
        100.0 *
        COUNT(DISTINCT CASE WHEN period_number = 22 THEN customer_unique_id END)
        / s.cohort_size,
        2
    ) AS period_22

FROM activity_with_period AS a
JOIN cohort_sizes AS s
    ON a.cohort_month = s.cohort_month

GROUP BY
    a.cohort_month,
    s.cohort_size

ORDER BY a.cohort_month;


-- ============================================================
-- Q8. Average Retention Rate per Period
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
),

customer_activity AS (
    SELECT
        customer_unique_id,
        strftime(
            '%Y-%m',
            order_purchase_timestamp
        ) AS order_month
    FROM delivered_orders
),

activity_with_period AS (
    SELECT
        a.customer_unique_id,
        c.cohort_month,

        (
            (
                CAST(substr(a.order_month, 1, 4) AS INTEGER)
                - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            (
                CAST(substr(a.order_month, 6, 2) AS INTEGER)
                - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)
            )
        ) AS period_number

    FROM customer_activity AS a
    JOIN customer_cohorts AS c
        ON a.customer_unique_id = c.customer_unique_id
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_size
    FROM activity_with_period
    WHERE period_number = 0
    GROUP BY cohort_month
),

retention_by_cohort AS (
    SELECT
        a.cohort_month,
        a.period_number,
        COUNT(DISTINCT a.customer_unique_id) * 1.0
        / s.cohort_size AS retention_rate

    FROM activity_with_period AS a
    JOIN cohort_sizes AS s
        ON a.cohort_month = s.cohort_month

    GROUP BY
        a.cohort_month,
        a.period_number,
        s.cohort_size
)

SELECT
    period_number,
    ROUND(
        AVG(retention_rate) * 100,
        2
    ) AS average_retention_rate

FROM retention_by_cohort

GROUP BY period_number
ORDER BY period_number;


-- ============================================================
-- Q9. Best and Worst Cohorts by Month-1 Retention
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
),

customer_activity AS (
    SELECT
        customer_unique_id,
        strftime(
            '%Y-%m',
            order_purchase_timestamp
        ) AS order_month
    FROM delivered_orders
),

activity_with_period AS (
    SELECT
        a.customer_unique_id,
        c.cohort_month,

        (
            (
                CAST(substr(a.order_month, 1, 4) AS INTEGER)
                - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            (
                CAST(substr(a.order_month, 6, 2) AS INTEGER)
                - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)
            )
        ) AS period_number

    FROM customer_activity AS a
    JOIN customer_cohorts AS c
        ON a.customer_unique_id = c.customer_unique_id
),

cohort_sizes AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT customer_unique_id) AS cohort_size
    FROM activity_with_period
    WHERE period_number = 0
    GROUP BY cohort_month
),

period_1_retention AS (
    SELECT
        a.cohort_month,
        COUNT(DISTINCT a.customer_unique_id) * 1.0
        / s.cohort_size AS retention_rate

    FROM activity_with_period AS a
    JOIN cohort_sizes AS s
        ON a.cohort_month = s.cohort_month

    WHERE a.period_number = 1

    GROUP BY
        a.cohort_month,
        s.cohort_size
)

SELECT
    cohort_month,
    ROUND(retention_rate * 100, 2) AS period_1_retention
FROM period_1_retention
ORDER BY period_1_retention DESC;


-- ============================================================
-- Q10. Revenue per Cohort and Period
-- Revenue = product price + freight value
-- ============================================================

WITH delivered_orders AS (
    SELECT
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp
    FROM orders AS o
    JOIN customers AS c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),

customer_cohorts AS (
    SELECT DISTINCT
        customer_unique_id,
        strftime(
            '%Y-%m',
            MIN(order_purchase_timestamp) OVER (
                PARTITION BY customer_unique_id
            )
        ) AS cohort_month
    FROM delivered_orders
),

order_periods AS (
    SELECT
        d.order_id,
        d.customer_unique_id,
        c.cohort_month,

        (
            (
                CAST(strftime(
                    '%Y',
                    d.order_purchase_timestamp
                ) AS INTEGER)
                - CAST(substr(c.cohort_month, 1, 4) AS INTEGER)
            ) * 12
            +
            (
                CAST(strftime(
                    '%m',
                    d.order_purchase_timestamp
                ) AS INTEGER)
                - CAST(substr(c.cohort_month, 6, 2) AS INTEGER)
            )
        ) AS period_number

    FROM delivered_orders AS d
    JOIN customer_cohorts AS c
        ON d.customer_unique_id = c.customer_unique_id
)

SELECT
    op.cohort_month,
    op.period_number,
    ROUND(
        SUM(oi.price + oi.freight_value),
        2
    ) AS revenue

FROM order_periods AS op
JOIN order_items AS oi
    ON op.order_id = oi.order_id

GROUP BY
    op.cohort_month,
    op.period_number

ORDER BY
    op.cohort_month,
    op.period_number;