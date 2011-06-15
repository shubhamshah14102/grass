#include <grass/raster.h>
#include "G3d_intern.h"


/*!
 * \brief 
 *
 * Is equivalent to G3d_putValue (map, x, y, z, &value, FCELL_TYPE).
 *
 *  \param map
 *  \param x
 *  \param y
 *  \param z
 *  \param value
 *  \return int
 */

int G3d_putFloat(G3D_Map * map, int x, int y, int z, float value)
{
    int tileIndex, offs;
    float *tile;

    if (map->typeIntern == DCELL_TYPE) {
	if (!G3d_putDouble(map, x, y, z, (double)value)) {
	    G3d_error("G3d_putFloat: error in G3d_putDouble");
	    return 0;
	}
	return 1;
    }

    G3d_coord2tileIndex(map, x, y, z, &tileIndex, &offs);
    tile = (float *)G3d_getTilePtr(map, tileIndex);
    if (tile == NULL) {
	G3d_error("G3d_putFloat: error in G3d_getTilePtr");
	return 0;
    }

    tile[offs] = value;
    return 1;
}

/*---------------------------------------------------------------------------*/


/*!
 * \brief 
 *
 *  Is equivalent to G3d_putValue (map, x, y, z, &value, DCELL_TYPE).
 *
 *  \param map
 *  \param x
 *  \param y
 *  \param z
 *  \param value
 *  \return int
 */

int G3d_putDouble(G3D_Map * map, int x, int y, int z, double value)
{
    int tileIndex, offs;
    double *tile;

    if (map->typeIntern == FCELL_TYPE) {
	if (!G3d_putFloat(map, x, y, z, (float)value)) {
	    G3d_error("G3d_putDouble: error in G3d_putFloat");
	    return 0;
	}
	return 1;
    }

    G3d_coord2tileIndex(map, x, y, z, &tileIndex, &offs);
    tile = (double *)G3d_getTilePtr(map, tileIndex);
    if (tile == NULL) {
	G3d_error("G3d_putDouble: error in G3d_getTilePtr");
	return 0;
    }

    tile[offs] = value;
    return 1;
}

/*---------------------------------------------------------------------------*/

/*!
 * \brief 
 *
 * After converting <em>*value</em> of <em>type</em> into the type specified
 * at the initialization time (i.e. <em>typeIntern</em>) this function writes the
 * value into the tile buffer corresponding to cell-coordinate <em>(x, y, z)</em>.
 *
 *  \param map
 *  \param x
 *  \param y
 *  \param z
 *  \param value
 *  \param type
 *  \return 1 ... if successful,  
 *          0 ... otherwise.
 */

int
G3d_putValue(G3D_Map * map, int x, int y, int z, const void *value, int type)
{
    if (type == FCELL_TYPE) {
	if (!G3d_putFloat(map, x, y, z, *((float *)value))) {
	    G3d_error("G3d_putValue: error in G3d_putFloat");
	    return 0;
	}
	return 1;
    }

    if (!G3d_putDouble(map, x, y, z, *((double *)value))) {
	G3d_error("G3d_putValue: error in G3d_putDouble");
	return 0;
    }
    return 1;
}
