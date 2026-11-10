--
-- Issue #15: a failing DML inside a transaction block without SAVEPOINT
-- leaves the transaction aborted.  The following statements must get the
-- regular 25P02 error and not an internal error raised by the extension
-- trying to access the catalog from the emit_log_hook.
--
CREATE TABLE t_abort (id int PRIMARY KEY);
CALL dbms_errlog.create_error_log('t_abort');

SET pg_dbms_errlog.enabled TO true;

-- synchronous = query: error is published immediately
SET pg_dbms_errlog.synchronous = query;
BEGIN;
INSERT INTO t_abort VALUES (1);
-- duplicate key, logged and not reported to the client
INSERT INTO t_abort VALUES (1);
-- must fail with 25P02
INSERT INTO t_abort VALUES (2);
UPDATE t_abort SET id = 3;
DELETE FROM t_abort;
COMMIT;
SELECT count(*) FROM t_abort;
SELECT "pg_err_number$", "pg_err_optyp$" FROM "ERR$_t_abort";

-- synchronous = transaction: queue is discarded when COMMIT rolls back
SET pg_dbms_errlog.synchronous = transaction;
BEGIN;
INSERT INTO t_abort VALUES (1);
INSERT INTO t_abort VALUES (1);
INSERT INTO t_abort VALUES (2);
COMMIT;
SELECT count(*) FROM t_abort;
SELECT count(*) FROM "ERR$_t_abort";

-- the session is still usable
SELECT 1 AS alive;

SET pg_dbms_errlog.enabled TO false;
DROP TABLE "ERR$_t_abort";
DROP TABLE t_abort;
