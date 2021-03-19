
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE YOLO_pkg IS

  FUNCTION rows(SIGNAL layer : IN INTEGER := 1) RETURN INTEGER;

  FUNCTION columns(layers : INTEGER := 1) RETURN INTEGER;

  FUNCTION filters(layers : INTEGER := 1) RETURN INTEGER;

  FUNCTION channels(layers : INTEGER := 1) RETURN INTEGER;

  FUNCTION kernels(layers : INTEGER := 1) RETURN INTEGER;

END YOLO_pkg;

PACKAGE BODY YOLO_pkg IS

  FUNCTION rows(SIGNAL layer : IN INTEGER := 1) RETURN INTEGER IS
    VARIABLE rows : INTEGER;
  BEGIN
    CASE layer IS
      WHEN 1 =>
        rows := 416;
      WHEN 2 =>
        rows := 208;
      WHEN 3 =>
        rows := 104;
      WHEN 4 =>
        rows := 52;
      WHEN 5 =>
        rows := 26;
      WHEN OTHERS =>
        rows := 13;
    END CASE;
    RETURN rows;
  END rows;

  FUNCTION columns(layers : INTEGER := 1) RETURN INTEGER IS
    VARIABLE columns : INTEGER;
  BEGIN
    CASE layers IS
      WHEN 1 =>
        columns = 416;
      WHEN 2 =>
        columns = 208;
      WHEN 3 =>
        columns = 104;
      WHEN 4 =>
        columns = 52;
      WHEN 5 =>
        columns = 26;
      WHEN OTHERS =>
        columns = 13;
    END CASE;
    RETURN columns;
  END columns;

  FUNCTION filters(layers : INTEGER := 1) RETURN INTEGER IS
    VARIABLE filters : INTEGER;
  BEGIN
    CASE layers IS
      WHEN 1 =>
        filters = 16;
      WHEN 2 =>
        filters = 32;
      WHEN 3 =>
        filters = 64;
      WHEN 4 =>
        filters = 128;
      WHEN 5 =>
        filters = 256;
      WHEN 6 =>
        filters = 512;
      WHEN 7 =>
        filters = 1024;
      WHEN 8 =>
        filters = 512;
      WHEN 9 =>
        filters = 125;
      WHEN OTHERS =>
        filters = 0;
    END CASE;
    RETURN filters;
  END filters;

  FUNCTION channels(layers : INTEGER := 1) RETURN INTEGER IS
    VARIABLE channels : INTEGER;
  BEGIN
    CASE layers IS
      WHEN 1 =>
        channels = 3;
      WHEN 2 =>
        channels = 16;
      WHEN 3 =>
        channels = 32;
      WHEN 4 =>
        channels = 64;
      WHEN 5 =>
        channels = 128;
      WHEN 6 =>
        channels = 256;
      WHEN 7 =>
        channels = 512;
      WHEN 8 =>
        channels = 1024;
      WHEN 9 =>
        channels = 1024;
      WHEN OTHERS =>
        channels = 0;
    END CASE;
    RETURN channels;
  END channels;

  FUNCTION kernels(layers : INTEGER := 1) RETURN INTEGER IS
    VARIABLE kernels : INTEGER;
  BEGIN
    CASE layers IS
      WHEN 1 =>
        kernels = 1;
      WHEN 2 =>
        kernels = 2;
      WHEN 3 =>
        kernels = 2;
      WHEN 4 =>
        kernels = 2;
      WHEN 5 =>
        kernels = 2;
      WHEN 6 =>
        kernels = 2;
      WHEN 7 =>
        kernels = 8;
      WHEN 8 =>
        kernels = 8;
      WHEN 9 =>
        kernels = 2;
      WHEN OTHERS =>
        kernels = 0;
    END CASE;
    RETURN kernels;
  END kernels;

END YOLO_pkg;