#include <stdlib.h>
#include <grass/gis.h>
#include <grass/raster.h>
#include <grass/glocale.h>
#include "global.h"


int open_files(void)
{
    char *name, *mapset, **err, *bandref;
    FILE *fd;
    int n, missing;

    I_init_group_ref(&ref);
    I_free_group_ref(&ref);
    I_get_subgroup_ref(group, subgroup, &ref);

    bandrefs = (char **)G_malloc(ref.nfiles * sizeof(char **));
    missing = 0;
    for (n = 0; n < ref.nfiles; n++) {
	name = ref.file[n].name;
	mapset = ref.file[n].mapset;
	if (G_find_raster(name, mapset) == NULL) {
	    missing = 1;
	    G_warning(_("Raster map <%s> do not exists in subgroup <%s>"),
		      G_fully_qualified_name(name, mapset), subgroup);
        }
        bandref = Rast_get_bandref_or_name(ref.file[n].name, ref.file[n].mapset);
        bandrefs[n] = G_store(bandref);
    }
    if (missing)
	G_fatal_error(_("No raster maps found"));

    if (ref.nfiles <= 1) {
	if (ref.nfiles <= 0)
	    G_warning(_("Subgroup <%s> doesn't have any raster maps"),
		      subgroup);
	else
	    G_warning(_("Subgroup <%s> only has 1 raster map"), subgroup);
	G_fatal_error(_("Subgroup must have at least 2 raster maps"));
    }

    cell = (DCELL **) G_malloc(ref.nfiles * sizeof(DCELL *));
    cellfd = (int *)G_malloc(ref.nfiles * sizeof(int));
    for (n = 0; n < ref.nfiles; n++) {
	cell[n] = Rast_allocate_d_buf();
	
	name = ref.file[n].name;
	mapset = ref.file[n].mapset;
	cellfd[n] = Rast_open_old(name, mapset);
    }

    if (insigfile) {
	fd = I_fopen_signature_file_old(insigfile);
	if (fd == NULL)
	    G_fatal_error(_("Unable to open seed signature file <%s>"),
			  insigfile);

	n = I_read_signatures(fd, &in_sig);
	fclose(fd);
	if (n < 0)
	    G_fatal_error(_("Unable to read signature file <%s>"),
			  insigfile);

	if (in_sig.nsigs > 255)
	    G_fatal_error(_("<%s> has too many signatures (limit is 255)"),
			  insigfile);

        err = I_sort_signatures_by_bandref(&in_sig, &ref);
        if (err)
            G_fatal_error(_("Signature – group member band reference mismatch.\n"
                "Extra signatures for bands: %s\n"
                "Imagery group bands without signatures: %s"),
                err[0] ? err[0] : _("none"),
                err[1] ? err[1] : _("none")
            );

	maxclass = in_sig.nsigs;
    }

    return 0;
}
