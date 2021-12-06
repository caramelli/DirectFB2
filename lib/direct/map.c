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

#include <direct/debug.h>
#include <direct/map.h>
#include <direct/mem.h>
#include <direct/messages.h>

D_DEBUG_DOMAIN( Direct_Map, "Direct/Map", "Direct Map implementation" );

/**********************************************************************************************************************/

#define REMOVED ((void*) -1)

typedef struct {
     unsigned int  hash;
     void         *object;
} MapEntry;

struct __D_DirectMap {
     int                   magic;

     unsigned int          size;

     unsigned int          count;
     unsigned int          removed;

     MapEntry             *entries;

     DirectMapCompareFunc  compare;
     DirectMapHashFunc     hash;
     void                 *ctx;
};

#define DIRECT_MAP_ASSERT(map)              \
     do {                                   \
          D_MAGIC_ASSERT( map, DirectMap ); \
     } while (0)

/**********************************************************************************************************************/

static int
locate_entry( DirectMap    *map,
              unsigned int  hash,
              const void   *key )
{
     int             pos;
     const MapEntry *entry;

     D_DEBUG_AT( Direct_Map, "%s( hash %u )\n", __FUNCTION__, hash );

     DIRECT_MAP_ASSERT( map );
     D_ASSERT( key != NULL );

     pos = hash % map->size;

     entry = &map->entries[pos];

     while (entry->object) {
          if (entry->object != REMOVED && entry->hash == hash && map->compare( map, key, entry->object, map->ctx ))
               return pos;

          if (++pos == map->size)
               pos = 0;

          entry = &map->entries[pos];
     }

     return -1;
}

static DirectResult
resize_map( DirectMap    *map,
            unsigned int  size )
{
     unsigned int  i, pos;
     MapEntry     *entries;

     D_DEBUG_AT( Direct_Map, "%s( size %u )\n", __FUNCTION__, size );

     DIRECT_MAP_ASSERT( map );
     D_ASSERT( size > 3 );

     entries = D_CALLOC( size, sizeof(MapEntry) );
     if (!entries)
          return D_OOM();

     for (i = 0; i < map->size; i++) {
          MapEntry *entry = &map->entries[i];
          MapEntry *insertElement;

          if (entry->object && entry->object != REMOVED) {
               pos = entry->hash % size;

               insertElement = &entries[pos];
               while (insertElement->object && insertElement->object != REMOVED) {
                   if (++pos == size)
                       pos = 0;
                   insertElement = &entries[pos];
               }

               entries[pos] = *entry;
          }
     }

     D_FREE( map->entries );

     map->size    = size;
     map->entries = entries;
     map->removed = 0;

     return DR_OK;
}

/**********************************************************************************************************************/

DirectResult
direct_map_create( unsigned int           initial_size,
                   DirectMapCompareFunc   compare_func,
                   DirectMapHashFunc      hash_func,
                   void                  *ctx,
                   DirectMap            **ret_map )
{
     DirectMap *map;

     D_DEBUG_AT( Direct_Map, "%s( size %u, compare %p, hash %p )\n", __FUNCTION__,
                 initial_size, compare_func, hash_func );

     D_ASSERT( compare_func != NULL );
     D_ASSERT( hash_func != NULL );
     D_ASSERT( ret_map != NULL );

     if (initial_size < 3)
          initial_size = 3;

     map = D_CALLOC( 1, sizeof(DirectMap) );
     if (!map)
          return D_OOM();

     map->entries = D_CALLOC( initial_size, sizeof(MapEntry) );
     if (!map->entries) {
          D_FREE( map );
          return D_OOM();
     }

     map->size    = initial_size;
     map->compare = compare_func;
     map->hash    = hash_func;
     map->ctx     = ctx;

     D_MAGIC_SET( map, DirectMap );

     *ret_map = map;

     return DR_OK;
}

void
direct_map_destroy( DirectMap *map )
{
     D_DEBUG_AT( Direct_Map, "%s()\n", __FUNCTION__ );

     DIRECT_MAP_ASSERT( map );

     D_MAGIC_CLEAR( map );

     D_FREE( map->entries );
     D_FREE( map );
}

DirectResult
direct_map_insert( DirectMap  *map,
                   const void *key,
                   void       *object )
{
     unsigned int  hash;
     int           pos;
     MapEntry     *entry;

     D_DEBUG_AT( Direct_Map, "%s( key %p, object %p )\n", __FUNCTION__, key, object );

     DIRECT_MAP_ASSERT( map );
     D_ASSERT( key != NULL );
     D_ASSERT( object != NULL );

     if ((map->count + map->removed) > map->size / 4)
          resize_map( map, map->size * 3 );

     hash = map->hash( map, key, map->ctx );
     pos  = hash % map->size;

     D_DEBUG_AT( Direct_Map, "  -> hash %u, pos %d\n", hash, pos );

     entry = &map->entries[pos];

     while (entry->object && entry->object != REMOVED) {
          if (entry->hash == hash && map->compare( map, key, entry->object, map->ctx )) {
               if (entry->object == object) {
                    D_DEBUG_AT( Direct_Map, "  -> same object with matching key already exists\n" );
                    return DR_BUSY;
               }
               else {
                    D_DEBUG_AT( Direct_Map, "  -> different object with matching key already exists\n" );
                    D_BUG( "different object with matching key already exists" );
                    return DR_BUG;
               }
          }

          if (++pos == map->size)
               pos = 0;

          entry = &map->entries[pos];
     }

     if (entry->object == REMOVED)
          map->removed--;

     entry->hash   = hash;
     entry->object = object;

     map->count++;

     D_DEBUG_AT( Direct_Map, "  -> new count = %u, removed = %u, size = %u\n", map->count, map->removed, map->size );

     return DR_OK;
}

DirectResult
direct_map_remove( DirectMap  *map,
                   const void *key )
{
     unsigned int hash;
     int          pos;

     D_DEBUG_AT( Direct_Map, "%s( key %p )\n", __FUNCTION__, key );

     DIRECT_MAP_ASSERT( map );
     D_ASSERT( key != NULL );

     hash = map->hash( map, key, map->ctx );

     pos = locate_entry( map, hash, key );
     if (pos == -1) {
          D_WARN( "object to remove not found" );
          return DR_ITEMNOTFOUND;
     }

     map->entries[pos].object = REMOVED;

     map->count--;
     map->removed++;

     D_DEBUG_AT( Direct_Map, "  -> new count = %u, removed = %u, size = %u\n", map->count, map->removed, map->size );

     return DR_OK;
}

void *
direct_map_lookup( DirectMap  *map,
                   const void *key )
{
     unsigned int hash;
     int          pos;

     D_DEBUG_AT( Direct_Map, "%s( key %p )\n", __FUNCTION__, key );

     DIRECT_MAP_ASSERT( map );
     D_ASSERT( key != NULL );

     hash = map->hash( map, key, map->ctx );

     pos = locate_entry( map, hash, key );

     return (pos != -1) ? map->entries[pos].object : NULL;
}

void
direct_map_iterate( DirectMap             *map,
                    DirectMapIteratorFunc  func,
                    void                  *ctx )
{
     unsigned int i;

     D_DEBUG_AT( Direct_Map, "%s( func %p )\n", __FUNCTION__, func );

     DIRECT_MAP_ASSERT( map );
     D_ASSERT( func != NULL );

     for (i = 0; i < map->size; i++) {
          MapEntry *entry = &map->entries[i];

          if (entry->object && entry->object != REMOVED) {
               switch (func( map, entry->object, ctx )) {
                    case DENUM_OK:
                         break;

                    case DENUM_CANCEL:
                         return;

                    case DENUM_REMOVE:
                         entry->object = REMOVED;

                         map->count--;
                         map->removed++;
               }
          }
     }
}
