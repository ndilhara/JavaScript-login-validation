--CT2019_XXX

CREATE SYNONYM LOC_DETAILS
FOR hr.locations;

CREATE SYNONYM COUNTRY_DETAILS
FOR hr.countries;

CREATE SYNONYM DEPT_DETAILS
FOR hr.departments;

VARIABLE VAR_ROW_COUNT NUMBER;

CREATE TABLE DEPT_POSTAL_ADDRESS
( Dept_ID number(10) NOT NULL,
  Address varchar2(200) NOT NULL,
  CONSTRAINT DEPT_POSTAL_ADDRESS_pk PRIMARY KEY (Dept_ID)
);


--VARIABLE VAR_ROW_COUNT NUMBER;
CREATE OR REPLACE PROCEDURE PROC_POSTAL_ADDRESS(rownu OUT NUMBER) AS
   
   l_id DEPT_DETAILS.DEPARTMENT_ID%type; 
   d_id DEPT_DETAILS.LOCATION_ID%type; 
   --address hr.DEPT_POSTAL_ADDRESS%type;
   s_address LOC_DETAILS.STREET_ADDRESS%type; 
   city LOC_DETAILS.CITY%type;
   st_province LOC_DETAILS.STATE_PROVINCE%type;
   c_id LOC_DETAILS.COUNTRY_ID%type;
   c_name COUNTRY_DETAILS.COUNTRY_NAME%type;
   CURSOR dept_detailsc is 
      SELECT DEPARTMENT_ID, LOCATION_ID FROM DEPT_DETAILS; 
	  
BEGIN 

   OPEN dept_detailsc; 
   LOOP 
   FETCH dept_detailsc into d_id, l_id; 
      EXIT WHEN dept_detailsc%notfound; 
	  SELECT STREET_ADDRESS, CITY, STATE_PROVINCE, COUNTRY_ID INTO s_address, city, st_province, c_id
	  FROM LOC_DETAILS
	  WHERE LOCATION_ID = l_id; 
	  
	  SELECT COUNTRY_NAME INTO c_name
	  FROM COUNTRY_DETAILS
	  WHERE COUNTRY_ID = c_id; 
	  
	  INSERT INTO DEPT_POSTAL_ADDRESS (Dept_ID,Address) 
	  VALUES (d_id, s_address || ', ' || city || ', ' || st_province || ', ' || c_name);  
	 --address == (d_id || ' ' || l_id || ' ' || s_address || ' ' || city || ' ' || st_province || ' ' || c_name);
      --dbms_output.put_line(s_address || ', ' || city || ', ' || st_province || ', ' || c_name); 
	  --dbms_output.put_line(dept_detailsc%rowcount); 
	  
   END LOOP; 
   COMMIT;
   dbms_output.put_line(dept_detailsc%rowcount); 
   	rownu:=dept_detailsc%rowcount;

   --ROW_COUNT:=dept_detailsc%rowcount;
   CLOSE dept_detailsc; 
   
   
END; 
/

























/*
CT/2017/059
S.N.D Senevirathne
*/


 /*
 1) Create three tables for Product, Warehouse and Inventory as listed above. Identify the suitable
data types for the fields by considering the data values provided. Set PRIMARY KEYs and FOREIGN
KEYs appropriately. */

CREATE TABLE Product(
product_id VARCHAR2(8)NOT NULL,
Product_name VARCHAR2(20) NOT NULL,
Warranty_period NUMBER(3,1) NOT NULL,
Supplier_code VARCHAR2(10),
List_price NUMBER(8,2) NOT NULL,
CONSTRAINT pk_Product PRIMARY KEY (product_id)
);

CREATE TABLE Warehouse(
Warehouse_id VARCHAR2(8)NOT NULL ,
Warehouse_name VARCHAR2(20) NOT NULL,
Location Varchar2(20) NOT NULL,
CONSTRAINT pk_warehouse PRIMARY KEY(Warehouse_id)
);
CREATE TABLE Inventory(
product_id VARCHAR2(8),
Warehouse_id VARCHAR2(8),
Qty_on_hand DECIMAL NOT NULL,
CONSTRAINT pk_inventory PRIMARY KEY(product_id,Warehouse_id),
CONSTRAINT fk_inventory_product FOREIGN KEY(product_id) REFERENCES Product(product_id),
CONSTRAINT fk_inventory_warehouse FOREIGN KEY(Warehouse_id) REFERENCES Warehouse(Warehouse_id)
);


/*
2) Insert the provided values into these three tables.
Note: Insert the product names in the same case pattern as given.
*/


INSERT INTO Product VALUES ('PRD01','Air cooler',5,'SW_00101',25990.00);
INSERT INTO Product VALUES ('PRD02','Ceiling fan',2,'IN_20034',6690.00);
INSERT INTO Product VALUES ('PRD03','Dry iron',0.5,'IN_20034',2750.00);
INSERT INTO Product VALUES ('PRD04','Floor polisher',1,NULL,15690.00);
INSERT INTO Product VALUES ('PRD05','Stand fan',0.5,'SG_34023',18590.00);
INSERT INTO Product VALUES ('PRD06','Steam iron',0.5,NULL,2190.00);
INSERT INTO Product VALUES ('PRD07','Vacuum cleaner',1.5,'SG_34023',9990.00);
INSERT INTO Product VALUES ('PRD08','Water heater',2,'TW_90846',18890.00);
INSERT INTO Product VALUES ('PRD09','Water purifier',2,'US_56798',11850.00);

INSERT INTO warehouse VALUES ('ST001','Shop Warehouse','Colombo');
INSERT INTO warehouse VALUES ('ST002','Large Zone','Rathmalana');
INSERT INTO warehouse VALUES ('ST003','Retail Zone','Kiribathgoda');
INSERT INTO warehouse VALUES ('ST004','Whole Supply','Colombo');


INSERT INTO inventory VALUES ('PRD01','ST001',30);
INSERT INTO inventory VALUES ('PRD02','ST001',45);
INSERT INTO inventory VALUES ('PRD02','ST002',20);
INSERT INTO inventory VALUES ('PRD02','ST003',10);
INSERT INTO inventory VALUES ('PRD03','ST002',50);
INSERT INTO inventory VALUES ('PRD03','ST004',50);
INSERT INTO inventory VALUES ('PRD06','ST002',75);
INSERT INTO inventory VALUES ('PRD07','ST001',15);
INSERT INTO inventory VALUES ('PRD07','ST003',10);



SELECT * FROM Inventory;
SELECT * FROM Warehouse;
SELECT *FROM Product;




-- 3) Create a PL/SQL package which includes following subprograms

-- CREATE OR REPLACE PACKAGE pkg_trade_processing IS

CREATE OR REPLACE PACKAGE pkg_trade_processing IS

-- c. Procedure to compute total profit without discounts:

    G_total_profit_no_discount NUMBER(10,2):=0;
    G_total_profit_with_discount NUMBER(10,2):=0;
    G_discount_percentage NUMBER(10,2):=0;

    PROCEDURE get_warehouseName(ware_houseId IN warehouse.Warehouse_id%TYPE, ware_houseName OUT warehouse.Warehouse_name%TYPE);
    FUNCTION get_discountPrice (productID product.product_id%TYPE)RETURN NUMBER;

    PROCEDURE get_profit;
    PROCEDURE get_profit(discount IN NUMBER,productId IN product.product_id%TYPE, product_discountPrice OUT NUMBER,totalDiscount OUT NUMBER, totalProfit OUT Number);


    PROCEDURE get_profit_with_discount(discount IN NUMBER);

END pkg_trade_processing;

/



CREATE OR REPLACE PACKAGE BODY pkg_trade_processing IS

    -- a. Procedure to get the warehouse name:

    PROCEDURE get_warehouseName(ware_houseId IN warehouse.Warehouse_id%TYPE,ware_houseName OUT warehouse.Warehouse_name%TYPE) IS
        temporary_wareHouse_Name warehouse.Warehouse_name%TYPE;

    BEGIN
        SELECT Warehouse_name INTO temporary_wareHouse_Name FROM warehouse WHERE Warehouse_id=ware_houseId;
        ware_houseName:=UPPER(temporary_wareHouse_Name);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('NO SUCH RECORD FOUND. Check Warehouse ID Again');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM||'Error is occurred. Error Code is '||SQLCODE);
    END get_warehouseName;

    -- b. Function to get discounted price of a given product

    FUNCTION get_discountPrice (productID product.product_id%TYPE)RETURN NUMBER IS
        product_price product.list_price%TYPE;
        discount_price NUMBER(10,2):=0;

    BEGIN
            SELECT list_price INTO product_price FROM PRODUCT WHERE product_id=productID;

    CASE
        WHEN product_price<6000 THEN
            discount_price:=(product_price-(product_price*(12/100)));
        WHEN product_price<12000 THEN
            discount_price:=(product_price-(product_price*(16/100)));
        WHEN product_price>=12000 THEN
            discount_price:=(product_price-(product_price*(24/100)));
        END CASE;

    RETURN discount_price;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('RECORD NOT FOUND.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR');
        RAISE;
    END get_discountPrice;


    PROCEDURE get_profit IS
        total_profit NUMBER(10,2):=0;
        temporary_listPrice product.list_price%TYPE;
        temporary_profit NUMBER(10,2);

    TYPE array_itemPrice IS TABLE OF product.list_price%TYPE INDEX BY product.product_id%TYPE;
         array_productPrice array_itemPrice;

    CURSOR cur_getPrice IS select product_id,list_price from product order by product_id;
    CURSOR cur_getInventory IS select product_id,sum(qty_on_hand) as sum_qty from inventory group by product_id order by product_id;

    BEGIN

        FOR i IN cur_getPrice LOOP
             array_productPrice(i.product_id):=i.list_price;
        END LOOP;

        FOR j IN cur_getInventory LOOP

            temporary_listPrice:=array_productPrice(j.product_id);
            temporary_profit :=(temporary_listPrice*j.sum_qty)*0.1;
            total_profit:=total_profit+temporary_profit;

         END LOOP;
        G_total_profit_no_discount:=total_profit;

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('RECORD NOT FOUND.');
        WHEN OTHERS THEN
             DBMS_OUTPUT.PUT_LINE(SQLERRM||'ERROR HAS OCCURED , ERROR IN  '||SQLCODE);

    END get_profit;



-- d. Function overloading:

    PROCEDURE get_profit(discount IN NUMBER, productId IN product.product_id%TYPE, product_discountPrice OUT NUMBER, totalDiscount OUT NUMBER, totalProfit OUT Number) IS

        total_profit NUMBER:=0;
        temporary_discountPrice NUMBER(10,2);
        total_discountPrice NUMBER(10,2):=0;
        temporary_listPrice product.list_price%TYPE;
        temporary_profit NUMBER(10,2);

    TYPE array_itemPrice IS TABLE OF product.list_price%TYPE INDEX BY product.product_id%TYPE;
        array_productPrice array_itemPrice;

    CURSOR cur_getPrice IS select product_id,list_price from product order by product_id;
    CURSOR cur_getInventory IS select product_id,sum(qty_on_hand) as sum_qty from inventory where product_id=productId group by product_id;


    BEGIN

    FOR i IN cur_getPrice LOOP

            array_productPrice(i.product_id):=i.list_price;

        END LOOP;

    FOR j IN cur_getInventory LOOP

        temporary_listPrice:=array_productPrice(j.product_id);
        temporary_discountPrice:=temporary_listPrice-(temporary_listPrice*discount);
        product_discountPrice :=temporary_discountPrice;
        temporary_profit :=(temporary_discountPrice*j.sum_qty)*0.1;
        total_profit:=total_profit+temporary_profit;
        total_discountPrice:=total_discountPrice+(temporary_discountPrice*j.sum_qty);

    END LOOP;

        totalDiscount:=total_discountPrice;
        totalProfit:=total_profit;

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('RECORD NOT FOUND.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM||'ERROR HAS OCCURED , ERROR IN '||SQLCODE);

    END get_profit;



-- e. Procedure to compute total profit with discounts:

    PROCEDURE get_profit_with_discount(discount IN NUMBER) IS


        total_profit NUMBER(10,2):=0;
        calculated_discountPrice NUMBER(10,2);
        temporary_listPrice product.list_price%TYPE;
        calculated_profit NUMBER(10,2);

    TYPE array_itemPrice IS TABLE OF product.list_price%TYPE INDEX BY product.product_id%TYPE;
        arr_product_price array_itemPrice;

    CURSOR cur_getPrice IS select product_id,list_price from product order by product_id;
    CURSOR cur_getInventory IS select product_id,sum(qty_on_hand) as qty_on_hand from inventory group by product_id order by product_id;

    BEGIN

        FOR record IN cur_getPrice LOOP

             arr_product_price(record.product_id):=record.list_price;

        END LOOP;

        G_discount_percentage:=discount;

        FOR record2 IN cur_getInventory LOOP

            temporary_listPrice:=arr_product_price(record2.product_id);
            calculated_discountPrice:=temporary_listPrice-(temporary_listPrice*discount);
            calculated_profit :=(calculated_discountPrice*record2.qty_on_hand)*0.1;
            total_profit:=total_profit+calculated_profit;

        END LOOP;
        G_total_profit_with_discount:=total_profit;

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('RECORD NOT FOUND.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM||'ERROR HAS OCCURED , ERROR IN  '||SQLCODE);

    END get_profit_with_discount;



END pkg_trade_processing;
/

-- f. Calling package methods:

DECLARE

    wareHouse_name warehouse.warehouse_name%TYPE;
    total_discountPrice NUMBER(10,2);
    total_product_discountPrice NUMBER(24,2);
    sales_with_discount Number(10,2);
    profit_with_discount NUMBER(10,2);


BEGIN

    pkg_trade_processing.get_profit;
    DBMS_OUTPUT.PUT_LINE('The total profit of the current inventory with no discounts     :  '|| pkg_trade_processing.G_total_profit_no_discount);

    pkg_trade_processing.get_profit_with_discount(0.1);
    DBMS_OUTPUT.PUT_LINE('The total profit of the current inventory with ' || pkg_trade_processing.G_discount_percentage* 100|| '% of discount : '
                ||pkg_trade_processing.G_total_profit_with_discount);

    pkg_trade_processing.get_profit_with_discount(0.15);
    DBMS_OUTPUT.PUT_LINE('The total profit of the current inventory with '||pkg_trade_processing.G_discount_percentage* 100|| '% of discount : '
                || pkg_trade_processing.G_total_profit_with_discount);

    total_discountPrice:= pkg_trade_processing.get_discountPrice('PRD01');
    DBMS_OUTPUT.PUT_LINE('The discounted price of the product PRD01 : '||total_discountPrice);

    pkg_trade_processing.get_profit(0.2, 'PRD01', total_product_discountPrice, sales_with_discount, profit_with_discount);
    DBMS_OUTPUT.PUT_LINE('Product PRD01 discount price with 20% discount :'||total_product_discountPrice);


END;
/


	--:VAR_ROW_COUNT:=0;
	EXECUTE PROC_POSTAL_ADDRESS(:VAR_ROW_COUNT);
	print VAR_ROW_COUNT;


