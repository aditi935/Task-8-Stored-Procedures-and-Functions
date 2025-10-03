-- 📦 Products Database Project SQL Script

-- Create Products Table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2),
    stock INT
);

-- Insert Initial Data
INSERT INTO Products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 75000, 10),
('Desk Chair', 'Furniture', 4500, 25),
('Smartphone', 'Electronics', 60000, 15),
('Bookshelf', 'Furniture', 3500, 8);

-- Stored Procedure: UpdateCategoryPrice
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

-- Example Call
-- CALL UpdateCategoryPrice('Furniture', 10);

-- Function: CalculateDiscount
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

-- Example Select
-- SELECT product_name, price, CalculateDiscount(price) AS Discount FROM Products;

-- Procedure: ShowPriceWithDiscount
DELIMITER $$
CREATE PROCEDURE ShowPriceWithDiscount(IN cat_name VARCHAR(30))
BEGIN
    SELECT product_name, price, CalculateDiscount(price) AS Discount
    FROM Products
    WHERE category = cat_name;
END$$
DELIMITER ;

-- Example Call
-- CALL ShowPriceWithDiscount('Electronics');

-- Trigger: Enforce Minimum Price
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

-- Insert with Trigger Test
INSERT INTO Products (product_name, category, price, stock)
VALUES ('Pen Stand', 'Stationery', 500, 50);

-- Insert More Products
INSERT INTO Products (product_name, category, price, stock)
VALUES ('Notebook', 'Stationery', 1200, 100);

-- Final Snapshot
SELECT * FROM Products;
