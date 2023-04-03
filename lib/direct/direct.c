/*
   This file is part of DirectFB.

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with this library; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA
*/

#include <direct/direct.h>
#include <direct/interface.h>
#include <direct/list.h>
#include <direct/signals.h>
#include <direct/thread.h>
#include <direct/trace.h>

D_DEBUG_DOMAIN( Direct_Main, "Direct/Main", "Direct Main initialization and shutdown" );

/**********************************************************************************************************************/

struct __D_DirectCleanupHandler {
     DirectLink                link;

     int                       magic;

     DirectCleanupHandlerFunc  func;
     void                     *ctx;
};

/**********************************************************************************************************************/

static int          refs;
static DirectLink  *handlers;
static DirectMutex  main_lock;

/**********************************************************************************************************************/

void
__D_direct_init()
{
     direct_mutex_init( &main_lock );
}

void
__D_direct_deinit()
{
     direct_print_memleaks();

     direct_print_interface_leaks();

     direct_mutex_deinit( &main_lock );
}

/**********************************************************************************************************************/

DirectResult
direct_initialize()
{
     direct_clock_set_time( DIRECT_CLOCK_SESSION, 0 );

     direct_mutex_lock( &main_lock );

     D_DEBUG_AT( Direct_Main, "%s() called... (from %s)\n", __FUNCTION__,
                 direct_trace_lookup_symbol_at( direct_trace_get_caller() ) );

     if (refs++) {
          D_DEBUG_AT( Direct_Main, "...%d references now\n", refs );
          direct_mutex_unlock( &main_lock );
          return DR_OK;
     }
     else if (!direct_thread_self_name())
          direct_thread_set_name( "Main Thread" );

     D_DEBUG_AT( Direct_Main, "...first reference, initializing now\n" );

     direct_signals_initialize();

     direct_mutex_unlock( &main_lock );

     return DR_OK;
}

DirectResult
direct_shutdown()
{
     direct_mutex_lock( &main_lock );

     D_DEBUG_AT( Direct_Main, "%s() called... (from %s)\n", __FUNCTION__,
                 direct_trace_lookup_symbol_at( direct_trace_get_caller() ) );

     if (refs == 1) {
          D_DEBUG_AT( Direct_Main, "...shutting down now\n" );

          direct_signals_shutdown();

          D_DEBUG_AT( Direct_Main, "  -> done\n" );
     }
     else
          D_DEBUG_AT( Direct_Main, "...%d references left\n", refs - 1 );

     refs--;

     direct_mutex_unlock( &main_lock );

     return DR_OK;
}

static void
direct_atexit_handler( void )
{
     DirectCleanupHandler *handler, *temp;

     direct_list_foreach_safe (handler, temp, handlers) {
          D_DEBUG_AT( Direct_Main, "Calling cleanup func %p( %p )...\n", handler->func, handler->ctx );

          direct_list_remove( &handlers, &handler->link );

          handler->func( handler->ctx );

          D_MAGIC_CLEAR( handler );

          D_FREE( handler );
     }
}

DirectResult
direct_cleanup_handler_add( DirectCleanupHandlerFunc   func,
                            void                      *ctx,
                            DirectCleanupHandler     **ret_handler )
{
     DirectCleanupHandler *handler;

     D_ASSERT( func != NULL );
     D_ASSERT( ret_handler != NULL );

     D_DEBUG_AT( Direct_Main, "Adding cleanup handler %p with context %p...\n", func, ctx );

     handler = D_CALLOC( 1, sizeof(DirectCleanupHandler) );
     if (!handler) {
          return DR_NOLOCALMEMORY;
     }

     handler->func = func;
     handler->ctx  = ctx;

     D_MAGIC_SET( handler, DirectCleanupHandler );

     direct_mutex_lock( &main_lock );

     if (handlers == NULL)
          atexit( direct_atexit_handler );

     direct_list_append( &handlers, &handler->link );

     direct_mutex_unlock( &main_lock );

     *ret_handler = handler;

     return DR_OK;
}

DirectResult
direct_cleanup_handler_remove( DirectCleanupHandler *handler )
{
     D_MAGIC_ASSERT( handler, DirectCleanupHandler );

     D_DEBUG_AT( Direct_Main, "Removing cleanup handler %p with context %p...\n", handler->func, handler->ctx );

     /* Safety check, in case handler is removed from within itself being invoked. */
     if (handler->link.prev) {
          direct_mutex_lock( &main_lock );
          direct_list_remove( &handlers, &handler->link );
          direct_mutex_unlock( &main_lock );

          D_MAGIC_CLEAR( handler );

          D_FREE( handler );
     }

     return DR_OK;
}
