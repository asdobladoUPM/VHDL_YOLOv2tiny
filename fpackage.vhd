LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

PACKAGE myPackage IS
    -- contant value to add 1 i.e. num1 + 1 
    CONSTANT S : signed (3 DOWNTO 0) := "0001";

    -- add two number i.e. num1 + num2
    PROCEDURE sum2num(SIGNAL a : IN signed(3 DOWNTO 0);
    SIGNAL b : IN signed(3 DOWNTO 0);
    SIGNAL sum : OUT signed (3 DOWNTO 0));

    -- singals and types for ifLoop
    SIGNAL f : unsigned(2 DOWNTO 0) := (OTHERS => '0');
    TYPE stateType IS (startState, continueState, stopState);
END PACKAGE;

PACKAGE BODY myPackage IS

    -- procedure for adding two numbers i.e. num1 + num2
    PROCEDURE sum2num(SIGNAL a : IN signed(3 DOWNTO 0);
    SIGNAL b : IN signed(3 DOWNTO 0);
    SIGNAL sum : OUT signed (3 DOWNTO 0)) IS
BEGIN
    sum <= a + b;
END sum2num;
END myPackage;