/*-------------------------------------------------------------------------
 *
 * pel_worker.h:
 * 	Implementation of bgworker for error queue processing.
 *
 * This program is open source, licensed under the PostgreSQL license.
 * For license terms, see the LICENSE file.
 *
 * Copyright (C) 2021: MigOps Inc
 *
 *-------------------------------------------------------------------------
 */

#ifndef _PEL_WORKER_H
#define _PEL_WORKER_H

#include "postgres.h"

#if PG_VERSION_NUM >= 100000
/*
 * pg_attribute_noreturn() was removed in PG19; pg_noreturn (C23 prefix form)
 * cannot be combined with PGDLLEXPORT.  Use __attribute__((noreturn)) as a
 * portable suffix that works on GCC/Clang across all supported versions.
 */
PGDLLEXPORT void pel_worker_main(Datum main_arg) __attribute__((noreturn));
PGDLLEXPORT void pel_dynworker_main(Datum main_arg);
#endif			/* pg10 */
#endif			/* _PEL_WORKER_H */
