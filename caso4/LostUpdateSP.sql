-- Stored procedure to reduce stock by a specified amount

DROP PROCEDURE IF EXISTS reduce_stock;
GO

CREATE PROCEDURE reduce_stock
    @product_id INT,
    @amount INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    -- Get the current stock of the product
    DECLARE @current_stock INT;
    SELECT @current_stock = stock FROM products WHERE product_id = @product_id;
    
    -- Wait for 5 seconds to simulate a delay
    WAITFOR DELAY '00:00:05';

    -- Reduce the stock by the specified amount
    UPDATE products SET stock = @current_stock - @amount WHERE product_id = @product_id;
    
    COMMIT TRANSACTION;
END;
GO

DROP PROCEDURE IF EXISTS check_stock;
GO

CREATE PROCEDURE check_stock
    @product_id INT
AS
BEGIN
    SELECT stock FROM products WHERE product_id = @product_id;
END;
GO

-- To test the lost update issue: 
-- 1. Execute the reduce_stock stored procedure with a product ID and an amount to reduce the stock by. 
-- 2. While the first stored procedure is still running, execute the same stored procedure with the same product ID and a different amount to reduce the stock by. 
-- 3. Wait for both stored procedures to complete. 
-- 4. Execute the check_stock stored procedure with the same product ID to see the final stock value. 
-- If a lost update occurred, the final stock value will be incorrect.

-- Fix the lost update issue by adding an UPDLOCK hint to the SELECT statement that gets the current stock of the product.
-- Stored procedure to reduce stock by a specified amount

DROP PROCEDURE IF EXISTS reduce_stock;
GO

CREATE PROCEDURE reduce_stock
    @product_id INT,
    @amount INT
AS
BEGIN
    BEGIN TRANSACTION;
    
    -- Get the current stock of the product with an UPDLOCK hint to prevent lost updates
    DECLARE @current_stock INT;
    SELECT @current_stock = stock FROM products WITH (UPDLOCK) WHERE product_id = @product_id;
    
    -- Wait for 5 seconds to simulate a delay
    WAITFOR DELAY '00:00:05';

    -- Reduce the stock by the specified amount
    UPDATE products SET stock = @current_stock - @amount WHERE product_id = @product_id;
    
    COMMIT TRANSACTION;
END;
GO