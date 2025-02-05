### 1. **gold.dim_customers**
- **Purpose:** Stores Customer details enriched with demographic and geographic data.
- **Columns:**
|Column Name| Data Type | Description
                                        |
|-----------------|------------|----------------|--------------------|
|Customer_key | INT | Surrogate key uniquely indentifying each customer record in the dimension table. |
| customer_id | INT | Unique numerical identifiers assigned to each customer.|
| customer_number | NVARCHAR(50) | Alphanumeric identifier representing the customer, used for tracking and referencing.|
|first_name | NVARCHAR(50) | The customer's first name, as recorded in the system.|
|last_name | NVARCHAR(50) | The customer's lastname or surname.|
| country | NVARCHAR(50) | The country of residence for the customers (e.g. Austraria) |
|marital_status | NVARCHAR(50) | The merital status of the customer (e.g 'Married', 'Single'). |
|gender | NVARCHAR(50) | The gender of the customer (e.g, 'Male' ,'Female,''n/a) |
| birthdate | DATE | The date of birth of the customer, formatted as YYYY-MM-DD)  |
| create_date | DATE | The date and time when the customer record was created in the system |

----
