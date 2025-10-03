# 📦 Products Database Project  

This project demonstrates working with **SQL Stored Procedures, Functions, and Triggers** using a `Products` table.  
We’ll create the table, insert data, apply procedures, calculate discounts, enforce rules with triggers, and view the final snapshot.

---

## 🗄️ Database Structure  

### Products Table  
```sql
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2),
    stock INT
);
```

### Initial Data  
```sql
INSERT INTO Products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 75000, 10),
('Desk Chair', 'Furniture', 4500, 25),
('Smartphone', 'Electronics', 60000, 15),
('Bookshelf', 'Furniture', 3500, 8);
```

📊 **Products Table (Initial)**  

| product_id | product_name | category     | price    | stock |
|------------|--------------|--------------|----------|-------|
| 1          | Laptop       | Electronics  | 75000.00 | 10    |
| 2          | Desk Chair   | Furniture    | 4500.00  | 25    |
| 3          | Smartphone   | Electronics  | 60000.00 | 15    |
| 4          | Bookshelf    | Furniture    | 3500.00  | 8     |

---

## 🚀 Stored Procedure: Update Category Price  

```sql
DELIMITER $$
CREATE PROCEDURE UpdateCategoryPrice(IN cat_name VARCHAR(30), IN hike_percent INT)
BEGIN
    UPDATE Products
    SET price = price + (price * hike_percent / 100)
    WHERE category = cat_name;

    SELECT product_name, category, price
    FROM Products
    WHERE category = cat_name;
END$$
DELIMITER ;
```

### Example Call  
```sql
CALL UpdateCategoryPrice('Furniture', 10);
```

📊 **Output**  

| product_name | category  | price   |
|--------------|-----------|---------|
| Desk Chair   | Furniture | 4950.00 |
| Bookshelf    | Furniture | 3850.00 |

✅ This procedure updates prices by a given percentage for all products in a category.

---

## 🧮 Function: Calculate Discount  

```sql
DELIMITER $$
CREATE FUNCTION CalculateDiscount(prodPrice DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE discount DECIMAL(10,2);

    IF prodPrice < 5000 THEN
        SET discount = prodPrice * 0.05;
    ELSEIF prodPrice BETWEEN 5000 AND 70000 THEN
        SET discount = prodPrice * 0.10;
    ELSE
        SET discount = prodPrice * 0.15;
    END IF;

    RETURN discount;
END$$
DELIMITER ;
```

### Example Select  
```sql
SELECT product_name, price, CalculateDiscount(price) AS Discount FROM Products;
```

📊 **Output**  

| product_name | price    | Discount |
|--------------|----------|----------|
| Laptop       | 75000.00 | 11250.00 |
| Desk Chair   | 4950.00  | 247.50   |
| Smartphone   | 60000.00 | 6000.00  |
| Bookshelf    | 3850.00  | 192.50   |

✅ The function calculates discounts dynamically based on price ranges.

---

## 🏆 Procedure: Show Price with Discount  

```sql
DELIMITER $$
CREATE PROCEDURE ShowPriceWithDiscount(IN cat_name VARCHAR(30))
BEGIN
    SELECT product_name, price, CalculateDiscount(price) AS Discount
    FROM Products
    WHERE category = cat_name;
END$$
DELIMITER ;
```

### Example Call  
```sql
CALL ShowPriceWithDiscount('Electronics');
```

📊 **Output**  

| product_name | price    | Discount |
|--------------|----------|----------|
| Laptop       | 75000.00 | 11250.00 |
| Smartphone   | 60000.00 | 6000.00  |

✅ This procedure reuses the function to show both price and discount for a category.

---

## 🛡️ Trigger: Enforce Minimum Price  

```sql
DELIMITER $$
CREATE TRIGGER BeforeInsertProduct
BEFORE INSERT ON Products
FOR EACH ROW
BEGIN
    IF NEW.price < 1000 THEN
        SET NEW.price = 1000;
    END IF;
END$$
DELIMITER ;
```

### Insert Example  
```sql
INSERT INTO Products (product_name, category, price, stock)
VALUES ('Pen Stand', 'Stationery', 500, 50);
```

📊 **Output**  

| product_id | product_name | category   | price   | stock |
|------------|--------------|------------|---------|-------|
| 5          | Pen Stand    | Stationery | 1000.00 | 50    |

✅ The trigger prevents inserting a product with price less than **1000**.

---

## ➕ Adding More Products  

```sql
INSERT INTO Products (product_name, category, price, stock)
VALUES ('Notebook', 'Stationery', 1200, 100);
```

📊 **Output**  

| product_id | product_name | category   | price   | stock |
|------------|--------------|------------|---------|-------|
| 6          | Notebook     | Stationery | 1200.00 | 100   |

---

## 📊 Final Products Table  

```sql
SELECT * FROM Products;
```

📊 **Final Snapshot**  

| product_id | product_name | category     | price    | stock |
|------------|--------------|--------------|----------|-------|
| 1          | Laptop       | Electronics  | 75000.00 | 10    |
| 2          | Desk Chair   | Furniture    | 4950.00  | 25    |
| 3          | Smartphone   | Electronics  | 60000.00 | 15    |
| 4          | Bookshelf    | Furniture    | 3850.00  | 8     |
| 5          | Pen Stand    | Stationery   | 1000.00  | 50    |
| 6          | Notebook     | Stationery   | 1200.00  | 100   |

---

# ✅ Explanation  

- **Products Table** → Stores products with price and stock info.  
- **Stored Procedure (`UpdateCategoryPrice`)** → Bulk updates prices for a category.  
- **Function (`CalculateDiscount`)** → Dynamically calculates discount based on price range.  
- **Procedure (`ShowPriceWithDiscount`)** → Combines discount calculation with category filter.  
- **Trigger (`BeforeInsertProduct`)** → Enforces business rule: no product below ₹1000.  
- **Final Snapshot** → Shows updated data after all operations.  
